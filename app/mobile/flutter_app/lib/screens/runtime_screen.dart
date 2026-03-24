import 'package:flutter/material.dart';

import '../widgets/product_widgets.dart';

class RuntimeScreen extends StatelessWidget {
  const RuntimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: <Widget>[
        const ScreenHeader(
          title: 'Runtime',
          subtitle: 'Control background activity and inspect live state.',
          trailing: Icon(Icons.play_circle_outline),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Runtime status',
          subtitle: 'Last heartbeat 14s ago',
          trailing: StatusDot(
            color: Colors.green.shade600,
            label: 'Healthy',
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Mode: Active'),
              SizedBox(height: 4),
              Text('Workers: 2 online, 0 restarting'),
              SizedBox(height: 4),
              Text('Queue depth: 3 pending tasks'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Quick actions',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Restart runtime'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.task_alt_outlined),
                label: const Text('Run health check'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.schedule_outlined),
                label: const Text('Pause queue'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Health checks',
          child: Column(
            children: const <Widget>[
              _RuntimeCheckRow(name: 'API connectivity', detail: 'Stable, 42 ms', ok: true),
              Divider(height: 20),
              _RuntimeCheckRow(name: 'Storage access', detail: 'Readable and writable', ok: true),
              Divider(height: 20),
              _RuntimeCheckRow(name: 'Event stream', detail: '1 delayed message', ok: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _RuntimeCheckRow extends StatelessWidget {
  const _RuntimeCheckRow({
    required this.name,
    required this.detail,
    required this.ok,
  });

  final String name;
  final String detail;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          ok ? Icons.check_circle_outline : Icons.error_outline,
          color: ok ? Colors.green.shade700 : Colors.orange.shade700,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(detail, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
