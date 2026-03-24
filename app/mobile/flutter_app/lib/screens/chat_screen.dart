import 'dart:async' show unawaited;

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
  });

  final String author;
  final String text;
  final bool isAssistant;
  final String timestamp;
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

  @override
  void initState() {
    super.initState();
    _messages = <_ChatBubble>[
      _ChatBubble(
        author: 'PocketClaw',
        text:
            'You are connected to ${widget.session.providerConfig.displayLabel}. '
            'Ask for runtime status or diagnostics — or tap the microphone to speak.',
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
    if (text.isEmpty) {
      return;
    }
    if (_speech.isListening) {
      await _speech.stop();
    }
    _controller.clear();
    final DateTime now = DateTime.now();
    setState(() {
      _messages = <_ChatBubble>[
        ..._messages,
        _ChatBubble(
          author: 'You',
          text: text,
          isAssistant: false,
          timestamp: _timeLabel(now),
        ),
      ];
    });
    _scrollToEnd();

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }
    final String reply = widget.session.mockAssistantReply(text);
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
                        'Try: “runtime status”, “diagnostics”, or use the mic for speech-to-text.',
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
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Attach context',
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
