import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../models/diagnostic_event.dart';
import '../models/runtime_state_model.dart';
import '../services/runtime_client.dart';
import '../widgets/product_widgets.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key, required this.session});

  final RuntimeClient session;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
            : _formatDayTime(l10n, session.lastHealthCheckAt!);

        final Color summaryColor;
        final String summaryLabel;
        if (state.lifecycle == RuntimeLifecycle.stopped) {
          summaryColor = Colors.grey.shade600;
          summaryLabel = l10n.diagnosticsSummaryStopped;
        } else if (warnings > 0) {
          summaryColor = Colors.orange.shade700;
          summaryLabel = l10n.diagnosticsSummaryAttention;
        } else {
          summaryColor = Colors.green.shade600;
          summaryLabel = l10n.diagnosticsSummaryHealthy;
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
                  _SummaryMetric(label: l10n.diagnosticsChecksPassing, value: checksLabel),
                  const SizedBox(height: 8),
                  _SummaryMetric(label: l10n.diagnosticsActiveWarnings, value: '$warnings'),
                  const SizedBox(height: 8),
                  _SummaryMetric(label: l10n.diagnosticsLastScan, value: lastScan),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.diagnosticsRecentEvents,
              child: events.isEmpty
                  ? Text(
                      l10n.diagnosticsNoEvents,
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
              title: l10n.diagnosticsLogPreview,
              subtitle: l10n.diagnosticsLogPreviewSubtitle,
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

  static String _formatDayTime(AppLocalizations l10n, DateTime t) {
    final DateTime now = DateTime.now();
    final String h = t.hour.toString().padLeft(2, '0');
    final String m = t.minute.toString().padLeft(2, '0');
    final bool sameDay = t.year == now.year && t.month == now.month && t.day == now.day;
    if (sameDay) {
      return l10n.diagnosticsToday('$h:$m');
    }
    final String date =
        '${t.day.toString().padLeft(2, '0')}.${t.month.toString().padLeft(2, '0')}.${t.year}';
    return l10n.diagnosticsDateTime(date, '$h:$m');
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
