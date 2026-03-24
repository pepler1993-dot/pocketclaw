import 'package:flutter/material.dart';

import '../widgets/product_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  static const List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage(
      author: 'PocketClaw',
      text: 'Welcome back. Runtime is healthy and ready for your next command.',
      isAssistant: true,
      timestamp: '09:14',
    ),
    _ChatMessage(
      author: 'You',
      text: 'Run a quick status check and summarize anything unusual.',
      isAssistant: false,
      timestamp: '09:15',
    ),
    _ChatMessage(
      author: 'PocketClaw',
      text: 'No blockers detected. Queue depth is normal and latency is stable.',
      isAssistant: true,
      timestamp: '09:15',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            children: <Widget>[
              const ScreenHeader(
                title: 'Chat',
                subtitle: 'Talk to PocketClaw about runtime and diagnostics.',
                trailing: Icon(Icons.bolt_outlined),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Welcome',
                subtitle: 'Early preview',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Start with a quick command like "show runtime health" or ask for a diagnostics summary.',
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
                    decoration: const InputDecoration(
                      hintText: 'Message PocketClaw',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
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

class _ChatMessage {
  const _ChatMessage({
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
