import 'package:flutter/material.dart';

import 'flow/app_flow_controller.dart';
import 'models/runtime_deployment_model.dart';
import 'persistence/app_prefs.dart';
import 'screens/chat_screen.dart';
import 'screens/diagnostics_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/provider_setup_screen.dart';
import 'screens/runtime_screen.dart';
import 'screens/settings_screen.dart';
import 'services/mock_runtime_service.dart';
import 'theme/app_theme.dart';

class PocketClawApp extends StatelessWidget {
  const PocketClawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketClaw',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const _AppEntryPoint(),
    );
  }
}

class _AppEntryPoint extends StatefulWidget {
  const _AppEntryPoint();

  @override
  State<_AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<_AppEntryPoint> {
  late final AppFlowController _flowController;
  MockRuntimeService? _session;
  AppPrefsSnapshot? _prefs;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _flowController = AppFlowController();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final AppPrefsSnapshot snap = await AppPrefs.load();
    _prefs = snap;
    _flowController.hydrateFromPrefs(
      setupComplete: snap.setupComplete,
      providerConfig: snap.providerConfig,
      runtimeDeploymentLabel: snap.runtimeDeploymentLabel,
    );
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _session?.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedBuilder(
      animation: _flowController,
      builder: (BuildContext context, Widget? child) {
        switch (_flowController.step) {
          case AppFlowStep.onboarding:
            return OnboardingScreen(
              onContinue: _flowController.continueFromOnboarding,
            );
          case AppFlowStep.providerSetup:
            return ProviderSetupScreen(
              providerConfig: _flowController.providerConfig,
              currentDeployment: _flowController.selectedDeployment,
              onModelProfileChanged: _flowController.setModelProfile,
              onApiConnectionChanged: _flowController.setApiConnection,
              onCustomApiBaseUrlChanged: _flowController.setCustomApiBaseUrl,
              onDeploymentChanged: _flowController.setDeployment,
              onFinish: _flowController.completeSetup,
            );
          case AppFlowStep.mainShell:
            final AppPrefsSnapshot snap = _prefs!;
            _session ??= MockRuntimeService(
              providerConfig: _flowController.providerConfig,
              deployment: RuntimeDeploymentModel.fromSelectionLabel(
                _flowController.selectedDeployment,
              ),
              autoStartRuntime: snap.autoStartRuntime,
              alertLevel: snap.alertLevel,
              syncFrequencyLabel: snap.syncFrequencyLabel,
              diagnosticsUploadEnabled: snap.diagnosticsUploadEnabled,
            );
            return _RootShell(session: _session!);
        }
      },
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell({required this.session});

  final MockRuntimeService session;

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      ChatScreen(session: widget.session),
      RuntimeScreen(session: widget.session),
      DiagnosticsScreen(session: widget.session),
      SettingsScreen(session: widget.session),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.play_circle_outline), label: 'Runtime'),
          NavigationDestination(icon: Icon(Icons.bug_report_outlined), label: 'Diagnostics'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
