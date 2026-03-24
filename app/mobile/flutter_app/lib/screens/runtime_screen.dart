import 'package:flutter/material.dart';

import '../models/runtime_state_model.dart';
import '../services/mock_runtime_service.dart';
import '../widgets/product_widgets.dart';

class RuntimeScreen extends StatelessWidget {
  const RuntimeScreen({super.key, required this.session});

  final MockRuntimeService session;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final RuntimeStateModel state = session.runtimeState;
        final _StatusPresentation pres = _StatusPresentation.fromLifecycle(state.lifecycle);
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
              subtitle: session.heartbeatSubtitle,
              trailing: StatusDot(
                color: pres.dotColor,
                label: pres.label,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Mode: ${state.modeLabel}'),
                  const SizedBox(height: 4),
                  Text(state.workersSummary),
                  const SizedBox(height: 4),
                  Text('Queue depth: ${state.queueDepth} pending tasks'),
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
                  if (state.lifecycle == RuntimeLifecycle.stopped)
                    FilledButton.icon(
                      onPressed: () {
                        session.startRuntime();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start runtime'),
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
                      label: Text(session.healthCheckInProgress ? 'Checking…' : 'Run health check'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        session.toggleQueuePaused();
                      },
                      icon: const Icon(Icons.schedule_outlined),
                      label: Text(session.queuePaused ? 'Resume queue' : 'Pause queue'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.lifecycle == RuntimeLifecycle.stopped
                          ? null
                          : () {
                              session.stopRuntime();
                            },
                      icon: const Icon(Icons.stop_outlined),
                      label: const Text('Stop runtime'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Health checks',
              child: state.healthChecks.isEmpty
                  ? Text(
                      'No checks while runtime is stopped.',
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

  factory _StatusPresentation.fromLifecycle(RuntimeLifecycle lifecycle) {
    switch (lifecycle) {
      case RuntimeLifecycle.stopped:
        return _StatusPresentation(
          dotColor: Colors.grey.shade600,
          label: 'Stopped',
        );
      case RuntimeLifecycle.starting:
        return _StatusPresentation(
          dotColor: Colors.blue.shade400,
          label: 'Starting',
        );
      case RuntimeLifecycle.running:
        return _StatusPresentation(
          dotColor: Colors.green.shade600,
          label: 'Healthy',
        );
      case RuntimeLifecycle.degraded:
        return _StatusPresentation(
          dotColor: Colors.orange.shade700,
          label: 'Attention',
        );
      case RuntimeLifecycle.error:
        return _StatusPresentation(
          dotColor: Colors.red.shade700,
          label: 'Error',
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
