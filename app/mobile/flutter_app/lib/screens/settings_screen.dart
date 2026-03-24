import 'package:flutter/material.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../services/mock_runtime_service.dart';
import '../widgets/product_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.session});

  final MockRuntimeService session;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _customApiUrlController;

  @override
  void initState() {
    super.initState();
    _customApiUrlController = TextEditingController(
      text: widget.session.providerConfig.customApiBaseUrl ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final String? newUrl = widget.session.providerConfig.customApiBaseUrl;
    final String? oldUrl = oldWidget.session.providerConfig.customApiBaseUrl;
    if (newUrl != oldUrl && newUrl != _customApiUrlController.text) {
      _customApiUrlController.text = newUrl ?? '';
    }
  }

  @override
  void dispose() {
    _customApiUrlController.dispose();
    super.dispose();
  }

  void _applyProviderConfig(ProviderConfigModel next) {
    widget.session.setProviderConfig(next);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.session,
      builder: (BuildContext context, Widget? child) {
        final MockRuntimeService session = widget.session;
        final ProviderConfigModel p = session.providerConfig;
        final List<String> deploymentLabels = <String>[
          RuntimeDeploymentModel.labelThisPhone,
          RuntimeDeploymentModel.labelHomeNetworkLan,
          RuntimeDeploymentModel.labelOpenClawCloud,
          RuntimeDeploymentModel.labelCustomGateway,
        ];
        final bool showCustomUrl = p.apiConnectionLabel == ProviderConfigModel.apiCustomBaseUrl;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: <Widget>[
            const ScreenHeader(
              title: 'Settings',
              subtitle: 'Tune behavior, notifications, and data collection.',
              trailing: Icon(Icons.settings_outlined),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Runtime location',
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.smartphone_outlined,
                    title: 'Where OpenClaw runs',
                    description: session.deployment.shortDescription,
                    trailing: DropdownButton<String>(
                      value: session.deployment.displayLabel,
                      underline: const SizedBox.shrink(),
                      items: deploymentLabels
                          .map(
                            (String label) => DropdownMenuItem<String>(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setDeployment(
                          RuntimeDeploymentModel.fromSelectionLabel(value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Model & API',
              subtitle: 'Shell-style: model first, then API routing',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Model', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: p.modelProfileLabel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: ProviderConfigModel.modelProfileLabels
                        .map(
                          (String m) => DropdownMenuItem<String>(
                            value: m,
                            child: Text(m),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      _applyProviderConfig(
                        ProviderConfigModel.fromSetup(
                          modelProfileLabel: value,
                          apiConnectionLabel: p.apiConnectionLabel,
                          customApiBaseUrl: p.customApiBaseUrl,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('API connection', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: p.apiConnectionLabel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: ProviderConfigModel.apiConnectionLabels
                        .map(
                          (String a) => DropdownMenuItem<String>(
                            value: a,
                            child: Text(a, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      _applyProviderConfig(
                        ProviderConfigModel.fromSetup(
                          modelProfileLabel: p.modelProfileLabel,
                          apiConnectionLabel: value,
                          customApiBaseUrl: value == ProviderConfigModel.apiCustomBaseUrl
                              ? p.customApiBaseUrl
                              : null,
                        ),
                      );
                    },
                  ),
                  if (showCustomUrl) ...<Widget>[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customApiUrlController,
                      onChanged: (String s) {
                        _applyProviderConfig(
                          ProviderConfigModel.fromSetup(
                            modelProfileLabel: p.modelProfileLabel,
                            apiConnectionLabel: p.apiConnectionLabel,
                            customApiBaseUrl: s,
                          ),
                        );
                      },
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
                  const SizedBox(height: 4),
                  Text(
                    p.shortDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Runtime preferences',
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.bolt_outlined,
                    title: 'Auto-start runtime',
                    description: 'Launch services when app opens',
                    trailing: Switch(
                      value: session.autoStartRuntime,
                      onChanged: (bool value) {
                        session.setAutoStart(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.notifications_outlined,
                    title: 'Alert level',
                    description: 'Only notify on warnings and failures',
                    trailing: DropdownButton<String>(
                      value: session.alertLevel,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(value: 'Quiet', child: Text('Quiet')),
                        DropdownMenuItem<String>(value: 'Moderate', child: Text('Moderate')),
                        DropdownMenuItem<String>(value: 'Verbose', child: Text('Verbose')),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setAlertLevel(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.wifi_tethering_outlined,
                    title: 'Sync frequency',
                    description: 'Push local state on a fixed cadence',
                    trailing: DropdownButton<String>(
                      value: session.syncFrequencyLabel,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(value: '15s', child: Text('15s')),
                        DropdownMenuItem<String>(value: '30s', child: Text('30s')),
                        DropdownMenuItem<String>(value: '60s', child: Text('60s')),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setSyncFrequencyLabel(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Data and privacy',
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.analytics_outlined,
                    title: 'Diagnostics upload',
                    description: 'Share anonymized crash and performance data',
                    trailing: Switch(
                      value: session.diagnosticsUploadEnabled,
                      onChanged: (bool value) {
                        session.setDiagnosticsUpload(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.delete_outline,
                    title: 'Clear local cache',
                    description: 'Remove downloaded logs and temp snapshots',
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.description,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
