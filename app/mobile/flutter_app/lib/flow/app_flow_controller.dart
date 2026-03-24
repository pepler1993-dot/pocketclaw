import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../persistence/app_prefs.dart';

enum AppFlowStep {
  onboarding,
  openaiLogin,
  openaiModel,
  mainShell,
}

class AppFlowController extends ChangeNotifier {
  AppFlowStep _step = AppFlowStep.onboarding;
  ProviderConfigModel _providerConfig = ProviderConfigModel.fromSetup(
    modelProfileLabel: ProviderConfigModel.modelDefault,
    apiConnectionLabel: ProviderConfigModel.apiOpenAiCompatible,
  );
  String _selectedDeployment = RuntimeDeploymentModel.labelThisPhone;
  String? _pendingOpenAiModelId;

  AppFlowStep get step => _step;
  ProviderConfigModel get providerConfig => _providerConfig;
  String get selectedDeployment => _selectedDeployment;
  String? get pendingOpenAiModelId => _pendingOpenAiModelId;

  void hydrateFromPrefs({
    required bool onboardingDone,
    required bool setupComplete,
    required String? openAiModelId,
    required bool hasOpenAiAccessToken,
    required ProviderConfigModel providerConfig,
    required String runtimeDeploymentLabel,
  }) {
    _providerConfig = providerConfig;
    _selectedDeployment = runtimeDeploymentLabel;
    _pendingOpenAiModelId = openAiModelId;

    if (!onboardingDone) {
      _step = AppFlowStep.onboarding;
    } else if (setupComplete &&
        hasOpenAiAccessToken &&
        openAiModelId != null &&
        openAiModelId.isNotEmpty) {
      _step = AppFlowStep.mainShell;
    } else if (hasOpenAiAccessToken) {
      _step = AppFlowStep.openaiModel;
    } else {
      _step = AppFlowStep.openaiLogin;
    }
    notifyListeners();
  }

  void continueFromOnboarding() {
    _step = AppFlowStep.openaiLogin;
    notifyListeners();
    unawaited(AppPrefs.setOnboardingDone());
  }

  void resetToOpenAiLogin() {
    _step = AppFlowStep.openaiLogin;
    _pendingOpenAiModelId = null;
    notifyListeners();
  }

  void oauthSucceededGoToModelSelection() {
    _step = AppFlowStep.openaiModel;
    notifyListeners();
  }

  void setProviderConfig(ProviderConfigModel value) {
    _providerConfig = value;
    notifyListeners();
  }

  void setModelProfile(String value) {
    _providerConfig = ProviderConfigModel.fromSetup(
      modelProfileLabel: value,
      apiConnectionLabel: _providerConfig.apiConnectionLabel,
      customApiBaseUrl: _providerConfig.customApiBaseUrl,
    );
    notifyListeners();
  }

  void setApiConnection(String value) {
    _providerConfig = ProviderConfigModel.fromSetup(
      modelProfileLabel: _providerConfig.modelProfileLabel,
      apiConnectionLabel: value,
      customApiBaseUrl: value == ProviderConfigModel.apiCustomBaseUrl
          ? _providerConfig.customApiBaseUrl
          : null,
    );
    notifyListeners();
  }

  void setCustomApiBaseUrl(String value) {
    _providerConfig = ProviderConfigModel.fromSetup(
      modelProfileLabel: _providerConfig.modelProfileLabel,
      apiConnectionLabel: _providerConfig.apiConnectionLabel,
      customApiBaseUrl: value.trim().isEmpty ? null : value.trim(),
    );
    notifyListeners();
  }

  void setDeployment(String value) {
    _selectedDeployment = value;
    notifyListeners();
  }

  void setOpenAiModelId(String modelId) {
    _pendingOpenAiModelId = modelId;
    _providerConfig = ProviderConfigModel.fromSetup(
      modelProfileLabel: modelId,
      apiConnectionLabel: ProviderConfigModel.apiOpenAiCompatible,
    );
    notifyListeners();
  }

  void completeModelSelection() {
    final String? id = _pendingOpenAiModelId;
    if (id == null || id.isEmpty) {
      return;
    }
    _step = AppFlowStep.mainShell;
    notifyListeners();
    unawaited(
      AppPrefs.saveAfterSetup(
        providerConfig: _providerConfig,
        runtimeDeploymentLabel: _selectedDeployment,
        openAiModelId: id,
      ),
    );
  }
}
