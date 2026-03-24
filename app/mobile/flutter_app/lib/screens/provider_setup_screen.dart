import 'package:flutter/material.dart';

import '../models/runtime_deployment_model.dart';
import '../widgets/product_widgets.dart';

class ProviderSetupScreen extends StatefulWidget {
  const ProviderSetupScreen({
    super.key,
    required this.currentProvider,
    required this.currentDeployment,
    required this.onProviderChanged,
    required this.onDeploymentChanged,
    required this.onFinish,
  });

  final String currentProvider;
  final String currentDeployment;
  final ValueChanged<String> onProviderChanged;
  final ValueChanged<String> onDeploymentChanged;
  final VoidCallback onFinish;

  @override
  State<ProviderSetupScreen> createState() => _ProviderSetupScreenState();
}

class _ProviderSetupScreenState extends State<ProviderSetupScreen> {
  static const List<String> _deployments = <String>[
    RuntimeDeploymentModel.labelThisPhone,
    RuntimeDeploymentModel.labelHomeNetworkLan,
    RuntimeDeploymentModel.labelOpenClawCloud,
    RuntimeDeploymentModel.labelCustomGateway,
  ];

  static const List<String> _providers = <String>[
    'Local Runtime',
    'OpenClaw Cloud',
    'Custom Endpoint',
  ];

  late String _selectedProvider;
  late String _selectedDeployment;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.currentProvider;
    _selectedDeployment = widget.currentDeployment;
  }

  @override
  void didUpdateWidget(covariant ProviderSetupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentProvider != oldWidget.currentProvider) {
      _selectedProvider = widget.currentProvider;
    }
    if (widget.currentDeployment != oldWidget.currentDeployment) {
      _selectedDeployment = widget.currentDeployment;
    }
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
            'Connect PocketClaw',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick where the OpenClaw gateway should run, then choose how models are reached. You can change both later in settings.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            'Where OpenClaw runs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: _deployments
                  .map(
                    (String label) => RadioListTile<String>(
                      value: label,
                      groupValue: _selectedDeployment,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(label),
                      subtitle: Text(
                        RuntimeDeploymentModel.fromSelectionLabel(label).shortDescription,
                      ),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selectedDeployment = value);
                        widget.onDeploymentChanged(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Model / API provider',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: _providers
                  .map(
                    (String provider) => RadioListTile<String>(
                      value: provider,
                      groupValue: _selectedProvider,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(provider),
                      subtitle: Text(_descriptionFor(provider)),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selectedProvider = value);
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
