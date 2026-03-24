import 'dart:async' show Timer, unawaited;

import 'package:flutter/foundation.dart';

import '../models/diagnostic_event.dart';
import '../models/provider_config_model.dart';
import '../models/runtime_state_model.dart';
import '../persistence/app_prefs.dart';

/// In-memory stand-in for future native/runtime integration.
///
/// Drives [RuntimeScreen], [DiagnosticsScreen], and [ChatScreen] until real IPC exists.
class MockRuntimeService extends ChangeNotifier {
  MockRuntimeService({
    required this.providerConfig,
    bool autoStartRuntime = true,
    String alertLevel = 'Moderate',
    String syncFrequencyLabel = '30s',
    bool diagnosticsUploadEnabled = true,
  })  : autoStartRuntime = autoStartRuntime,
        alertLevel = alertLevel,
        syncFrequencyLabel = syncFrequencyLabel,
        diagnosticsUploadEnabled = diagnosticsUploadEnabled {
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _seedDiagnostics();
    _applyLifecycle(RuntimeLifecycle.running);
  }

  final ProviderConfigModel providerConfig;

  bool autoStartRuntime;
  String alertLevel;
  String syncFrequencyLabel;
  bool diagnosticsUploadEnabled;

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
  DateTime? _lastHealthCheckAt;

  final List<DiagnosticEvent> _events = <DiagnosticEvent>[];
  final List<String> _logLines = <String>[];

  static const int _maxEvents = 40;
  static const int _maxLogLines = 24;

  late final Timer _tickTimer;

  RuntimeStateModel get runtimeState => _runtime;

  List<DiagnosticEvent> get diagnosticEvents => List<DiagnosticEvent>.unmodifiable(_events);

  DateTime? get lastHealthCheckAt => _lastHealthCheckAt;

  String get logPreviewText {
    if (_logLines.isEmpty) {
      return 'No log lines yet.';
    }
    return _logLines.join('\n');
  }

  void _seedDiagnostics() {
    final DateTime now = DateTime.now();
    _appendEvent('INFO', 'runtime: session initialized (${providerConfig.displayLabel})');
    _appendLog(now, 'INFO', 'runtime: session initialized');
    _appendEvent('INFO', 'queue: processor idle, waiting for tasks');
    _appendLog(now, 'INFO', 'queue: processor idle');
  }

  void _appendEvent(String level, String message) {
    _events.insert(
      0,
      DiagnosticEvent(at: DateTime.now(), level: level, message: message),
    );
    while (_events.length > _maxEvents) {
      _events.removeLast();
    }
  }

  void _appendLog(DateTime at, String level, String message) {
    final String ts =
        '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}:${at.second.toString().padLeft(2, '0')}';
    _logLines.insert(0, '[$ts] $level  $message');
    while (_logLines.length > _maxLogLines) {
      _logLines.removeLast();
    }
  }

  void _onTick() {
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      final DateTime? beat = _runtime.lastHeartbeat;
      if (beat != null && DateTime.now().difference(beat).inSeconds >= 12) {
        _runtime = _runtime.copyWith(lastHeartbeat: DateTime.now());
        final DateTime now = DateTime.now();
        _appendLog(now, 'INFO', 'runtime: heartbeat ok');
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
        _appendEvent('WARN', 'runtime: stopped');
        _appendLog(now, 'WARN', 'runtime: stopped');
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
        _appendEvent('INFO', 'runtime: starting workers');
        _appendLog(now, 'INFO', 'runtime: starting workers');
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
        _appendEvent('INFO', 'runtime: healthy');
        _appendLog(now, 'INFO', 'runtime: healthy');
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
        _appendEvent('WARN', 'runtime: degraded');
        _appendLog(now, 'WARN', 'runtime: degraded');
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
        _appendEvent('ERROR', 'runtime: error reported');
        _appendLog(now, 'ERROR', 'runtime: error reported');
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
    _appendEvent('INFO', 'diagnostics: health check started');
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _healthCheckRunning = false;
    _lastHealthCheckAt = DateTime.now();
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      _applyLifecycle(RuntimeLifecycle.running);
    }
    _appendEvent('INFO', 'diagnostics: health check completed');
    final DateTime now = DateTime.now();
    _appendLog(now, 'INFO', 'diagnostics: health check completed');
    notifyListeners();
  }

  void toggleQueuePaused() {
    _queuePaused = !_queuePaused;
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      _touchHeartbeat();
    } else {
      notifyListeners();
    }
    _appendEvent('INFO', _queuePaused ? 'queue: paused by user' : 'queue: resumed by user');
    final DateTime now = DateTime.now();
    _appendLog(now, 'INFO', _queuePaused ? 'queue: paused' : 'queue: resumed');
  }

  bool get queuePaused => _queuePaused;

  bool get healthCheckInProgress => _healthCheckRunning;

  void setAutoStart(bool value) {
    autoStartRuntime = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  void setAlertLevel(String value) {
    alertLevel = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  void setSyncFrequencyLabel(String value) {
    syncFrequencyLabel = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  void setDiagnosticsUpload(bool value) {
    diagnosticsUploadEnabled = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  Future<void> _persistSettings() {
    return AppPrefs.saveRuntimeSettings(
      autoStartRuntime: autoStartRuntime,
      alertLevel: alertLevel,
      syncFrequencyLabel: syncFrequencyLabel,
      diagnosticsUploadEnabled: diagnosticsUploadEnabled,
    );
  }

  void _touchHeartbeat() {
    final DateTime now = DateTime.now();
    _runtime = _runtime.copyWith(
      lastHeartbeat: now,
      queueDepth: _queuePaused ? 5 : 3,
    );
    notifyListeners();
  }

  /// Simple assistant reply for the mock chat (no network).
  String mockAssistantReply(String userMessage) {
    final String t = userMessage.toLowerCase().trim();
    final RuntimeStateModel s = _runtime;
    if (t.isEmpty) {
      return 'Say something to get started.';
    }
    if (t.contains('health') || t.contains('status') || t.contains('runtime')) {
      return 'Runtime is ${_lifecycleWord(s.lifecycle)}. ${heartbeatSubtitle} Queue depth: ${s.queueDepth}.';
    }
    if (t.contains('diag') || t.contains('log') || t.contains('event')) {
      return 'Diagnostics has ${_events.length} recent events. Open the Diagnostics tab for details.';
    }
    if (t.contains('hello') || t.contains('hi')) {
      return 'Hi. Ask me about runtime status or diagnostics.';
    }
    return 'Got it. Try: “runtime status” or “show diagnostics”.';
  }

  String _lifecycleWord(RuntimeLifecycle l) {
    switch (l) {
      case RuntimeLifecycle.stopped:
        return 'stopped';
      case RuntimeLifecycle.starting:
        return 'starting';
      case RuntimeLifecycle.running:
        return 'running';
      case RuntimeLifecycle.degraded:
        return 'degraded';
      case RuntimeLifecycle.error:
        return 'in error';
    }
  }

  @override
  void dispose() {
    _tickTimer.cancel();
    super.dispose();
  }
}
