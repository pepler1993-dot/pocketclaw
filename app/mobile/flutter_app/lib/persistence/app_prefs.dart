import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_locale_preference.dart';
import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';

/// Local key-value persistence until a real storage layer exists.
class AppPrefsSnapshot {
  const AppPrefsSnapshot({
    required this.onboardingDone,
    required this.setupComplete,
    required this.openAiModelId,
    required this.providerConfig,
    required this.runtimeDeploymentLabel,
    required this.autoStartRuntime,
    required this.alertLevel,
    required this.syncFrequencyLabel,
    required this.diagnosticsUploadEnabled,
    required this.useGatewayForChat,
    required this.gatewayBaseUrl,
  });

  final bool onboardingDone;
  final bool setupComplete;

  /// Selected OpenAI API `model` id (e.g. `gpt-4o`).
  final String? openAiModelId;

  final ProviderConfigModel providerConfig;
  final String runtimeDeploymentLabel;

  final bool autoStartRuntime;
  final String alertLevel;
  final String syncFrequencyLabel;
  final bool diagnosticsUploadEnabled;

  /// When true and [gatewayBaseUrl] + secure token are set, chat uses the OpenClaw Gateway HTTP API.
  final bool useGatewayForChat;

  /// Normalized base URL (no trailing slash), e.g. `http://192.168.1.10:18789`.
  final String gatewayBaseUrl;
}

abstract final class AppPrefs {
  static const String _kOnboardingDone = 'pc_onboarding_done';
  static const String _kSetupComplete = 'pc_setup_complete';
  static const String _kOpenAiModel = 'pc_openai_model_id';
  static const String _kModelProfile = 'pc_model_profile';
  static const String _kApiConnection = 'pc_api_connection';
  static const String _kCustomApiUrl = 'pc_custom_api_base_url';
  static const String _kSelectedProvider = 'pc_selected_provider';
  static const String _kRuntimeDeployment = 'pc_runtime_deployment';
  static const String _kAutoStart = 'pc_auto_start_runtime';
  static const String _kAlertLevel = 'pc_alert_level';
  static const String _kSyncFreq = 'pc_sync_frequency';
  static const String _kDiagUpload = 'pc_diagnostics_upload';
  static const String _kLocale = 'pc_locale';
  static const String _kUseGateway = 'pc_use_openclaw_gateway';
  static const String _kGatewayBase = 'pc_gateway_base_url';

  /// Default UI language is English; optional German or system locale.
  static Future<AppLocalePreference> loadLocalePreference() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return appLocalePreferenceFromStorage(p.getString(_kLocale));
  }

  static Future<void> saveLocalePreference(AppLocalePreference value) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString(_kLocale, value.storageValue);
  }

  static Future<AppPrefsSnapshot> load() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? openAiModelId = p.getString(_kOpenAiModel);
    final ProviderConfigModel providerConfig = _readProviderConfig(p, openAiModelId);

    return AppPrefsSnapshot(
      onboardingDone: p.getBool(_kOnboardingDone) ?? false,
      setupComplete: p.getBool(_kSetupComplete) ?? false,
      openAiModelId: openAiModelId,
      providerConfig: providerConfig,
      runtimeDeploymentLabel: p.getString(_kRuntimeDeployment) ??
          RuntimeDeploymentModel.labelThisPhone,
      autoStartRuntime: p.getBool(_kAutoStart) ?? true,
      alertLevel: p.getString(_kAlertLevel) ?? 'Moderate',
      syncFrequencyLabel: p.getString(_kSyncFreq) ?? '30s',
      diagnosticsUploadEnabled: p.getBool(_kDiagUpload) ?? true,
      useGatewayForChat: p.getBool(_kUseGateway) ?? false,
      gatewayBaseUrl: p.getString(_kGatewayBase) ?? '',
    );
  }

  static ProviderConfigModel _readProviderConfig(
    SharedPreferences p,
    String? openAiModelId,
  ) {
    final String? model = p.getString(_kModelProfile);
    final String? api = p.getString(_kApiConnection);
    if (model != null && api != null) {
      return ProviderConfigModel.fromSetup(
        modelProfileLabel: model,
        apiConnectionLabel: api,
        customApiBaseUrl: p.getString(_kCustomApiUrl),
      );
    }
    if (openAiModelId != null && openAiModelId.isNotEmpty) {
      return ProviderConfigModel.fromSetup(
        modelProfileLabel: openAiModelId,
        apiConnectionLabel: ProviderConfigModel.apiOpenAiCompatible,
      );
    }
    return ProviderConfigModel.fromLegacyProvider(p.getString(_kSelectedProvider));
  }

  static Future<void> saveAfterSetup({
    required ProviderConfigModel providerConfig,
    required String runtimeDeploymentLabel,
    required String openAiModelId,
  }) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kSetupComplete, true);
    await p.setString(_kOpenAiModel, openAiModelId);
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
    if (c.apiConnectionLabel == ProviderConfigModel.apiOpenAiCompatible) {
      await p.setString(_kOpenAiModel, c.modelProfileLabel);
    }
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

  static Future<void> clearOpenAiSetup() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kSetupComplete, false);
    await p.remove(_kOpenAiModel);
    await p.setString(_kModelProfile, ProviderConfigModel.modelDefault);
    await p.setString(_kApiConnection, ProviderConfigModel.apiOpenAiCompatible);
    await p.remove(_kCustomApiUrl);
  }

  static Future<void> setOnboardingDone() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboardingDone, true);
  }

  static Future<void> saveGatewayPrefs({
    required bool useGatewayForChat,
    required String gatewayBaseUrl,
  }) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_kUseGateway, useGatewayForChat);
    await p.setString(_kGatewayBase, gatewayBaseUrl.trim());
  }
}
