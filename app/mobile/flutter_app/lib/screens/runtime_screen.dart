import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../models/runtime_state_model.dart';
import '../services/runtime_client.dart';
import '../widgets/product_widgets.dart';

class RuntimeScreen extends StatelessWidget {
  const RuntimeScreen({super.key, required this.session});

  final RuntimeClient session;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final RuntimeStateModel state = session.runtimeState;
        final _StatusPresentation pres = _StatusPresentation.fromLifecycle(l10n, state.lifecycle);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: <Widget>[
            ScreenHeader(
              title: l10n.runtimeTitle,
              subtitle: l10n.runtimeSubtitle,
              trailing: const Icon(Icons.play_circle_outline),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.runtimeStatusSection,
              subtitle: session.heartbeatSubtitle,
              trailing: StatusDot(
                color: pres.dotColor,
                label: pres.label,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.runtimeModeLine(state.modeLabel), style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Text(state.workersSummary, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    l10n.runtimeQueueLine(state.queueDepth),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.runtimeQuickActions,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  if (state.lifecycle == RuntimeLifecycle.stopped)
                    FilledButton.icon(
                      onPressed: () {
                        session.startRuntime();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.runtimeStart),
                    )
                  else ...<Widget>[
                    FilledButton.icon(
                      onPressed: state.lifecycle == RuntimeLifecycle.starting
                          ? null
                          : () {
                              session.restartRuntime();
                            },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Restart runtime'),
                    ),
                    OutlinedButton.icon(
                      onPressed: session.healthCheckInProgress
                          ? null
                          : () {
                              session.runHealthCheck();
                            },
                      icon: session.healthCheckInProgress
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.task_alt_outlined),
                      label: Text(session.healthCheckInProgress ? l10n.runtimeHealthChecking : l10n.runtimeHealthCheck),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        session.toggleQueuePaused();
                      },
                      icon: const Icon(Icons.schedule_outlined),
                      label: Text(session.queuePaused ? l10n.runtimeQueueResume : l10n.runtimeQueuePause),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.lifecycle == RuntimeLifecycle.stopped
                          ? null
                          : () {
                              session.stopRuntime();
                            },
                      icon: const Icon(Icons.stop_outlined),
                      label: Text(l10n.runtimeStop),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.runtimeHealthChecks,
              child: state.healthChecks.isEmpty
                  ? Text(
                      l10n.runtimeNoChecksStopped,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : Column(
                      children: <Widget>[
                        for (int i = 0; i < state.healthChecks.length; i++) ...<Widget>[
                          if (i > 0) const Divider(height: 20),
                          _RuntimeCheckRow(
                            name: state.healthChecks[i].name,
                            detail: state.healthChecks[i].detail,
                            ok: state.healthChecks[i].ok,
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusPresentation {
  const _StatusPresentation({required this.dotColor, required this.label});

  final Color dotColor;
  final String label;

  factory _StatusPresentation.fromLifecycle(AppLocalizations l10n, RuntimeLifecycle lifecycle) {
    switch (lifecycle) {
      case RuntimeLifecycle.stopped:
        return _StatusPresentation(
          dotColor: Colors.grey.shade600,
          label: l10n.runtimeDotStopped,
        );
      case RuntimeLifecycle.starting:
        return _StatusPresentation(
          dotColor: Colors.blue.shade400,
          label: l10n.runtimeDotStarting,
        );
      case RuntimeLifecycle.running:
        return _StatusPresentation(
          dotColor: Colors.green.shade600,
          label: l10n.runtimeDotHealthy,
        );
      case RuntimeLifecycle.degraded:
        return _StatusPresentation(
          dotColor: Colors.orange.shade700,
          label: l10n.runtimeDotAttention,
        );
      case RuntimeLifecycle.error:
        return _StatusPresentation(
          dotColor: Colors.red.shade700,
          label: l10n.runtimeDotError,
        );
    }
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
