import 'package:flutter/material.dart';

import 'flow/app_flow_controller.dart';
import 'l10n/app_localizations.dart';
import 'models/app_locale_preference.dart';
import 'models/runtime_deployment_model.dart';
import 'persistence/app_prefs.dart';
import 'persistence/openai_token_store.dart';
import 'screens/chat_screen.dart';
import 'screens/diagnostics_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/openai_login_screen.dart';
import 'screens/openai_model_select_screen.dart';
import 'screens/runtime_screen.dart';
import 'screens/settings_screen.dart';
import 'services/mock_runtime_service.dart';
import 'services/runtime_client.dart';
import 'theme/app_theme.dart';

class PocketClawApp extends StatefulWidget {
  const PocketClawApp({super.key});

  @override
  State<PocketClawApp> createState() => _PocketClawAppState();
}

class _PocketClawAppState extends State<PocketClawApp> {
  AppLocalePreference _localePref = AppLocalePreference.english;
  bool _localeReady = false;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final AppLocalePreference p = await AppPrefs.loadLocalePreference();
    if (mounted) {
      setState(() {
        _localePref = p;
        _localeReady = true;
      });
    }
  }

  Future<void> _onLocaleChanged(AppLocalePreference pref) async {
    await AppPrefs.saveLocalePreference(pref);
    if (mounted) {
      setState(() => _localePref = pref);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeReady) {
      return MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading…'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
      locale: _localePref.resolveLocale(),
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supported) {
        for (final Locale s in supported) {
          if (locale != null && s.languageCode == locale.languageCode) {
            return s;
          }
        }
        return const Locale('en');
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: _AppEntryPoint(
        localePreference: _localePref,
        onLocaleChanged: _onLocaleChanged,
      ),
    );
  }
}

class _AppEntryPoint extends StatefulWidget {
  const _AppEntryPoint({
    required this.localePreference,
    required this.onLocaleChanged,
  });

  final AppLocalePreference localePreference;
  final ValueChanged<AppLocalePreference> onLocaleChanged;

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
    bool hasToken = false;
    try {
      hasToken = await OpenAiTokenStore.hasAccessToken().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
    } catch (_) {
      hasToken = false;
    }
    _prefs = snap;
    _flowController.hydrateFromPrefs(
      onboardingDone: snap.onboardingDone,
      setupComplete: snap.setupComplete,
      openAiModelId: snap.openAiModelId,
      hasOpenAiAccessToken: hasToken,
      providerConfig: snap.providerConfig,
      runtimeDeploymentLabel: snap.runtimeDeploymentLabel,
    );
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  Future<void> _signOutAndReset() async {
    await OpenAiTokenStore.clearAll();
    await AppPrefs.clearOpenAiSetup();
    final AppPrefsSnapshot snap = await AppPrefs.load();
    bool hasToken = false;
    try {
      hasToken = await OpenAiTokenStore.hasAccessToken().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
    } catch (_) {
      hasToken = false;
    }
    _session?.dispose();
    _session = null;
    _prefs = snap;
    _flowController.hydrateFromPrefs(
      onboardingDone: snap.onboardingDone,
      setupComplete: snap.setupComplete,
      openAiModelId: snap.openAiModelId,
      hasOpenAiAccessToken: hasToken,
      providerConfig: snap.providerConfig,
      runtimeDeploymentLabel: snap.runtimeDeploymentLabel,
    );
    if (mounted) {
      setState(() {});
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
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.loadingApp,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
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
          case AppFlowStep.openaiLogin:
            return OpenAiLoginScreen(flow: _flowController);
          case AppFlowStep.openaiModel:
            return OpenAiModelSelectScreen(flow: _flowController);
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
            return _RootShell(
              session: _session!,
              onSignOut: _signOutAndReset,
              localePreference: widget.localePreference,
              onLocaleChanged: widget.onLocaleChanged,
            );
        }
      },
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell({
    required this.session,
    required this.onSignOut,
    required this.localePreference,
    required this.onLocaleChanged,
  });

  final RuntimeClient session;
  final Future<void> Function() onSignOut;
  final AppLocalePreference localePreference;
  final ValueChanged<AppLocalePreference> onLocaleChanged;

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<Widget> screens = <Widget>[
      ChatScreen(session: widget.session),
      RuntimeScreen(session: widget.session),
      DiagnosticsScreen(session: widget.session),
      SettingsScreen(
        session: widget.session,
        onSignOut: widget.onSignOut,
        localePreference: widget.localePreference,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: l10n.navChat,
          ),
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline),
            selectedIcon: const Icon(Icons.play_circle),
            label: l10n.navRuntime,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bug_report_outlined),
            selectedIcon: const Icon(Icons.bug_report),
            label: l10n.navDiagnostics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
