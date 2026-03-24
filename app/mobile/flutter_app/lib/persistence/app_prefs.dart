import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';

/// Local key-value persistence until a real storage layer exists.
class AppPrefsSnapshot {
  const AppPrefsSnapshot({
    required this.setupComplete,
    required this.providerConfig,
    required this.runtimeDeploymentLabel,
    required this.autoStartRuntime,
    required this.alertLevel,
    required this.syncFrequencyLabel,
    required this.diagnosticsUploadEnabled,
  });

  final bool setupComplete;

  /// Model + API routing (replaces legacy single “provider” string).
  final ProviderConfigModel providerConfig;

  final String runtimeDeploymentLabel;

  final bool autoStartRuntime;
  final String alertLevel;
  final String syncFrequencyLabel;
  final bool diagnosticsUploadEnabled;
}

abstract final class AppPrefs {
  static const String _kSetupComplete = 'pc_setup_complete';
  static const String _kSelectedProvider = 'pc_selected_provider';
  static const String _kModelProfile = 'pc_model_profile';
  static const String _kApiConnection = 'pc_api_connection';
  static const String _kCustomApiUrl = 'pc_custom_api_base_url';
  static const String _kRuntimeDeployment = 'pc_runtime_deployment';
  static const String _kAutoStart = 'pc_auto_start_runtime';
  static const String _kAlertLevel = 'pc_alert_level';
  static const String _kSyncFreq = 'pc_sync_frequency';
  static const String _kDiagUpload = 'pc_diagnostics_upload';

  static Future<AppPrefsSnapshot> load() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final ProviderConfigModel providerConfig = _readProviderConfig(p);
    return AppPrefsSnapshot(
      setupComplete: p.getBool(_kSetupComplete) ?? false,
      providerConfig: providerConfig,
      runtimeDeploymentLabel: p.getString(_kRuntimeDeployment) ??
          RuntimeDeploymentModel.labelThisPhone,
      autoStartRuntime: p.getBool(_kAutoStart) ?? true,
      alertLevel: p.getString(_kAlertLevel) ?? 'Moderate',
      syncFrequencyLabel: p.getString(_kSyncFreq) ?? '30s',
      diagnosticsUploadEnabled: p.getBool(_kDiagUpload) ?? true,
    );
  }

  static ProviderConfigModel _readProviderConfig(SharedPreferences p) {
    final String? model = p.getString(_kModelProfile);
    final String? api = p.getString(_kApiConnection);
    if (model != null && api != null) {
      return ProviderConfigModel.fromSetup(
        modelProfileLabel: model,
        apiConnectionLabel: api,
        customApiBaseUrl: p.getString(_kCustomApiUrl),
      );
    }
    return ProviderConfigModel.fromLegacyProvider(p.getString(_kSelectedProvider));
  }

  static Future<void> saveAfterSetup({
    required ProviderConfigModel providerConfig,
    required String runtimeDeploymentLabel,
  }) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kSetupComplete, true);
    await _writeProviderConfig(p, providerConfig);
    await p.setString(_kRuntimeDeployment, runtimeDeploymentLabel);
  }

  static Future<void> saveProviderConfig(ProviderConfigModel providerConfig) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await _writeProviderConfig(p, providerConfig);
  }

  static Future<void> _writeProviderConfig(
    SharedPreferences p,
    ProviderConfigModel c,
  ) async {
    await p.setString(_kModelProfile, c.modelProfileLabel);
    await p.setString(_kApiConnection, c.apiConnectionLabel);
    final String? url = c.customApiBaseUrl;
    if (url != null && url.trim().isNotEmpty) {
      await p.setString(_kCustomApiUrl, url.trim());
    } else {
      await p.remove(_kCustomApiUrl);
    }
  }

  static Future<void> saveRuntimeDeploymentLabel(String label) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString(_kRuntimeDeployment, label);
  }

  static Future<void> saveRuntimeSettings({
    required bool autoStartRuntime,
    required String alertLevel,
    required String syncFrequencyLabel,
    required bool diagnosticsUploadEnabled,
  }) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kAutoStart, autoStartRuntime);
    await p.setString(_kAlertLevel, alertLevel);
    await p.setString(_kSyncFreq, syncFrequencyLabel);
    await p.setBool(_kDiagUpload, diagnosticsUploadEnabled);
  }
}
