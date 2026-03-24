import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';

import '../models/provider_config_model.dart';
import '../models/runtime_deployment_model.dart';
import '../persistence/app_prefs.dart';

enum AppFlowStep {
  onboarding,
  providerSetup,
  mainShell,
}

class AppFlowController extends ChangeNotifier {
  AppFlowStep _step = AppFlowStep.onboarding;
  ProviderConfigModel _providerConfig = ProviderConfigModel.fromSetup(
    modelProfileLabel: ProviderConfigModel.modelDefault,
    apiConnectionLabel: ProviderConfigModel.apiGatewayEmbedded,
  );
  String _selectedDeployment = RuntimeDeploymentModel.labelThisPhone;

  AppFlowStep get step => _step;
  ProviderConfigModel get providerConfig => _providerConfig;
  String get selectedDeployment => _selectedDeployment;

  /// Restores onboarding/setup progress from local storage.
  void hydrateFromPrefs({
    required bool setupComplete,
    required ProviderConfigModel providerConfig,
    required String runtimeDeploymentLabel,
  }) {
    _providerConfig = providerConfig;
    _selectedDeployment = runtimeDeploymentLabel;
    if (setupComplete) {
      _step = AppFlowStep.mainShell;
    }
    notifyListeners();
  }

  void continueFromOnboarding() {
    _step = AppFlowStep.providerSetup;
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

  void completeSetup() {
    _step = AppFlowStep.mainShell;
    notifyListeners();
    unawaited(
      AppPrefs.saveAfterSetup(
        providerConfig: _providerConfig,
        runtimeDeploymentLabel: _selectedDeployment,
      ),
    );
  }
}
