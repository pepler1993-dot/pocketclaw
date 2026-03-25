import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PocketClaw'**
  String get appTitle;

  /// No description provided for @loadingApp.
  ///
  /// In en, this message translates to:
  /// **'Loading PocketClaw…'**
  String get loadingApp;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navRuntime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get navRuntime;

  /// No description provided for @navDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get navDiagnostics;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English is the default. German is optional.'**
  String get languageSectionSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose app language. “System” follows your device settings (falls back to English).'**
  String get languageDescription;

  /// No description provided for @onboardingBadge.
  ///
  /// In en, this message translates to:
  /// **'Android-first · local where it matters'**
  String get onboardingBadge;

  /// No description provided for @onboardingHeadlinePart1.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw'**
  String get onboardingHeadlinePart1;

  /// No description provided for @onboardingHeadlinePart2.
  ///
  /// In en, this message translates to:
  /// **'\nin your pocket.'**
  String get onboardingHeadlinePart2;

  /// No description provided for @onboardingIntro.
  ///
  /// In en, this message translates to:
  /// **'A calm mobile shell for OpenClaw: chat, runtime health, and diagnostics without digging through config files.'**
  String get onboardingIntro;

  /// No description provided for @onboardingYouGet.
  ///
  /// In en, this message translates to:
  /// **'YOU GET'**
  String get onboardingYouGet;

  /// No description provided for @onboardingFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Operational dark UI'**
  String get onboardingFeature1Title;

  /// No description provided for @onboardingFeature1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Low noise, high signal'**
  String get onboardingFeature1Subtitle;

  /// No description provided for @onboardingFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'Runtime health at a glance'**
  String get onboardingFeature2Title;

  /// No description provided for @onboardingFeature2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Status, actions, checks'**
  String get onboardingFeature2Subtitle;

  /// No description provided for @onboardingFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Assistant-ready chat'**
  String get onboardingFeature3Title;

  /// No description provided for @onboardingFeature3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Voice or type — your choice'**
  String get onboardingFeature3Subtitle;

  /// No description provided for @onboardingFooter.
  ///
  /// In en, this message translates to:
  /// **'Next: pick a provider — about a minute.'**
  String get onboardingFooter;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Connection setup'**
  String get onboardingContinue;

  /// No description provided for @openAiSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with OpenAI'**
  String get openAiSignInTitle;

  /// No description provided for @openAiConnectHeadline.
  ///
  /// In en, this message translates to:
  /// **'Connect your OpenAI account'**
  String get openAiConnectHeadline;

  /// No description provided for @openAiConnectBody.
  ///
  /// In en, this message translates to:
  /// **'PocketClaw uses OAuth 2.0 with PKCE (no client secret in the app). After you sign in, you will choose a ChatGPT model for chat.'**
  String get openAiConnectBody;

  /// No description provided for @openAiConfigSection.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get openAiConfigSection;

  /// No description provided for @openAiConfiguredHint.
  ///
  /// In en, this message translates to:
  /// **'OAuth endpoints are set via build flags (see docs/OPENAI_OAUTH.md).'**
  String get openAiConfiguredHint;

  /// No description provided for @openAiNotConfiguredHint.
  ///
  /// In en, this message translates to:
  /// **'OAuth is not configured. Add --dart-define values for OPENAI_OAUTH_CLIENT_ID, OPENAI_OAUTH_AUTH_URL, and OPENAI_OAUTH_TOKEN_URL, or use the debug shortcut below.'**
  String get openAiNotConfiguredHint;

  /// No description provided for @openAiSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with OpenAI'**
  String get openAiSignInButton;

  /// No description provided for @openAiOAuthDisabled.
  ///
  /// In en, this message translates to:
  /// **'OAuth not configured'**
  String get openAiOAuthDisabled;

  /// No description provided for @openAiSimulateDebug.
  ///
  /// In en, this message translates to:
  /// **'Simulate OAuth (debug only)'**
  String get openAiSimulateDebug;

  /// No description provided for @openAiSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {error}'**
  String openAiSignInFailed(Object error);

  /// No description provided for @modelSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a model'**
  String get modelSelectTitle;

  /// No description provided for @modelSelectHeadline.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT models'**
  String get modelSelectHeadline;

  /// No description provided for @modelSelectBody.
  ///
  /// In en, this message translates to:
  /// **'Pick which model PocketClaw uses for chat. You can change this later in settings.'**
  String get modelSelectBody;

  /// No description provided for @modelSelectContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to PocketClaw'**
  String get modelSelectContinue;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'OpenAI account, model, and runtime.'**
  String get settingsSubtitle;

  /// No description provided for @settingsOpenAiSection.
  ///
  /// In en, this message translates to:
  /// **'OpenAI'**
  String get settingsOpenAiSection;

  /// No description provided for @settingsOpenAiSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'OAuth (PKCE) plus optional API key for chat. Key takes precedence for api.openai.com.'**
  String get settingsOpenAiSectionSubtitle;

  /// No description provided for @settingsChatModel.
  ///
  /// In en, this message translates to:
  /// **'Chat model'**
  String get settingsChatModel;

  /// No description provided for @settingsRuntimeLocation.
  ///
  /// In en, this message translates to:
  /// **'Runtime location'**
  String get settingsRuntimeLocation;

  /// No description provided for @settingsWhereRunsTitle.
  ///
  /// In en, this message translates to:
  /// **'Where OpenClaw runs'**
  String get settingsWhereRunsTitle;

  /// No description provided for @settingsRuntimePrefs.
  ///
  /// In en, this message translates to:
  /// **'Runtime preferences'**
  String get settingsRuntimePrefs;

  /// No description provided for @settingsAutoStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-start runtime'**
  String get settingsAutoStartTitle;

  /// No description provided for @settingsAutoStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Launch services when app opens'**
  String get settingsAutoStartDesc;

  /// No description provided for @settingsAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert level'**
  String get settingsAlertTitle;

  /// No description provided for @settingsAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'Only notify on warnings and failures'**
  String get settingsAlertDesc;

  /// No description provided for @settingsSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync frequency'**
  String get settingsSyncTitle;

  /// No description provided for @settingsSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Push local state on a fixed cadence'**
  String get settingsSyncDesc;

  /// No description provided for @settingsDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data and privacy'**
  String get settingsDataPrivacy;

  /// No description provided for @settingsDiagUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics upload'**
  String get settingsDiagUploadTitle;

  /// No description provided for @settingsDiagUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'Share anonymized crash and performance data'**
  String get settingsDiagUploadDesc;

  /// No description provided for @settingsClearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear local cache'**
  String get settingsClearCacheTitle;

  /// No description provided for @settingsClearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove downloaded logs and temp snapshots'**
  String get settingsClearCacheDesc;

  /// No description provided for @settingsClearCacheButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearCacheButton;

  /// No description provided for @settingsClearCacheNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available in this version yet.'**
  String get settingsClearCacheNotAvailable;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out of OpenAI'**
  String get settingsSignOut;

  /// No description provided for @signOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutDialogTitle;

  /// No description provided for @signOutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in with OpenAI again and pick a model.'**
  String get signOutDialogBody;

  /// No description provided for @signOutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get signOutCancel;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutConfirm;

  /// No description provided for @alertQuiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get alertQuiet;

  /// No description provided for @alertModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get alertModerate;

  /// No description provided for @alertVerbose.
  ///
  /// In en, this message translates to:
  /// **'Verbose'**
  String get alertVerbose;

  /// No description provided for @deploymentThisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get deploymentThisPhone;

  /// No description provided for @deploymentLan.
  ///
  /// In en, this message translates to:
  /// **'Home network (LAN)'**
  String get deploymentLan;

  /// No description provided for @deploymentCloud.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw Cloud'**
  String get deploymentCloud;

  /// No description provided for @deploymentCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom gateway'**
  String get deploymentCustom;

  /// No description provided for @deploymentThisPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Gateway targets this device (local-first).'**
  String get deploymentThisPhoneDesc;

  /// No description provided for @deploymentLanDesc.
  ///
  /// In en, this message translates to:
  /// **'Gateway runs on another device on your Wi‑Fi or LAN.'**
  String get deploymentLanDesc;

  /// No description provided for @deploymentCloudDesc.
  ///
  /// In en, this message translates to:
  /// **'Hosted OpenClaw runtime (remote).'**
  String get deploymentCloudDesc;

  /// No description provided for @deploymentCustomDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect to your own gateway URL.'**
  String get deploymentCustomDesc;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about your setup, runtime, or diagnostics. Use an OpenClaw Gateway or an OpenAI API key in Settings for live replies.'**
  String get chatSubtitle;

  /// No description provided for @chatAssistantSection.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get chatAssistantSection;

  /// No description provided for @chatAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses your API key when set; otherwise offline-style replies.'**
  String get chatAssistantSubtitle;

  /// No description provided for @chatAssistantHint.
  ///
  /// In en, this message translates to:
  /// **'Try “runtime status”, attach a file, or tap the mic for speech-to-text.'**
  String get chatAssistantHint;

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message PocketClaw'**
  String get chatMessageHint;

  /// No description provided for @chatAttachTooltip.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get chatAttachTooltip;

  /// No description provided for @chatSpeechTooltip.
  ///
  /// In en, this message translates to:
  /// **'Speech to text'**
  String get chatSpeechTooltip;

  /// No description provided for @chatSpeechStopTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop dictation'**
  String get chatSpeechStopTooltip;

  /// No description provided for @chatSendTooltip.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSendTooltip;

  /// No description provided for @chatAuthorYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get chatAuthorYou;

  /// No description provided for @chatAuthorAssistant.
  ///
  /// In en, this message translates to:
  /// **'PocketClaw'**
  String get chatAuthorAssistant;

  /// No description provided for @chatWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Model/API: {model}. Gateway: {gateway}. Ask for runtime status, attach a file, or use the mic.'**
  String chatWelcomeBody(Object model, Object gateway);

  /// No description provided for @chatSpeechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get chatSpeechUnavailable;

  /// No description provided for @chatOpenAiErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'OpenAI: {error} — using mock reply.'**
  String chatOpenAiErrorFallback(Object error);

  /// No description provided for @chatStreaming.
  ///
  /// In en, this message translates to:
  /// **'Replying…'**
  String get chatStreaming;

  /// No description provided for @chatBackendErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Chat backend: {error} — using offline reply.'**
  String chatBackendErrorFallback(Object error);

  /// No description provided for @gatewaySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw Gateway'**
  String get gatewaySectionTitle;

  /// No description provided for @gatewaySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Route chat through your gateway’s OpenAI-compatible HTTP API (e.g. port 18789). When enabled and configured, this overrides direct OpenAI.'**
  String get gatewaySectionSubtitle;

  /// No description provided for @gatewayUseForChat.
  ///
  /// In en, this message translates to:
  /// **'Use gateway for chat'**
  String get gatewayUseForChat;

  /// No description provided for @gatewayUseForChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Requires base URL and operator token. Priority over OpenAI API key / OAuth for chat.'**
  String get gatewayUseForChatDesc;

  /// No description provided for @gatewayBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Gateway base URL'**
  String get gatewayBaseUrlLabel;

  /// No description provided for @gatewayBaseUrlHint.
  ///
  /// In en, this message translates to:
  /// **'http://192.168.1.10:18789'**
  String get gatewayBaseUrlHint;

  /// No description provided for @gatewayTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Operator token'**
  String get gatewayTokenLabel;

  /// No description provided for @gatewayTokenHintSaved.
  ///
  /// In en, this message translates to:
  /// **'Token is saved on device. Enter a new value to replace it.'**
  String get gatewayTokenHintSaved;

  /// No description provided for @gatewayTokenHintEmpty.
  ///
  /// In en, this message translates to:
  /// **'Paste gateway auth token (see gateway docs).'**
  String get gatewayTokenHintEmpty;

  /// No description provided for @gatewaySave.
  ///
  /// In en, this message translates to:
  /// **'Save gateway settings'**
  String get gatewaySave;

  /// No description provided for @gatewayTest.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get gatewayTest;

  /// No description provided for @gatewayTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gateway OK — {count} model(s) reported.'**
  String gatewayTestSuccess(Object count);

  /// No description provided for @gatewayTestFail.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {detail}'**
  String gatewayTestFail(Object detail);

  /// No description provided for @gatewaySaved.
  ///
  /// In en, this message translates to:
  /// **'Gateway settings saved.'**
  String get gatewaySaved;

  /// No description provided for @gatewayErrNoUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a gateway base URL first.'**
  String get gatewayErrNoUrl;

  /// No description provided for @gatewayErrNoToken.
  ///
  /// In en, this message translates to:
  /// **'Enter or save an operator token first.'**
  String get gatewayErrNoToken;

  /// No description provided for @gatewayWsTest.
  ///
  /// In en, this message translates to:
  /// **'Test WebSocket (hello-ok)'**
  String get gatewayWsTest;

  /// No description provided for @gatewayWsSuccess.
  ///
  /// In en, this message translates to:
  /// **'WebSocket hello-ok — protocol {protocol}, server {server}.'**
  String gatewayWsSuccess(Object protocol, Object server);

  /// No description provided for @gatewayWsFail.
  ///
  /// In en, this message translates to:
  /// **'WebSocket: {error}'**
  String gatewayWsFail(Object error);

  /// No description provided for @chatNoMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'(no message)'**
  String get chatNoMessagePlaceholder;

  /// No description provided for @chatMockSayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Say something or attach a file to get started.'**
  String get chatMockSayEmpty;

  /// No description provided for @chatMockSayText.
  ///
  /// In en, this message translates to:
  /// **'Say something to get started.'**
  String get chatMockSayText;

  /// No description provided for @chatMockAttachmentIntro.
  ///
  /// In en, this message translates to:
  /// **'Received attachment “{name}” (mock: not uploaded). '**
  String chatMockAttachmentIntro(Object name);

  /// No description provided for @chatMockAttachmentAddContext.
  ///
  /// In en, this message translates to:
  /// **'Add a message if you want context.'**
  String get chatMockAttachmentAddContext;

  /// No description provided for @chatMockRuntimeReply.
  ///
  /// In en, this message translates to:
  /// **'Gateway: {gateway}. Model/API: {model}. Runtime is {lifecycle}. {heartbeat} Queue depth: {depth}.'**
  String chatMockRuntimeReply(Object gateway, Object model, Object lifecycle,
      Object heartbeat, Object depth);

  /// No description provided for @chatMockDiagReply.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics has {count} recent events. Open the Diagnostics tab for details.'**
  String chatMockDiagReply(Object count);

  /// No description provided for @chatMockHello.
  ///
  /// In en, this message translates to:
  /// **'Hi. Ask me about runtime status or diagnostics.'**
  String get chatMockHello;

  /// No description provided for @chatMockDefault.
  ///
  /// In en, this message translates to:
  /// **'Got it. Try: “runtime status” or “show diagnostics”.'**
  String get chatMockDefault;

  /// No description provided for @lifecycleStoppedWord.
  ///
  /// In en, this message translates to:
  /// **'stopped'**
  String get lifecycleStoppedWord;

  /// No description provided for @lifecycleStartingWord.
  ///
  /// In en, this message translates to:
  /// **'starting'**
  String get lifecycleStartingWord;

  /// No description provided for @lifecycleRunningWord.
  ///
  /// In en, this message translates to:
  /// **'running'**
  String get lifecycleRunningWord;

  /// No description provided for @lifecycleDegradedWord.
  ///
  /// In en, this message translates to:
  /// **'degraded'**
  String get lifecycleDegradedWord;

  /// No description provided for @lifecycleErrorWord.
  ///
  /// In en, this message translates to:
  /// **'in error'**
  String get lifecycleErrorWord;

  /// No description provided for @runtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtimeTitle;

  /// No description provided for @runtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control background activity and inspect live state.'**
  String get runtimeSubtitle;

  /// No description provided for @runtimeStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Runtime status'**
  String get runtimeStatusSection;

  /// No description provided for @runtimeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get runtimeQuickActions;

  /// No description provided for @runtimeStart.
  ///
  /// In en, this message translates to:
  /// **'Start runtime'**
  String get runtimeStart;

  /// No description provided for @runtimeRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart runtime'**
  String get runtimeRestart;

  /// No description provided for @runtimeHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'Run health check'**
  String get runtimeHealthCheck;

  /// No description provided for @runtimeHealthChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get runtimeHealthChecking;

  /// No description provided for @runtimeQueuePause.
  ///
  /// In en, this message translates to:
  /// **'Pause queue'**
  String get runtimeQueuePause;

  /// No description provided for @runtimeQueueResume.
  ///
  /// In en, this message translates to:
  /// **'Resume queue'**
  String get runtimeQueueResume;

  /// No description provided for @runtimeStop.
  ///
  /// In en, this message translates to:
  /// **'Stop runtime'**
  String get runtimeStop;

  /// No description provided for @runtimeHealthChecks.
  ///
  /// In en, this message translates to:
  /// **'Health checks'**
  String get runtimeHealthChecks;

  /// No description provided for @runtimeNoChecksStopped.
  ///
  /// In en, this message translates to:
  /// **'No checks while runtime is stopped.'**
  String get runtimeNoChecksStopped;

  /// No description provided for @runtimeModeLine.
  ///
  /// In en, this message translates to:
  /// **'Mode: {mode}'**
  String runtimeModeLine(Object mode);

  /// No description provided for @runtimeQueueLine.
  ///
  /// In en, this message translates to:
  /// **'Queue: {depth} pending'**
  String runtimeQueueLine(Object depth);

  /// No description provided for @runtimeDotStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get runtimeDotStopped;

  /// No description provided for @runtimeDotStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get runtimeDotStarting;

  /// No description provided for @runtimeDotHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get runtimeDotHealthy;

  /// No description provided for @runtimeDotAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get runtimeDotAttention;

  /// No description provided for @runtimeDotError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get runtimeDotError;

  /// No description provided for @diagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnosticsTitle;

  /// No description provided for @diagnosticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inspect health, events, and runtime logs.'**
  String get diagnosticsSubtitle;

  /// No description provided for @diagnosticsHealthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health summary'**
  String get diagnosticsHealthSummary;

  /// No description provided for @diagnosticsChecksPassing.
  ///
  /// In en, this message translates to:
  /// **'Checks passing'**
  String get diagnosticsChecksPassing;

  /// No description provided for @diagnosticsActiveWarnings.
  ///
  /// In en, this message translates to:
  /// **'Active warnings'**
  String get diagnosticsActiveWarnings;

  /// No description provided for @diagnosticsLastScan.
  ///
  /// In en, this message translates to:
  /// **'Last full scan'**
  String get diagnosticsLastScan;

  /// No description provided for @diagnosticsRecentEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent events'**
  String get diagnosticsRecentEvents;

  /// No description provided for @diagnosticsNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get diagnosticsNoEvents;

  /// No description provided for @diagnosticsLogPreview.
  ///
  /// In en, this message translates to:
  /// **'Log preview'**
  String get diagnosticsLogPreview;

  /// No description provided for @diagnosticsLogPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Most recent entries'**
  String get diagnosticsLogPreviewSubtitle;

  /// No description provided for @diagnosticsSummaryStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get diagnosticsSummaryStopped;

  /// No description provided for @diagnosticsSummaryAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get diagnosticsSummaryAttention;

  /// No description provided for @diagnosticsSummaryHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get diagnosticsSummaryHealthy;

  /// No description provided for @diagnosticsToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String diagnosticsToday(Object time);

  /// No description provided for @diagnosticsDateTime.
  ///
  /// In en, this message translates to:
  /// **'{date} {time}'**
  String diagnosticsDateTime(Object date, Object time);

  /// No description provided for @openAiApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'API key (optional)'**
  String get openAiApiKeyTitle;

  /// No description provided for @openAiApiKeyBody.
  ///
  /// In en, this message translates to:
  /// **'For reliable access to api.openai.com, paste an API key from platform.openai.com/api-keys. Stored encrypted on device only; never logged.'**
  String get openAiApiKeyBody;

  /// No description provided for @openAiApiKeyHasSaved.
  ///
  /// In en, this message translates to:
  /// **'A key is saved. Enter a new one to replace it.'**
  String get openAiApiKeyHasSaved;

  /// No description provided for @openAiApiKeyFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API key'**
  String get openAiApiKeyFieldLabel;

  /// No description provided for @openAiApiKeyFieldHint.
  ///
  /// In en, this message translates to:
  /// **'sk-…'**
  String get openAiApiKeyFieldHint;

  /// No description provided for @openAiApiKeySave.
  ///
  /// In en, this message translates to:
  /// **'Save key'**
  String get openAiApiKeySave;

  /// No description provided for @openAiApiKeyRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get openAiApiKeyRemove;

  /// No description provided for @openAiApiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API key saved on this device.'**
  String get openAiApiKeySaved;

  /// No description provided for @openAiApiKeyRemoved.
  ///
  /// In en, this message translates to:
  /// **'API key removed.'**
  String get openAiApiKeyRemoved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
