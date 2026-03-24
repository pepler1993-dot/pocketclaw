import 'package:flutter/material.dart';

import '../persistence/openai_token_store.dart';

/// Optional OpenAI API key (`sk-…`) stored in secure storage for real Chat Completions.
class OpenAiApiKeySection extends StatefulWidget {
  const OpenAiApiKeySection({super.key});

  @override
  State<OpenAiApiKeySection> createState() => _OpenAiApiKeySectionState();
}

class _OpenAiApiKeySectionState extends State<OpenAiApiKeySection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _hasStoredKey = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final bool has = await OpenAiTokenStore.hasApiKey();
    if (mounted) {
      setState(() {
        _hasStoredKey = has;
        _loading = false;
        _controller.clear();
      });
    }
  }

  Future<void> _save() async {
    await OpenAiTokenStore.writeApiKey(_controller.text);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API key saved on this device.')),
    );
    await _refresh();
  }

  Future<void> _remove() async {
    await OpenAiTokenStore.deleteApiKey();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API key removed.')),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('API key (optional)', style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(
          'For reliable access to api.openai.com, paste an API key from '
          'platform.openai.com/api-keys. Stored encrypted on device only; never logged.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        if (_hasStoredKey)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'A key is saved. Enter a new one to replace it.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        TextField(
          controller: _controller,
          obscureText: true,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'OpenAI API key',
            hintText: 'sk-…',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            FilledButton.tonal(
              onPressed: _save,
              child: const Text('Save key'),
            ),
            if (_hasStoredKey) ...<Widget>[
              const SizedBox(width: 12),
              TextButton(
                onPressed: _remove,
                child: const Text('Remove key'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
