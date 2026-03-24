import 'package:flutter/material.dart';

import '../widgets/product_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: <Widget>[
        const ScreenHeader(
          title: 'Settings',
          subtitle: 'Tune behavior, notifications, and data collection.',
          trailing: Icon(Icons.settings_outlined),
        ),
        const SizedBox(height: 16),
        const SectionCard(
          title: 'Account',
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.person_outline,
                title: 'Workspace profile',
                description: 'Connected as Kevin on local workspace',
              ),
              Divider(height: 20),
              _SettingRow(
                icon: Icons.lock_outline,
                title: 'Authentication',
                description: 'Session token expires in 12 days',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SectionCard(
          title: 'Runtime preferences',
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.bolt_outlined,
                title: 'Auto-start runtime',
                description: 'Launch services when app opens',
                trailingLabel: 'On',
              ),
              Divider(height: 20),
              _SettingRow(
                icon: Icons.notifications_outlined,
                title: 'Alert level',
                description: 'Only notify on warnings and failures',
                trailingLabel: 'Moderate',
              ),
              Divider(height: 20),
              _SettingRow(
                icon: Icons.wifi_tethering_outlined,
                title: 'Sync frequency',
                description: 'Push local state every 30 seconds',
                trailingLabel: '30s',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SectionCard(
          title: 'Data and privacy',
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.analytics_outlined,
                title: 'Diagnostics upload',
                description: 'Share anonymized crash and performance data',
                trailingLabel: 'Enabled',
              ),
              Divider(height: 20),
              _SettingRow(
                icon: Icons.delete_outline,
                title: 'Clear local cache',
                description: 'Remove downloaded logs and temp snapshots',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.description,
    this.trailingLabel,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? trailingLabel;

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
        if (trailingLabel != null) ...<Widget>[
          const SizedBox(width: 8),
          Text(trailingLabel!, style: Theme.of(context).textTheme.labelLarge),
        ],
      ],
    );
  }
}
