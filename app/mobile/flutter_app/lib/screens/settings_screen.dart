import 'package:flutter/material.dart';

import '../services/mock_runtime_service.dart';
import '../widgets/product_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.session});

  final MockRuntimeService session;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final String providerLabel = session.providerConfig.displayLabel;
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
              title: 'Provider',
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.account_tree_outlined,
                    title: 'Primary provider',
                    description: providerLabel,
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.info_outline,
                    title: 'Connection mode',
                    description: session.providerConfig.shortDescription,
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
