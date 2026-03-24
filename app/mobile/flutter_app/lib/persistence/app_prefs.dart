import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider_config_model.dart';

/// Local key-value persistence until a real storage layer exists.
class AppPrefsSnapshot {
  const AppPrefsSnapshot({
    required this.setupComplete,
    required this.selectedProvider,
    required this.autoStartRuntime,
    required this.alertLevel,
    required this.syncFrequencyLabel,
    required this.diagnosticsUploadEnabled,
  });

  final bool setupComplete;
  final String selectedProvider;
  final bool autoStartRuntime;
  final String alertLevel;
  final String syncFrequencyLabel;
  final bool diagnosticsUploadEnabled;
}

abstract final class AppPrefs {
  static const String _kSetupComplete = 'pc_setup_complete';
  static const String _kSelectedProvider = 'pc_selected_provider';
  static const String _kAutoStart = 'pc_auto_start_runtime';
  static const String _kAlertLevel = 'pc_alert_level';
  static const String _kSyncFreq = 'pc_sync_frequency';
  static const String _kDiagUpload = 'pc_diagnostics_upload';

  static Future<AppPrefsSnapshot> load() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return AppPrefsSnapshot(
      setupComplete: p.getBool(_kSetupComplete) ?? false,
      selectedProvider:
          p.getString(_kSelectedProvider) ?? ProviderConfigModel.labelLocalRuntime,
      autoStartRuntime: p.getBool(_kAutoStart) ?? true,
      alertLevel: p.getString(_kAlertLevel) ?? 'Moderate',
      syncFrequencyLabel: p.getString(_kSyncFreq) ?? '30s',
      diagnosticsUploadEnabled: p.getBool(_kDiagUpload) ?? true,
    );
  }

  static Future<void> saveAfterSetup({required String provider}) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kSetupComplete, true);
    await p.setString(_kSelectedProvider, provider);
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
