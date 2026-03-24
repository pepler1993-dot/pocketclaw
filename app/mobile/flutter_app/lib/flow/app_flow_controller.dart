import 'package:flutter/foundation.dart';

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
  }
}
