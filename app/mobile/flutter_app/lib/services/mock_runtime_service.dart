import 'dart:async' show Timer, unawaited;

import '../models/diagnostic_event.dart';
import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../models/runtime_state_model.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../persistence/app_prefs.dart';
import 'runtime_client.dart';

/// In-memory stand-in for future native/runtime integration.
///
/// Drives [RuntimeScreen], [DiagnosticsScreen], and [ChatScreen] until real IPC exists.
class MockRuntimeService extends RuntimeClient {
  MockRuntimeService({
    required ProviderConfigModel providerConfig,
    required RuntimeDeploymentModel deployment,
    this.autoStartRuntime = true,
    this.alertLevel = 'Moderate',
    this.syncFrequencyLabel = '30s',
    this.diagnosticsUploadEnabled = true,
  })  : _providerConfig = providerConfig,
        _deployment = deployment {
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    _seedDiagnostics();
    _applyLifecycle(RuntimeLifecycle.running);
  }

  ProviderConfigModel _providerConfig;

  @override
  ProviderConfigModel get providerConfig => _providerConfig;

  RuntimeDeploymentModel _deployment;

  @override
  RuntimeDeploymentModel get deployment => _deployment;

  @override
  bool autoStartRuntime;
  @override
  String alertLevel;
  @override
  String syncFrequencyLabel;
  @override
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

  @override
  RuntimeStateModel get runtimeState => _runtime;

  @override
  List<DiagnosticEvent> get diagnosticEvents => List<DiagnosticEvent>.unmodifiable(_events);

  @override
  DateTime? get lastHealthCheckAt => _lastHealthCheckAt;

  @override
  String get logPreviewText {
    if (_logLines.isEmpty) {
      return 'No log lines yet.';
    }
    return _logLines.join('\n');
  }

  void _seedDiagnostics() {
    final DateTime now = DateTime.now();
    _appendEvent(
      'INFO',
      'runtime: session initialized (${_providerConfig.displayLabel}; ${_deployment.displayLabel})',
    );
    _appendLog(now, 'INFO', 'runtime: session initialized');
    _appendEvent('INFO', 'runtime: ${_deployment.runtimeModeSummary}');
    _appendLog(now, 'INFO', 'runtime: ${_deployment.runtimeModeSummary}');
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
          modeLabel: _deployment.runtimeModeSummary,
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
          modeLabel: _deployment.runtimeModeSummary,
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
  @override
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

  @override
  Future<void> startRuntime() async {
    if (_runtime.lifecycle == RuntimeLifecycle.running) {
      return;
    }
    _applyLifecycle(RuntimeLifecycle.starting);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _applyLifecycle(RuntimeLifecycle.running);
  }

  @override
  Future<void> stopRuntime() async {
    _applyLifecycle(RuntimeLifecycle.stopped);
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> restartRuntime() async {
    await stopRuntime();
    await startRuntime();
  }

  @override
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

  @override
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

  @override
  bool get queuePaused => _queuePaused;

  @override
  bool get healthCheckInProgress => _healthCheckRunning;

  @override
  void setAutoStart(bool value) {
    autoStartRuntime = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  @override
  void setAlertLevel(String value) {
    alertLevel = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  @override
  void setSyncFrequencyLabel(String value) {
    syncFrequencyLabel = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  @override
  void setDiagnosticsUpload(bool value) {
    diagnosticsUploadEnabled = value;
    notifyListeners();
    unawaited(_persistSettings());
  }

  @override
  void setProviderConfig(ProviderConfigModel value) {
    if (_providerConfig == value) {
      return;
    }
    _providerConfig = value;
    final DateTime now = DateTime.now();
    _appendEvent('INFO', 'runtime: model/API set to ${value.displayLabel}');
    _appendLog(now, 'INFO', 'runtime: model/API set to ${value.displayLabel}');
    notifyListeners();
    unawaited(AppPrefs.saveProviderConfig(value));
  }

  @override
  void setOpenAiChatModel(String openAiModelId) {
    setProviderConfig(
      ProviderConfigModel.fromSetup(
        modelProfileLabel: openAiModelId,
        apiConnectionLabel: ProviderConfigModel.apiOpenAiCompatible,
      ),
    );
  }

  @override
  void setDeployment(RuntimeDeploymentModel value) {
    if (_deployment.kind == value.kind) {
      return;
    }
    _deployment = value;
    if (_runtime.lifecycle == RuntimeLifecycle.running ||
        _runtime.lifecycle == RuntimeLifecycle.degraded) {
      _runtime = _runtime.copyWith(modeLabel: value.runtimeModeSummary);
    }
    final DateTime now = DateTime.now();
    _appendEvent('INFO', 'runtime: deployment set to ${value.displayLabel}');
    _appendLog(now, 'INFO', 'runtime: deployment set to ${value.displayLabel}');
    notifyListeners();
    unawaited(AppPrefs.saveRuntimeDeploymentLabel(value.displayLabel));
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
  @override
  String mockAssistantReply(
    AppLocalizations l10n,
    String userMessage, {
    String? attachmentName,
  }) {
    final String t = userMessage.toLowerCase().trim();
    final RuntimeStateModel s = _runtime;
    if (t.isEmpty && (attachmentName == null || attachmentName.isEmpty)) {
      return l10n.chatMockSayEmpty;
    }
    if (attachmentName != null && attachmentName.isNotEmpty) {
      final String base = l10n.chatMockAttachmentIntro(attachmentName);
      if (t.isEmpty) {
        return '$base${l10n.chatMockAttachmentAddContext}';
      }
      return base + _mockReplyForText(l10n, t, s);
    }
    if (t.isEmpty) {
      return l10n.chatMockSayText;
    }
    return _mockReplyForText(l10n, t, s);
  }

  String _mockReplyForText(AppLocalizations l10n, String t, RuntimeStateModel s) {
    if (t.contains('health') || t.contains('status') || t.contains('runtime')) {
      return l10n.chatMockRuntimeReply(
        _deployment.displayLabel,
        _providerConfig.displayLabel,
        _lifecycleWord(l10n, s.lifecycle),
        heartbeatSubtitle,
        s.queueDepth,
      );
    }
    if (t.contains('diag') || t.contains('log') || t.contains('event')) {
      return l10n.chatMockDiagReply(_events.length);
    }
    if (t.contains('hello') || t.contains('hi')) {
      return l10n.chatMockHello;
    }
    return l10n.chatMockDefault;
  }

  String _lifecycleWord(AppLocalizations l10n, RuntimeLifecycle l) {
    switch (l) {
      case RuntimeLifecycle.stopped:
        return l10n.lifecycleStoppedWord;
      case RuntimeLifecycle.starting:
        return l10n.lifecycleStartingWord;
      case RuntimeLifecycle.running:
        return l10n.lifecycleRunningWord;
      case RuntimeLifecycle.degraded:
        return l10n.lifecycleDegradedWord;
      case RuntimeLifecycle.error:
        return l10n.lifecycleErrorWord;
    }
  }

  @override
  void dispose() {
    _tickTimer.cancel();
    super.dispose();
  }
}
