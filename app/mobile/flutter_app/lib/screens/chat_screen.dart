import 'dart:async' show unawaited;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/runtime_client.dart';
import '../services/unified_chat_service.dart';
import '../widgets/product_widgets.dart';

class _ChatBubble {
  const _ChatBubble({
    required this.author,
    required this.text,
    required this.isAssistant,
    required this.timestamp,
    this.attachmentName,
  });

  final String author;
  final String text;
  final bool isAssistant;
  final String timestamp;
  final String? attachmentName;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.session});

  final RuntimeClient session;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final SpeechToText _speech = SpeechToText();

  List<_ChatBubble> _messages = <_ChatBubble>[];
  bool _speechReady = false;
  String? _pendingAttachmentName;
  bool _welcomeSeeded = false;
  /// True while an SSE stream (gateway or OpenAI) updates the last assistant bubble.
  bool _liveStreaming = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _initSpeech();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_welcomeSeeded) {
      return;
    }
    _welcomeSeeded = true;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String pc = widget.session.providerConfig.displayLabel;
    _messages = <_ChatBubble>[
      _ChatBubble(
        author: l10n.chatAuthorAssistant,
        text: l10n.chatWelcomeBody(pc, widget.session.deployment.displayLabel),
        isAssistant: true,
        timestamp: _timeLabel(DateTime.now()),
      ),
    ];
  }

  Future<void> _initSpeech() async {
    final bool available = await _speech.initialize(
      onError: (error) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.errorMsg)),
        );
      },
      onStatus: (String status) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    if (mounted) {
      setState(() => _speechReady = available);
    }
  }

  @override
  void dispose() {
    if (_speech.isListening) {
      unawaited(_speech.cancel());
    }
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _timeLabel(DateTime t) {
    final String h = t.hour.toString().padLeft(2, '0');
    final String m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickAttachment() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final PlatformFile f = result.files.single;
    if (!mounted) {
      return;
    }
    setState(() => _pendingAttachmentName = f.name);
  }

  Future<void> _toggleSpeechInput() async {
    if (!_speechReady) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.chatSpeechUnavailable)),
        );
      }
      return;
    }
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() {});
      }
      return;
    }
    await _speech.listen(
      onResult: (result) {
        if (!mounted) {
          return;
        }
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
      listenFor: const Duration(seconds: 120),
      pauseFor: const Duration(seconds: 4),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _send() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String text = _controller.text.trim();
    final String? attachment = _pendingAttachmentName;
    if (text.isEmpty && attachment == null) {
      return;
    }
    if (_speech.isListening) {
      await _speech.stop();
    }
    _controller.clear();
    setState(() => _pendingAttachmentName = null);
    final DateTime now = DateTime.now();
    setState(() {
      _messages = <_ChatBubble>[
        ..._messages,
        _ChatBubble(
          author: l10n.chatAuthorYou,
          text: text.isEmpty ? l10n.chatNoMessagePlaceholder : text,
          isAssistant: false,
          timestamp: _timeLabel(now),
          attachmentName: attachment,
        ),
      ];
    });
    _scrollToEnd();

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }

    if (text.isEmpty) {
      final String reply = widget.session.mockAssistantReply(
        l10n,
        text,
        attachmentName: attachment,
      );
      final DateTime replyAt = DateTime.now();
      setState(() {
        _messages = <_ChatBubble>[
          ..._messages,
          _ChatBubble(
            author: l10n.chatAuthorAssistant,
            text: reply,
            isAssistant: true,
            timestamp: _timeLabel(replyAt),
          ),
        ];
      });
      _scrollToEnd();
      return;
    }

    final bool canStreamLive = await UnifiedChatService.hasLiveStreamBackend();
    if (canStreamLive) {
      final DateTime placeholderAt = DateTime.now();
      setState(() {
        _liveStreaming = true;
        _messages = <_ChatBubble>[
          ..._messages,
          _ChatBubble(
            author: l10n.chatAuthorAssistant,
            text: '',
            isAssistant: true,
            timestamp: _timeLabel(placeholderAt),
          ),
        ];
      });
      _scrollToEnd();

      String accumulated = '';
      try {
        await for (
            final String acc in UnifiedChatService.streamCompletionAccumulated(
          model: widget.session.providerConfig.modelProfileLabel,
          userText: text,
        )) {
          if (!mounted) {
            return;
          }
          accumulated = acc;
          setState(() {
            final List<_ChatBubble> next = List<_ChatBubble>.from(_messages);
            next[next.length - 1] = _ChatBubble(
              author: l10n.chatAuthorAssistant,
              text: acc,
              isAssistant: true,
              timestamp: _timeLabel(placeholderAt),
            );
            _messages = next;
          });
          _scrollToEnd();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.chatBackendErrorFallback(e.toString()))),
          );
        }
        String? fallback;
        try {
          fallback = await UnifiedChatService.completeOrNull(
            model: widget.session.providerConfig.modelProfileLabel,
            userText: text,
          );
        } catch (_) {
          fallback = null;
        }
        accumulated = (fallback != null && fallback.isNotEmpty)
            ? fallback
            : widget.session.mockAssistantReply(
                l10n,
                text,
                attachmentName: attachment,
              );
        if (!mounted) {
          return;
        }
        setState(() {
          final List<_ChatBubble> next = List<_ChatBubble>.from(_messages);
          next[next.length - 1] = _ChatBubble(
            author: l10n.chatAuthorAssistant,
            text: accumulated,
            isAssistant: true,
            timestamp: _timeLabel(placeholderAt),
          );
          _messages = next;
        });
      } finally {
        if (mounted) {
          setState(() => _liveStreaming = false);
        } else {
          _liveStreaming = false;
        }
      }

      if (!mounted) {
        return;
      }
      if (accumulated.isEmpty) {
        String? fallback;
        try {
          fallback = await UnifiedChatService.completeOrNull(
            model: widget.session.providerConfig.modelProfileLabel,
            userText: text,
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.chatBackendErrorFallback(e.toString()))),
            );
          }
          fallback = null;
        }
        final String finalText = (fallback != null && fallback.isNotEmpty)
            ? fallback
            : widget.session.mockAssistantReply(
                l10n,
                text,
                attachmentName: attachment,
              );
        if (!mounted) {
          return;
        }
        setState(() {
          final List<_ChatBubble> next = List<_ChatBubble>.from(_messages);
          next[next.length - 1] = _ChatBubble(
            author: l10n.chatAuthorAssistant,
            text: finalText,
            isAssistant: true,
            timestamp: _timeLabel(placeholderAt),
          );
          _messages = next;
        });
      }
      _scrollToEnd();
      return;
    }

    String reply;
    try {
      final String? api = await UnifiedChatService.completeOrNull(
        model: widget.session.providerConfig.modelProfileLabel,
        userText: text,
      );
      if (api != null && api.isNotEmpty) {
        reply = api;
      } else {
        reply = widget.session.mockAssistantReply(
          l10n,
          text,
          attachmentName: attachment,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.chatBackendErrorFallback(e.toString()))),
        );
      }
      reply = widget.session.mockAssistantReply(
        l10n,
        text,
        attachmentName: attachment,
      );
    }
    final DateTime replyAt = DateTime.now();
    setState(() {
      _messages = <_ChatBubble>[
        ..._messages,
        _ChatBubble(
          author: l10n.chatAuthorAssistant,
          text: reply,
          isAssistant: true,
          timestamp: _timeLabel(replyAt),
        ),
      ];
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) {
        return;
      }
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool listening = _speech.isListening;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool canSend =
        _controller.text.trim().isNotEmpty || _pendingAttachmentName != null;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            children: <Widget>[
              ScreenHeader(
                title: l10n.chatTitle,
                subtitle: l10n.chatSubtitle,
                trailing: const Icon(Icons.bolt_outlined),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: l10n.chatAssistantSection,
                subtitle: l10n.chatAssistantSubtitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colors.primaryContainer,
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.chatAssistantHint),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ..._messages.map(_buildMessageBubble),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_pendingAttachmentName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InputChip(
                        avatar: const Icon(Icons.attach_file, size: 18),
                        label: Text(
                          _pendingAttachmentName!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onDeleted: () => setState(() => _pendingAttachmentName = null),
                      ),
                    ),
                  ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: _pickAttachment,
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: l10n.chatAttachTooltip,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: l10n.chatMessageHint,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      onPressed: _speechReady ? _toggleSpeechInput : null,
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: listening ? colors.primaryContainer : null,
                        foregroundColor: listening ? colors.onPrimaryContainer : null,
                      ),
                      tooltip: listening ? l10n.chatSpeechStopTooltip : l10n.chatSpeechTooltip,
                      icon: Icon(
                        listening ? Icons.stop_circle_outlined : Icons.mic_none_outlined,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: canSend ? _send : null,
                      tooltip: l10n.chatSendTooltip,
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.send_rounded, size: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(_ChatBubble message) {
    return Align(
      alignment: message.isAssistant ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Card(
          color: message.isAssistant
              ? null
              : Theme.of(context).colorScheme.primaryContainer,
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.author,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                if (message.attachmentName != null) ...<Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_file,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          message.attachmentName!,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                if (message.isAssistant &&
                    message.text.isEmpty &&
                    _liveStreaming)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.chatStreaming,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  )
                else
                  Text(message.text),
                const SizedBox(height: 8),
                Text(
                  message.timestamp,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
