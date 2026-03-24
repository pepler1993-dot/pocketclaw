import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';

import '../models/runtime_deployment_model.dart';
import '../persistence/app_prefs.dart';

enum AppFlowStep {
  onboarding,
  providerSetup,
  mainShell,
}

class AppFlowController extends ChangeNotifier {
  AppFlowStep _step = AppFlowStep.onboarding;
  String _selectedProvider = 'Local Runtime';
  String _selectedDeployment = RuntimeDeploymentModel.labelThisPhone;

  AppFlowStep get step => _step;
  String get selectedProvider => _selectedProvider;
  String get selectedDeployment => _selectedDeployment;

  /// Restores onboarding/setup progress from local storage.
  void hydrateFromPrefs({
    required bool setupComplete,
    required String selectedProvider,
    required String runtimeDeploymentLabel,
  }) {
    _selectedProvider = selectedProvider;
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

  void setProvider(String value) {
    _selectedProvider = value;
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
        provider: _selectedProvider,
        runtimeDeploymentLabel: _selectedDeployment,
      ),
    );
  }
}
