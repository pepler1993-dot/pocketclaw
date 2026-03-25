// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PocketClaw';

  @override
  String get loadingApp => 'Loading PocketClaw…';

  @override
  String get navChat => 'Chat';

  @override
  String get navRuntime => 'Runtime';

  @override
  String get navDiagnostics => 'Diagnostics';

  @override
  String get navSettings => 'Settings';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSectionSubtitle =>
      'English is the default. German is optional.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageDescription =>
      'Choose app language. “System” follows your device settings (falls back to English).';

  @override
  String get onboardingBadge => 'Android-first · local where it matters';

  @override
  String get onboardingHeadlinePart1 => 'OpenClaw';

  @override
  String get onboardingHeadlinePart2 => '\nin your pocket.';

  @override
  String get onboardingIntro =>
      'A calm mobile shell for OpenClaw: chat, runtime health, and diagnostics without digging through config files.';

  @override
  String get onboardingYouGet => 'YOU GET';

  @override
  String get onboardingFeature1Title => 'Operational dark UI';

  @override
  String get onboardingFeature1Subtitle => 'Low noise, high signal';

  @override
  String get onboardingFeature2Title => 'Runtime health at a glance';

  @override
  String get onboardingFeature2Subtitle => 'Status, actions, checks';

  @override
  String get onboardingFeature3Title => 'Assistant-ready chat';

  @override
  String get onboardingFeature3Subtitle => 'Voice or type — your choice';

  @override
  String get onboardingFooter => 'Next: pick a provider — about a minute.';

  @override
  String get onboardingContinue => 'Connection setup';

  @override
  String get openAiSignInTitle => 'Sign in with OpenAI';

  @override
  String get openAiConnectHeadline => 'Connect your OpenAI account';

  @override
  String get openAiConnectBody =>
      'PocketClaw uses OAuth 2.0 with PKCE (no client secret in the app). After you sign in, you will choose a ChatGPT model for chat.';

  @override
  String get openAiConfigSection => 'Configuration';

  @override
  String get openAiConfiguredHint =>
      'OAuth endpoints are set via build flags (see docs/OPENAI_OAUTH.md).';

  @override
  String get openAiNotConfiguredHint =>
      'OAuth is not configured. Add --dart-define values for OPENAI_OAUTH_CLIENT_ID, OPENAI_OAUTH_AUTH_URL, and OPENAI_OAUTH_TOKEN_URL, or use the debug shortcut below.';

  @override
  String get openAiSignInButton => 'Sign in with OpenAI';

  @override
  String get openAiOAuthDisabled => 'OAuth not configured';

  @override
  String get openAiSimulateDebug => 'Simulate OAuth (debug only)';

  @override
  String openAiSignInFailed(Object error) {
    return 'Sign-in failed: $error';
  }

  @override
  String get modelSelectTitle => 'Choose a model';

  @override
  String get modelSelectHeadline => 'ChatGPT models';

  @override
  String get modelSelectBody =>
      'Pick which model PocketClaw uses for chat. You can change this later in settings.';

  @override
  String get modelSelectContinue => 'Continue to PocketClaw';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'OpenAI account, model, and runtime.';

  @override
  String get settingsOpenAiSection => 'OpenAI';

  @override
  String get settingsOpenAiSectionSubtitle =>
      'OAuth (PKCE) plus optional API key for chat. Key takes precedence for api.openai.com.';

  @override
  String get settingsChatModel => 'Chat model';

  @override
  String get settingsRuntimeLocation => 'Runtime location';

  @override
  String get settingsWhereRunsTitle => 'Where OpenClaw runs';

  @override
  String get settingsRuntimePrefs => 'Runtime preferences';

  @override
  String get settingsAutoStartTitle => 'Auto-start runtime';

  @override
  String get settingsAutoStartDesc => 'Launch services when app opens';

  @override
  String get settingsAlertTitle => 'Alert level';

  @override
  String get settingsAlertDesc => 'Only notify on warnings and failures';

  @override
  String get settingsSyncTitle => 'Sync frequency';

  @override
  String get settingsSyncDesc => 'Push local state on a fixed cadence';

  @override
  String get settingsDataPrivacy => 'Data and privacy';

  @override
  String get settingsDiagUploadTitle => 'Diagnostics upload';

  @override
  String get settingsDiagUploadDesc =>
      'Share anonymized crash and performance data';

  @override
  String get settingsClearCacheTitle => 'Clear local cache';

  @override
  String get settingsClearCacheDesc =>
      'Remove downloaded logs and temp snapshots';

  @override
  String get settingsClearCacheButton => 'Clear';

  @override
  String get settingsClearCacheNotAvailable =>
      'Not available in this version yet.';

  @override
  String get settingsSignOut => 'Sign out of OpenAI';

  @override
  String get signOutDialogTitle => 'Sign out';

  @override
  String get signOutDialogBody =>
      'You will need to sign in with OpenAI again and pick a model.';

  @override
  String get signOutCancel => 'Cancel';

  @override
  String get signOutConfirm => 'Sign out';

  @override
  String get alertQuiet => 'Quiet';

  @override
  String get alertModerate => 'Moderate';

  @override
  String get alertVerbose => 'Verbose';

  @override
  String get deploymentThisPhone => 'This phone';

  @override
  String get deploymentLan => 'Home network (LAN)';

  @override
  String get deploymentCloud => 'OpenClaw Cloud';

  @override
  String get deploymentCustom => 'Custom gateway';

  @override
  String get deploymentThisPhoneDesc =>
      'Gateway targets this device (local-first).';

  @override
  String get deploymentLanDesc =>
      'Gateway runs on another device on your Wi‑Fi or LAN.';

  @override
  String get deploymentCloudDesc => 'Hosted OpenClaw runtime (remote).';

  @override
  String get deploymentCustomDesc => 'Connect to your own gateway URL.';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatSubtitle =>
      'Ask about your setup, runtime, or diagnostics. Use an OpenClaw Gateway or an OpenAI API key in Settings for live replies.';

  @override
  String get chatAssistantSection => 'Assistant';

  @override
  String get chatAssistantSubtitle =>
      'Uses your API key when set; otherwise offline-style replies.';

  @override
  String get chatAssistantHint =>
      'Try “runtime status”, attach a file, or tap the mic for speech-to-text.';

  @override
  String get chatMessageHint => 'Message PocketClaw';

  @override
  String get chatAttachTooltip => 'Attach file';

  @override
  String get chatSpeechTooltip => 'Speech to text';

  @override
  String get chatSpeechStopTooltip => 'Stop dictation';

  @override
  String get chatSendTooltip => 'Send';

  @override
  String get chatAuthorYou => 'You';

  @override
  String get chatAuthorAssistant => 'PocketClaw';

  @override
  String chatWelcomeBody(Object model, Object gateway) {
    return 'Model/API: $model. Gateway: $gateway. Ask for runtime status, attach a file, or use the mic.';
  }

  @override
  String get chatSpeechUnavailable =>
      'Speech recognition is not available on this device.';

  @override
  String chatOpenAiErrorFallback(Object error) {
    return 'OpenAI: $error — using mock reply.';
  }

  @override
  String get chatStreaming => 'Replying…';

  @override
  String chatBackendErrorFallback(Object error) {
    return 'Chat backend: $error — using offline reply.';
  }

  @override
  String get gatewaySectionTitle => 'OpenClaw Gateway';

  @override
  String get gatewaySectionSubtitle =>
      'Route chat through your gateway’s OpenAI-compatible HTTP API (e.g. port 18789). When enabled and configured, this overrides direct OpenAI.';

  @override
  String get gatewayUseForChat => 'Use gateway for chat';

  @override
  String get gatewayUseForChatDesc =>
      'Requires base URL and operator token. Priority over OpenAI API key / OAuth for chat.';

  @override
  String get gatewayBaseUrlLabel => 'Gateway base URL';

  @override
  String get gatewayBaseUrlHint => 'http://192.168.1.10:18789';

  @override
  String get gatewayTokenLabel => 'Operator token';

  @override
  String get gatewayTokenHintSaved =>
      'Token is saved on device. Enter a new value to replace it.';

  @override
  String get gatewayTokenHintEmpty =>
      'Paste gateway auth token (see gateway docs).';

  @override
  String get gatewaySave => 'Save gateway settings';

  @override
  String get gatewayTest => 'Test connection';

  @override
  String gatewayTestSuccess(Object count) {
    return 'Gateway OK — $count model(s) reported.';
  }

  @override
  String gatewayTestFail(Object detail) {
    return 'Connection failed: $detail';
  }

  @override
  String get gatewaySaved => 'Gateway settings saved.';

  @override
  String get gatewayErrNoUrl => 'Enter a gateway base URL first.';

  @override
  String get gatewayErrNoToken => 'Enter or save an operator token first.';

  @override
  String get gatewayWsTest => 'Test WebSocket (hello-ok)';

  @override
  String gatewayWsSuccess(Object protocol, Object server) {
    return 'WebSocket hello-ok — protocol $protocol, server $server.';
  }

  @override
  String gatewayWsFail(Object error) {
    return 'WebSocket: $error';
  }

  @override
  String get chatNoMessagePlaceholder => '(no message)';

  @override
  String get chatMockSayEmpty =>
      'Say something or attach a file to get started.';

  @override
  String get chatMockSayText => 'Say something to get started.';

  @override
  String chatMockAttachmentIntro(Object name) {
    return 'Received attachment “$name” (mock: not uploaded). ';
  }

  @override
  String get chatMockAttachmentAddContext =>
      'Add a message if you want context.';

  @override
  String chatMockRuntimeReply(Object gateway, Object model, Object lifecycle,
      Object heartbeat, Object depth) {
    return 'Gateway: $gateway. Model/API: $model. Runtime is $lifecycle. $heartbeat Queue depth: $depth.';
  }

  @override
  String chatMockDiagReply(Object count) {
    return 'Diagnostics has $count recent events. Open the Diagnostics tab for details.';
  }

  @override
  String get chatMockHello => 'Hi. Ask me about runtime status or diagnostics.';

  @override
  String get chatMockDefault =>
      'Got it. Try: “runtime status” or “show diagnostics”.';

  @override
  String get lifecycleStoppedWord => 'stopped';

  @override
  String get lifecycleStartingWord => 'starting';

  @override
  String get lifecycleRunningWord => 'running';

  @override
  String get lifecycleDegradedWord => 'degraded';

  @override
  String get lifecycleErrorWord => 'in error';

  @override
  String get runtimeTitle => 'Runtime';

  @override
  String get runtimeSubtitle =>
      'Control background activity and inspect live state.';

  @override
  String get runtimeStatusSection => 'Runtime status';

  @override
  String get runtimeQuickActions => 'Quick actions';

  @override
  String get runtimeStart => 'Start runtime';

  @override
  String get runtimeRestart => 'Restart runtime';

  @override
  String get runtimeHealthCheck => 'Run health check';

  @override
  String get runtimeHealthChecking => 'Checking…';

  @override
  String get runtimeQueuePause => 'Pause queue';

  @override
  String get runtimeQueueResume => 'Resume queue';

  @override
  String get runtimeStop => 'Stop runtime';

  @override
  String get runtimeHealthChecks => 'Health checks';

  @override
  String get runtimeNoChecksStopped => 'No checks while runtime is stopped.';

  @override
  String runtimeModeLine(Object mode) {
    return 'Mode: $mode';
  }

  @override
  String runtimeQueueLine(Object depth) {
    return 'Queue: $depth pending';
  }

  @override
  String get runtimeDotStopped => 'Stopped';

  @override
  String get runtimeDotStarting => 'Starting';

  @override
  String get runtimeDotHealthy => 'Healthy';

  @override
  String get runtimeDotAttention => 'Attention';

  @override
  String get runtimeDotError => 'Error';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsSubtitle => 'Inspect health, events, and runtime logs.';

  @override
  String get diagnosticsHealthSummary => 'Health summary';

  @override
  String get diagnosticsChecksPassing => 'Checks passing';

  @override
  String get diagnosticsActiveWarnings => 'Active warnings';

  @override
  String get diagnosticsLastScan => 'Last full scan';

  @override
  String get diagnosticsRecentEvents => 'Recent events';

  @override
  String get diagnosticsNoEvents => 'No events yet.';

  @override
  String get diagnosticsLogPreview => 'Log preview';

  @override
  String get diagnosticsLogPreviewSubtitle => 'Most recent entries';

  @override
  String get diagnosticsSummaryStopped => 'Stopped';

  @override
  String get diagnosticsSummaryAttention => 'Attention';

  @override
  String get diagnosticsSummaryHealthy => 'Healthy';

  @override
  String diagnosticsToday(Object time) {
    return 'Today, $time';
  }

  @override
  String diagnosticsDateTime(Object date, Object time) {
    return '$date $time';
  }

  @override
  String get openAiApiKeyTitle => 'API key (optional)';

  @override
  String get openAiApiKeyBody =>
      'For reliable access to api.openai.com, paste an API key from platform.openai.com/api-keys. Stored encrypted on device only; never logged.';

  @override
  String get openAiApiKeyHasSaved =>
      'A key is saved. Enter a new one to replace it.';

  @override
  String get openAiApiKeyFieldLabel => 'OpenAI API key';

  @override
  String get openAiApiKeyFieldHint => 'sk-…';

  @override
  String get openAiApiKeySave => 'Save key';

  @override
  String get openAiApiKeyRemove => 'Remove key';

  @override
  String get openAiApiKeySaved => 'API key saved on this device.';

  @override
  String get openAiApiKeyRemoved => 'API key removed.';
}
