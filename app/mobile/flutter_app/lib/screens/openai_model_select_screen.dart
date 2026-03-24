import 'package:flutter/material.dart';

import '../flow/app_flow_controller.dart';
import '../models/openai_chat_model_option.dart';
import '../widgets/product_widgets.dart';

class OpenAiModelSelectScreen extends StatefulWidget {
  const OpenAiModelSelectScreen({
    super.key,
    required this.flow,
  });

  final AppFlowController flow;

  @override
  State<OpenAiModelSelectScreen> createState() => _OpenAiModelSelectScreenState();
}

class _OpenAiModelSelectScreenState extends State<OpenAiModelSelectScreen> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.flow.pendingOpenAiModelId ??
        OpenAiChatModelOption.defaults.first.id;
    widget.flow.setOpenAiModelId(_selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a model')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          const ClawBrandMark(showLabel: false),
          const SizedBox(height: 16),
          Text(
            'ChatGPT models',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick which model PocketClaw uses for chat. You can change this later in settings.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: OpenAiChatModelOption.defaults
                  .map(
                    (OpenAiChatModelOption m) => RadioListTile<String>(
                      value: m.id,
                      groupValue: _selectedId,
                      title: Text(m.label),
                      subtitle: m.subtitle != null ? Text(m.subtitle!) : null,
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selectedId = value);
                        widget.flow.setOpenAiModelId(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => widget.flow.completeModelSelection(),
              icon: const Icon(Icons.check),
              label: const Text('Continue to PocketClaw'),
            ),
          ),
        ],
      ),
    );
  }
}
