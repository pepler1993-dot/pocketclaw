import 'package:flutter/material.dart';

import 'flow/app_flow_controller.dart';
import 'models/provider_config_model.dart';
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

  @override
  void initState() {
    super.initState();
    _flowController = AppFlowController();
  }

  @override
  void dispose() {
    _session?.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              currentProvider: _flowController.selectedProvider,
              onProviderChanged: _flowController.setProvider,
              onFinish: _flowController.completeSetup,
            );
          case AppFlowStep.mainShell:
            _session ??= MockRuntimeService(
              providerConfig: ProviderConfigModel.fromSelectionLabel(
                _flowController.selectedProvider,
              ),
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
      const ChatScreen(),
      RuntimeScreen(session: widget.session),
      const DiagnosticsScreen(),
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
