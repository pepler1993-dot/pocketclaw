import 'dart:async' show unawaited;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/mock_runtime_service.dart';
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

  final MockRuntimeService session;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final SpeechToText _speech = SpeechToText();

  late List<_ChatBubble> _messages;
  bool _speechReady = false;
  String? _pendingAttachmentName;

  @override
  void initState() {
    super.initState();
    final String pc = widget.session.providerConfig.displayLabel;
    _messages = <_ChatBubble>[
      _ChatBubble(
        author: 'PocketClaw',
        text:
            'Model/API: $pc. Gateway: ${widget.session.deployment.displayLabel}. '
            'Ask for runtime status, attach a file for a mock hand-off, or use the mic.',
        isAssistant: true,
        timestamp: _timeLabel(DateTime.now()),
      ),
    ];
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final bool available = await _speech.initialize(
      onError: (error) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech: ${error.errorMsg}')),
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
          const SnackBar(
            content: Text('Speech recognition is not available on this device.'),
          ),
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
          author: 'You',
          text: text.isEmpty ? '(no message)' : text,
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
    final String reply = widget.session.mockAssistantReply(
      text,
      attachmentName: attachment,
    );
    final DateTime replyAt = DateTime.now();
    setState(() {
      _messages = <_ChatBubble>[
        ..._messages,
        _ChatBubble(
          author: 'PocketClaw',
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
    final bool listening = _speech.isListening;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            children: <Widget>[
              const ScreenHeader(
                title: 'Chat',
                subtitle: 'Talk to PocketClaw about runtime and diagnostics.',
                trailing: Icon(Icons.bolt_outlined),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Assistant',
                subtitle: 'Mock replies (no network yet) · voice: microphone',
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
                    const Expanded(
                      child: Text(
                        'Try: “runtime status”, attach a file, or use the mic for speech-to-text.',
                      ),
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
                      tooltip: 'Attach file',
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: 'Message PocketClaw',
                          border: OutlineInputBorder(),
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
                      tooltip: listening ? 'Stop dictation' : 'Speech to text',
                      icon: Icon(
                        listening ? Icons.stop_circle_outlined : Icons.mic_none_outlined,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: _send,
                      tooltip: 'Send',
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
