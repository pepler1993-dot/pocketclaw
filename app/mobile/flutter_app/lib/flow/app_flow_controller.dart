import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';

import '../persistence/app_prefs.dart';

enum AppFlowStep {
  onboarding,
  providerSetup,
  mainShell,
}

class AppFlowController extends ChangeNotifier {
  AppFlowStep _step = AppFlowStep.onboarding;
  String _selectedProvider = 'Local Runtime';

  AppFlowStep get step => _step;
  String get selectedProvider => _selectedProvider;

  /// Restores onboarding/setup progress from local storage.
  void hydrateFromPrefs({
    required bool setupComplete,
    required String selectedProvider,
  }) {
    _selectedProvider = selectedProvider;
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

  void completeSetup() {
    _step = AppFlowStep.mainShell;
    notifyListeners();
    unawaited(AppPrefs.saveAfterSetup(provider: _selectedProvider));
  }
}
