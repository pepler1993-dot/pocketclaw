import 'package:flutter/foundation.dart';

/// High-level lifecycle for the (future) OpenClaw runtime process.
enum RuntimeLifecycle {
  stopped,
  starting,
  running,
  degraded,
  error,
}

@immutable
class RuntimeHealthCheckItem {
  const RuntimeHealthCheckItem({
    required this.name,
    required this.detail,
    required this.ok,
  });

  final String name;
  final String detail;
  final bool ok;
}

@immutable
class RuntimeStateModel {
  const RuntimeStateModel({
    required this.lifecycle,
    required this.statusHeadline,
    required this.statusDetail,
    required this.lastHeartbeat,
    required this.modeLabel,
    required this.workersSummary,
    required this.queueDepth,
    required this.healthChecks,
  });

  final RuntimeLifecycle lifecycle;
  final String statusHeadline;
  final String statusDetail;

  /// Monotonic clock: last time the runtime sent a heartbeat (mock uses [DateTime.now]).
  final DateTime? lastHeartbeat;

  final String modeLabel;
  final String workersSummary;
  final int queueDepth;
  final List<RuntimeHealthCheckItem> healthChecks;

  RuntimeStateModel copyWith({
    RuntimeLifecycle? lifecycle,
    String? statusHeadline,
    String? statusDetail,
    DateTime? lastHeartbeat,
    String? modeLabel,
    String? workersSummary,
    int? queueDepth,
    List<RuntimeHealthCheckItem>? healthChecks,
  }) {
    return RuntimeStateModel(
      lifecycle: lifecycle ?? this.lifecycle,
      statusHeadline: statusHeadline ?? this.statusHeadline,
      statusDetail: statusDetail ?? this.statusDetail,
      lastHeartbeat: lastHeartbeat ?? this.lastHeartbeat,
      modeLabel: modeLabel ?? this.modeLabel,
      workersSummary: workersSummary ?? this.workersSummary,
      queueDepth: queueDepth ?? this.queueDepth,
      healthChecks: healthChecks ?? this.healthChecks,
    );
  }
}
