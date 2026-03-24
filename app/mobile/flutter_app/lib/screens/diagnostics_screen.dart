import 'package:flutter/material.dart';

import '../models/diagnostic_event.dart';
import '../models/runtime_state_model.dart';
import '../services/mock_runtime_service.dart';
import '../widgets/product_widgets.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key, required this.session});

  final MockRuntimeService session;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final RuntimeStateModel state = session.runtimeState;
        final List<RuntimeHealthCheckItem> checks = state.healthChecks;
        final int passing = checks.where((RuntimeHealthCheckItem c) => c.ok).length;
        final int total = checks.length;
        final int warnings = checks.where((RuntimeHealthCheckItem c) => !c.ok).length;
        final String checksLabel = total == 0 ? '—' : '$passing / $total';
        final String lastScan = session.lastHealthCheckAt == null
            ? '—'
            : _formatDayTime(session.lastHealthCheckAt!);

        final Color summaryColor;
        final String summaryLabel;
        if (state.lifecycle == RuntimeLifecycle.stopped) {
          summaryColor = Colors.grey.shade600;
          summaryLabel = 'Stopped';
        } else if (warnings > 0) {
          summaryColor = Colors.orange.shade700;
          summaryLabel = 'Attention';
        } else {
          summaryColor = Colors.green.shade600;
          summaryLabel = 'Healthy';
        }

        final List<DiagnosticEvent> events = session.diagnosticEvents.take(8).toList();

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
                color: summaryColor,
                label: summaryLabel,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SummaryMetric(label: 'Checks passing', value: checksLabel),
                  const SizedBox(height: 8),
                  _SummaryMetric(label: 'Active warnings', value: '$warnings'),
                  const SizedBox(height: 8),
                  _SummaryMetric(label: 'Last full scan', value: lastScan),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Recent events',
              child: events.isEmpty
                  ? Text(
                      'No events yet.',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : Column(
                      children: <Widget>[
                        for (int i = 0; i < events.length; i++) ...<Widget>[
                          if (i > 0) const Divider(height: 20),
                          _EventRow(
                            time: events[i].timeLabel,
                            level: events[i].level,
                            message: events[i].message,
                          ),
                        ],
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
                  session.logPreviewText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static String _formatDayTime(DateTime t) {
    final String h = t.hour.toString().padLeft(2, '0');
    final String m = t.minute.toString().padLeft(2, '0');
    return 'Today, $h:$m';
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
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isWarn = level == 'WARN';
    final bool isErr = level == 'ERROR';
    final Color badgeBg = isErr
        ? colors.errorContainer
        : isWarn
            ? colors.tertiaryContainer
            : colors.secondaryContainer;

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
            color: badgeBg,
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
