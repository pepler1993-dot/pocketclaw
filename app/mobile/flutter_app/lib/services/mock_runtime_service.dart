import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_state_model.dart';

/// In-memory stand-in for future native/runtime integration.
///
/// Drives [RuntimeScreen] and product settings until real IPC exists.
class MockRuntimeService extends ChangeNotifier {
  MockRuntimeService({
    required this.providerConfig,
  }) {
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _applyLifecycle(RuntimeLifecycle.running);
  }

  final ProviderConfigModel providerConfig;

  RuntimeStateModel _runtime = const RuntimeStateModel(
    lifecycle: RuntimeLifecycle.stopped,
    statusHeadline: 'Stopped',
    statusDetail: 'Runtime is not running.',
    lastHeartbeat: null,
    modeLabel: 'Idle',
    workersSummary: '0 online',
    queueDepth: 0,
    healthChecks: <RuntimeHealthCheckItem>[],
  );

  bool _queuePaused = false;
  bool _healthCheckRunning = false;

  // Settings mirrored in [SettingsScreen] until persisted.
  bool autoStartRuntime = true;
  String alertLevel = 'Moderate';
  String syncFrequencyLabel = '30s';
  bool diagnosticsUploadEnabled = true;

  late final Timer _tickTimer;

  RuntimeStateModel get runtimeState => _runtime;

  void _onTick() {
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      final DateTime? beat = _runtime.lastHeartbeat;
      if (beat != null && DateTime.now().difference(beat).inSeconds >= 12) {
        _runtime = _runtime.copyWith(lastHeartbeat: DateTime.now());
      }
    }
    if (_runtime.lifecycle == RuntimeLifecycle.running ||
        _runtime.lifecycle == RuntimeLifecycle.degraded) {
      notifyListeners();
    }
  }

  void _applyLifecycle(RuntimeLifecycle lifecycle) {
    final DateTime now = DateTime.now();
    switch (lifecycle) {
      case RuntimeLifecycle.stopped:
        _runtime = _runtime.copyWith(
          lifecycle: RuntimeLifecycle.stopped,
          statusHeadline: 'Stopped',
          statusDetail: 'Runtime is not running.',
          lastHeartbeat: null,
          modeLabel: 'Idle',
          workersSummary: '0 online',
          queueDepth: 0,
          healthChecks: const <RuntimeHealthCheckItem>[],
        );
        break;
      case RuntimeLifecycle.starting:
        _runtime = _runtime.copyWith(
          lifecycle: RuntimeLifecycle.starting,
          statusHeadline: 'Starting',
          statusDetail: 'Bringing workers online…',
          lastHeartbeat: null,
          modeLabel: 'Starting',
          workersSummary: '0 online',
          queueDepth: 0,
          healthChecks: _defaultHealthChecks(degraded: true),
        );
        break;
      case RuntimeLifecycle.running:
        _runtime = _runtime.copyWith(
          lifecycle: RuntimeLifecycle.running,
          statusHeadline: 'Healthy',
          statusDetail: '',
          lastHeartbeat: now,
          modeLabel: 'Active',
          workersSummary: '2 online, 0 restarting',
          queueDepth: _queuePaused ? 5 : 3,
          healthChecks: _defaultHealthChecks(degraded: false),
        );
        break;
      case RuntimeLifecycle.degraded:
        _runtime = _runtime.copyWith(
          lifecycle: RuntimeLifecycle.degraded,
          statusHeadline: 'Degraded',
          statusDetail: 'Some checks need attention.',
          lastHeartbeat: now,
          modeLabel: 'Active',
          workersSummary: '2 online, 1 restarting',
          queueDepth: 6,
          healthChecks: _defaultHealthChecks(degraded: true),
        );
        break;
      case RuntimeLifecycle.error:
        _runtime = _runtime.copyWith(
          lifecycle: RuntimeLifecycle.error,
          statusHeadline: 'Error',
          statusDetail: 'Runtime reported a failure. See diagnostics.',
          lastHeartbeat: now,
          modeLabel: 'Failed',
          workersSummary: '0 online',
          queueDepth: 0,
          healthChecks: _defaultHealthChecks(degraded: true),
        );
        break;
    }
    notifyListeners();
  }

  List<RuntimeHealthCheckItem> _defaultHealthChecks({required bool degraded}) {
    return <RuntimeHealthCheckItem>[
      const RuntimeHealthCheckItem(
        name: 'API connectivity',
        detail: 'Stable, 42 ms',
        ok: true,
      ),
      const RuntimeHealthCheckItem(
        name: 'Storage access',
        detail: 'Readable and writable',
        ok: true,
      ),
      RuntimeHealthCheckItem(
        name: 'Event stream',
        detail: degraded ? '1 delayed message' : 'Within threshold',
        ok: !degraded,
      ),
    ];
  }

  /// Secondary line under runtime status (live while running/degraded).
  String get heartbeatSubtitle {
    switch (_runtime.lifecycle) {
      case RuntimeLifecycle.stopped:
      case RuntimeLifecycle.starting:
      case RuntimeLifecycle.error:
        return _runtime.statusDetail;
      case RuntimeLifecycle.running:
        final DateTime? beat = _runtime.lastHeartbeat;
        if (beat == null) {
          return _runtime.statusDetail.isEmpty ? 'No heartbeat yet' : _runtime.statusDetail;
        }
        final int seconds = DateTime.now().difference(beat).inSeconds.abs();
        return 'Last heartbeat ${seconds}s ago';
      case RuntimeLifecycle.degraded:
        final DateTime? beat = _runtime.lastHeartbeat;
        final String age = beat == null
            ? 'unknown'
            : '${DateTime.now().difference(beat).inSeconds.abs()}s ago';
        return 'Some checks need attention · Last heartbeat $age';
    }
  }

  Future<void> startRuntime() async {
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      return;
    }
    _applyLifecycle(RuntimeLifecycle.starting);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _applyLifecycle(RuntimeLifecycle.running);
  }

  Future<void> stopRuntime() async {
    _applyLifecycle(RuntimeLifecycle.stopped);
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  Future<void> restartRuntime() async {
    await stopRuntime();
    await startRuntime();
  }

  Future<void> runHealthCheck() async {
    if (_healthCheckRunning) {
      return;
    }
    _healthCheckRunning = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _healthCheckRunning = false;
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      _applyLifecycle(RuntimeLifecycle.running);
    }
    notifyListeners();
  }

  void toggleQueuePaused() {
    _queuePaused = !_queuePaused;
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      _touchHeartbeat();
    } else {
      notifyListeners();
    }
  }

  bool get queuePaused => _queuePaused;

  bool get healthCheckInProgress => _healthCheckRunning;

  void setAutoStart(bool value) {
    autoStartRuntime = value;
    notifyListeners();
  }

  void setAlertLevel(String value) {
    alertLevel = value;
    notifyListeners();
  }

  void setSyncFrequencyLabel(String value) {
    syncFrequencyLabel = value;
    notifyListeners();
  }

  void setDiagnosticsUpload(bool value) {
    diagnosticsUploadEnabled = value;
    notifyListeners();
  }

  void _touchHeartbeat() {
    final DateTime now = DateTime.now();
    _runtime = _runtime.copyWith(
      lastHeartbeat: now,
      queueDepth: _queuePaused ? 5 : 3,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _tickTimer.cancel();
    super.dispose();
  }
}
