import 'package:flutter/foundation.dart';

import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../models/diagnostic_event.dart';
import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../models/runtime_state_model.dart';

/// Contract for runtime status, diagnostics, and session-scoped settings.
///
/// Current implementation: [MockRuntimeService]. Later: native process / gateway
/// behind the same surface so UI stays unchanged.
abstract class RuntimeClient extends ChangeNotifier {
  ProviderConfigModel get providerConfig;

  RuntimeDeploymentModel get deployment;

  bool get autoStartRuntime;

  set autoStartRuntime(bool value);

  String get alertLevel;

  set alertLevel(String value);

  String get syncFrequencyLabel;

  set syncFrequencyLabel(String value);

  bool get diagnosticsUploadEnabled;

  set diagnosticsUploadEnabled(bool value);

  RuntimeStateModel get runtimeState;

  List<DiagnosticEvent> get diagnosticEvents;

  DateTime? get lastHealthCheckAt;

  String get logPreviewText;

  String get heartbeatSubtitle;

  Future<void> startRuntime();

  Future<void> stopRuntime();

  Future<void> restartRuntime();

  Future<void> runHealthCheck();

  void toggleQueuePaused();

  bool get queuePaused;

  bool get healthCheckInProgress;

  void setAutoStart(bool value);

  void setAlertLevel(String value);

  void setSyncFrequencyLabel(String value);

  void setDiagnosticsUpload(bool value);

  void setProviderConfig(ProviderConfigModel value);

  void setOpenAiChatModel(String openAiModelId);

  void setDeployment(RuntimeDeploymentModel value);

  /// Offline / no-API reply used when Chat Completions are not available.
  String mockAssistantReply(
    AppLocalizations l10n,
    String userMessage, {
    String? attachmentName,
  });
}
