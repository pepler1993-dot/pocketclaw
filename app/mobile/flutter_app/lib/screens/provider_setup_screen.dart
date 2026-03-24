import 'package:flutter/material.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../widgets/product_widgets.dart';

class ProviderSetupScreen extends StatefulWidget {
  const ProviderSetupScreen({
    super.key,
    required this.providerConfig,
    required this.currentDeployment,
    required this.onModelProfileChanged,
    required this.onApiConnectionChanged,
    required this.onCustomApiBaseUrlChanged,
    required this.onDeploymentChanged,
    required this.onFinish,
  });

  final ProviderConfigModel providerConfig;
  final String currentDeployment;
  final ValueChanged<String> onModelProfileChanged;
  final ValueChanged<String> onApiConnectionChanged;
  final ValueChanged<String> onCustomApiBaseUrlChanged;
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

  late TextEditingController _customUrlController;

  @override
  void initState() {
    super.initState();
    _customUrlController = TextEditingController(
      text: widget.providerConfig.customApiBaseUrl ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant ProviderSetupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.providerConfig.customApiBaseUrl != oldWidget.providerConfig.customApiBaseUrl &&
        widget.providerConfig.customApiBaseUrl != _customUrlController.text) {
      _customUrlController.text = widget.providerConfig.customApiBaseUrl ?? '';
    }
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProviderConfigModel c = widget.providerConfig;
    final bool showCustomUrl = c.apiConnectionLabel == ProviderConfigModel.apiCustomBaseUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection setup'),
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
            'Like the OpenClaw shell: choose where the gateway runs, pick a model profile, then choose how API traffic is routed. You can change this later in settings.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            '1 · Where OpenClaw runs',
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
                      groupValue: widget.currentDeployment,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(label),
                      subtitle: Text(
                        RuntimeDeploymentModel.fromSelectionLabel(label).shortDescription,
                      ),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        widget.onDeploymentChanged(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '2 · Model',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: ProviderConfigModel.modelProfileLabels
                  .map(
                    (String model) => RadioListTile<String>(
                      value: model,
                      groupValue: c.modelProfileLabel,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(model),
                      subtitle: Text(_modelSubtitle(model)),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        widget.onModelProfileChanged(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '3 · API connection',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Where inference traffic goes (keys are configured in the gateway / environment, not here yet).',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: ProviderConfigModel.apiConnectionLabels
                  .map(
                    (String api) => RadioListTile<String>(
                      value: api,
                      groupValue: c.apiConnectionLabel,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(api),
                      subtitle: Text(_apiSubtitle(api)),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        widget.onApiConnectionChanged(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          if (showCustomUrl) ...<Widget>[
            const SizedBox(height: 12),
            TextField(
              controller: _customUrlController,
              onChanged: widget.onCustomApiBaseUrlChanged,
              decoration: const InputDecoration(
                labelText: 'Custom API base URL',
                hintText: 'https://api.example.com/v1',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
            ),
          ],
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

  String _modelSubtitle(String model) {
    switch (model) {
      case ProviderConfigModel.modelDefault:
        return 'Balanced default for general chat.';
      case ProviderConfigModel.modelFast:
        return 'Lower latency; smaller context window (mock).';
      case ProviderConfigModel.modelCapable:
        return 'Heavier reasoning; larger context (mock).';
      default:
        return '';
    }
  }

  String _apiSubtitle(String api) {
    switch (api) {
      case ProviderConfigModel.apiGatewayEmbedded:
        return 'Same routing as the gateway’s own config (typical local setup).';
      case ProviderConfigModel.apiOpenClawCloud:
        return 'Hosted OpenClaw inference.';
      case ProviderConfigModel.apiOpenAiCompatible:
        return 'OpenAI-compatible HTTP API.';
      case ProviderConfigModel.apiAnthropic:
        return 'Anthropic Messages API.';
      case ProviderConfigModel.apiCustomBaseUrl:
        return 'Point to your own base URL.';
      default:
        return '';
    }
  }
}
