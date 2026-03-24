import 'package:flutter/material.dart';

import '../widgets/product_widgets.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: <Widget>[
        const ScreenHeader(
          title: 'Diagnostics',
          subtitle: 'Inspect health, events, and runtime logs.',
          trailing: Icon(Icons.bug_report_outlined),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Health summary',
          trailing: StatusDot(
            color: Colors.orange.shade700,
            label: 'Attention',
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SummaryMetric(label: 'Checks passing', value: '8 / 9'),
              SizedBox(height: 8),
              _SummaryMetric(label: 'Active warnings', value: '1'),
              SizedBox(height: 8),
              _SummaryMetric(label: 'Last full scan', value: 'Today, 09:12'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SectionCard(
          title: 'Recent events',
          child: Column(
            children: <Widget>[
              _EventRow(time: '09:15', level: 'INFO', message: 'Runtime heartbeat acknowledged'),
              Divider(height: 20),
              _EventRow(time: '09:13', level: 'WARN', message: 'Event stream delay above threshold'),
              Divider(height: 20),
              _EventRow(time: '09:10', level: 'INFO', message: 'Queue processor resumed after idle'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Log preview',
          subtitle: 'Most recent entries',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '[09:15:02] INFO  runtime: heartbeat ok\n'
              '[09:13:44] WARN  stream: consumer lag 1.4s\n'
              '[09:10:21] INFO  queue: resumed (3 tasks pending)\n'
              '[09:09:58] INFO  runtime: worker_1 online',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.time,
    required this.level,
    required this.message,
  });

  final String time;
  final String level;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          time,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: level == 'WARN'
                ? Colors.orange.shade100
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(level, style: Theme.of(context).textTheme.labelSmall),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(message)),
      ],
    );
  }
}
