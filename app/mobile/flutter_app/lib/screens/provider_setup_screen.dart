import 'package:flutter/material.dart';

import '../widgets/product_widgets.dart';

class ProviderSetupScreen extends StatefulWidget {
  const ProviderSetupScreen({
    super.key,
    required this.currentProvider,
    required this.onProviderChanged,
    required this.onFinish,
  });

  final String currentProvider;
  final ValueChanged<String> onProviderChanged;
  final VoidCallback onFinish;

  @override
  State<ProviderSetupScreen> createState() => _ProviderSetupScreenState();
}

class _ProviderSetupScreenState extends State<ProviderSetupScreen> {
  static const List<String> _providers = <String>[
    'Local Runtime',
    'OpenClaw Cloud',
    'Custom Endpoint',
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider setup'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          const ClawBrandMark(showLabel: false),
          const SizedBox(height: 12),
          Text(
            'Choose your primary provider',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can change this later in settings. Keep it simple for now.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: _providers
                  .map(
                    (String provider) => RadioListTile<String>(
                      value: provider,
                      groupValue: _selected,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(provider),
                      subtitle: Text(_descriptionFor(provider)),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selected = value);
                        widget.onProviderChanged(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onFinish,
              icon: const Icon(Icons.done),
              label: const Text('Enter PocketClaw'),
            ),
          ),
        ],
      ),
    );
  }

  String _descriptionFor(String provider) {
    switch (provider) {
      case 'Local Runtime':
        return 'Best for local development and low latency control.';
      case 'OpenClaw Cloud':
        return 'Managed runtime with remote sync and fleet visibility.';
      case 'Custom Endpoint':
        return 'Use your own API endpoint and runtime bridge.';
      default:
        return '';
    }
  }
}
