import 'package:flutter/material.dart';

import '../models/openai_chat_model_option.dart';
import '../models/runtime_deployment_model.dart';
import '../services/mock_runtime_service.dart';
import '../widgets/openai_api_key_section.dart';
import '../widgets/product_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.session,
    required this.onSignOut,
  });

  final MockRuntimeService session;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final List<String> deploymentLabels = <String>[
          RuntimeDeploymentModel.labelThisPhone,
          RuntimeDeploymentModel.labelHomeNetworkLan,
          RuntimeDeploymentModel.labelOpenClawCloud,
          RuntimeDeploymentModel.labelCustomGateway,
        ];
        final String rawModelId = session.providerConfig.modelProfileLabel;
        final bool knownModel = OpenAiChatModelOption.defaults.any(
          (OpenAiChatModelOption m) => m.id == rawModelId,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: <Widget>[
            const ScreenHeader(
              title: 'Settings',
              subtitle: 'OpenAI account, model, and runtime.',
              trailing: Icon(Icons.settings_outlined),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'OpenAI',
              subtitle: 'OAuth (PKCE) plus optional API key for chat. Key takes precedence for api.openai.com.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Chat model', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: rawModelId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: <DropdownMenuItem<String>>[
                      ...OpenAiChatModelOption.defaults.map(
                        (OpenAiChatModelOption m) => DropdownMenuItem<String>(
                          value: m.id,
                          child: Text(m.label),
                        ),
                      ),
                      if (!knownModel)
                        DropdownMenuItem<String>(
                          value: rawModelId,
                          child: Text(rawModelId),
                        ),
                    ],
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      session.setOpenAiChatModel(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const OpenAiApiKeySection(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final bool? ok = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sign out'),
                              content: const Text(
                                'You will need to sign in with OpenAI again and pick a model.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Sign out'),
                                ),
                              ],
                            );
                          },
                        );
                        if (ok == true && context.mounted) {
                          await onSignOut();
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out of OpenAI'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
