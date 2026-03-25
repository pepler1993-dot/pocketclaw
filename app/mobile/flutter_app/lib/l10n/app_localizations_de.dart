// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'PocketClaw';

  @override
  String get loadingApp => 'PocketClaw wird geladen…';

  @override
  String get navChat => 'Chat';

  @override
  String get navRuntime => 'Laufzeit';

  @override
  String get navDiagnostics => 'Diagnose';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get languageSectionTitle => 'Sprache';

  @override
  String get languageSectionSubtitle =>
      'Englisch ist Standard. Deutsch ist optional.';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get languageDescription =>
      'App-Sprache wählen. „Systemstandard“ folgt den Geräteeinstellungen (sonst Englisch).';

  @override
  String get onboardingBadge => 'Android zuerst · lokal wo es zählt';

  @override
  String get onboardingHeadlinePart1 => 'OpenClaw';

  @override
  String get onboardingHeadlinePart2 => '\nin der Tasche.';

  @override
  String get onboardingIntro =>
      'Eine ruhige mobile Oberfläche für OpenClaw: Chat, Laufzeit und Diagnose – ohne Konfigurationsdateien.';

  @override
  String get onboardingYouGet => 'DAS BEKOMMST DU';

  @override
  String get onboardingFeature1Title => 'Dunkle Oberfläche für den Betrieb';

  @override
  String get onboardingFeature1Subtitle => 'Wenig Lärm, klare Infos';

  @override
  String get onboardingFeature2Title => 'Laufzeitstatus auf einen Blick';

  @override
  String get onboardingFeature2Subtitle => 'Status, Aktionen, Checks';

  @override
  String get onboardingFeature3Title => 'Chat mit Assistent';

  @override
  String get onboardingFeature3Subtitle =>
      'Sprache oder Tippen – du entscheidest';

  @override
  String get onboardingFooter =>
      'Als Nächstes: Anbieter wählen – etwa eine Minute.';

  @override
  String get onboardingContinue => 'Verbindung einrichten';

  @override
  String get openAiSignInTitle => 'Mit OpenAI anmelden';

  @override
  String get openAiConnectHeadline => 'OpenAI-Konto verbinden';

  @override
  String get openAiConnectBody =>
      'PocketClaw nutzt OAuth 2.0 mit PKCE (kein Client-Geheimnis in der App). Nach der Anmeldung wählst du ein ChatGPT-Modell.';

  @override
  String get openAiConfigSection => 'Konfiguration';

  @override
  String get openAiConfiguredHint =>
      'OAuth-Endpunkte werden über Build-Flags gesetzt (siehe docs/OPENAI_OAUTH.md).';

  @override
  String get openAiNotConfiguredHint =>
      'OAuth ist nicht konfiguriert. Füge --dart-define Werte für OPENAI_OAUTH_CLIENT_ID, OPENAI_OAUTH_AUTH_URL und OPENAI_OAUTH_TOKEN_URL hinzu oder nutze die Debug-Verknüpfung unten.';

  @override
  String get openAiSignInButton => 'Mit OpenAI anmelden';

  @override
  String get openAiOAuthDisabled => 'OAuth nicht konfiguriert';

  @override
  String get openAiSimulateDebug => 'OAuth simulieren (nur Debug)';

  @override
  String openAiSignInFailed(Object error) {
    return 'Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get modelSelectTitle => 'Modell wählen';

  @override
  String get modelSelectHeadline => 'ChatGPT-Modelle';

  @override
  String get modelSelectBody =>
      'Welches Modell PocketClaw für den Chat nutzt. Später in den Einstellungen änderbar.';

  @override
  String get modelSelectContinue => 'Weiter zu PocketClaw';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSubtitle => 'OpenAI-Konto, Modell und Laufzeit.';

  @override
  String get settingsOpenAiSection => 'OpenAI';

  @override
  String get settingsOpenAiSectionSubtitle =>
      'OAuth (PKCE) plus optionaler API-Schlüssel für den Chat. API-Schlüssel hat Vorrang für api.openai.com.';

  @override
  String get settingsChatModel => 'Chat-Modell';

  @override
  String get settingsRuntimeLocation => 'Laufzeit-Standort';

  @override
  String get settingsWhereRunsTitle => 'Wo OpenClaw läuft';

  @override
  String get settingsRuntimePrefs => 'Laufzeit-Einstellungen';

  @override
  String get settingsAutoStartTitle => 'Laufzeit automatisch starten';

  @override
  String get settingsAutoStartDesc => 'Dienste beim App-Start starten';

  @override
  String get settingsAlertTitle => 'Benachrichtigungsstufe';

  @override
  String get settingsAlertDesc => 'Nur bei Warnungen und Fehlern';

  @override
  String get settingsSyncTitle => 'Sync-Intervall';

  @override
  String get settingsSyncDesc => 'Lokalen Status in festem Rhythmus übertragen';

  @override
  String get settingsDataPrivacy => 'Daten & Daten­schutz';

  @override
  String get settingsDiagUploadTitle => 'Diagnose-Upload';

  @override
  String get settingsDiagUploadDesc =>
      'Anonymisierte Absturz- und Leistungsdaten teilen';

  @override
  String get settingsClearCacheTitle => 'Lokalen Cache leeren';

  @override
  String get settingsClearCacheDesc =>
      'Heruntergeladene Logs und Temp-Snapshots entfernen';

  @override
  String get settingsClearCacheButton => 'Leeren';

  @override
  String get settingsClearCacheNotAvailable =>
      'In dieser Version noch nicht verfügbar.';

  @override
  String get settingsSignOut => 'Bei OpenAI abmelden';

  @override
  String get signOutDialogTitle => 'Abmelden';

  @override
  String get signOutDialogBody =>
      'Du musst dich erneut bei OpenAI anmelden und ein Modell wählen.';

  @override
  String get signOutCancel => 'Abbrechen';

  @override
  String get signOutConfirm => 'Abmelden';

  @override
  String get alertQuiet => 'Ruhig';

  @override
  String get alertModerate => 'Mittel';

  @override
  String get alertVerbose => 'Ausführlich';

  @override
  String get deploymentThisPhone => 'Dieses Telefon';

  @override
  String get deploymentLan => 'Heimnetz (LAN)';

  @override
  String get deploymentCloud => 'OpenClaw Cloud';

  @override
  String get deploymentCustom => 'Eigenes Gateway';

  @override
  String get deploymentThisPhoneDesc =>
      'Gateway zielt auf dieses Gerät (lokal zuerst).';

  @override
  String get deploymentLanDesc =>
      'Gateway läuft auf einem anderen Gerät im WLAN oder LAN.';

  @override
  String get deploymentCloudDesc => 'Gehostete OpenClaw-Laufzeit (remote).';

  @override
  String get deploymentCustomDesc =>
      'Verbindung zu deiner eigenen Gateway-URL.';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatSubtitle =>
      'Fragen zu Setup, Laufzeit oder Diagnose. OpenClaw-Gateway oder OpenAI-API-Schlüssel in den Einstellungen für echte Antworten.';

  @override
  String get chatAssistantSection => 'Assistent';

  @override
  String get chatAssistantSubtitle =>
      'Mit API-Schlüssel: echte Antworten; sonst Offline-ähnliche Antworten.';

  @override
  String get chatAssistantHint =>
      'Probiere „runtime status“, eine Datei anhängen oder das Mikrofon für Spracheingabe.';

  @override
  String get chatMessageHint => 'Nachricht an PocketClaw';

  @override
  String get chatAttachTooltip => 'Datei anhängen';

  @override
  String get chatSpeechTooltip => 'Sprache zu Text';

  @override
  String get chatSpeechStopTooltip => 'Diktat beenden';

  @override
  String get chatSendTooltip => 'Senden';

  @override
  String get chatAuthorYou => 'Du';

  @override
  String get chatAuthorAssistant => 'PocketClaw';

  @override
  String chatWelcomeBody(Object model, Object gateway) {
    return 'Modell/API: $model. Gateway: $gateway. Frage nach Laufzeitstatus, hänge eine Datei an oder nutze das Mikrofon.';
  }

  @override
  String get chatSpeechUnavailable =>
      'Spracherkennung auf diesem Gerät nicht verfügbar.';

  @override
  String chatOpenAiErrorFallback(Object error) {
    return 'OpenAI: $error — Fallback-Antwort.';
  }

  @override
  String get chatStreaming => 'Antwort läuft…';

  @override
  String chatBackendErrorFallback(Object error) {
    return 'Chat-Backend: $error — Offline-Antwort.';
  }

  @override
  String get gatewaySectionTitle => 'OpenClaw-Gateway';

  @override
  String get gatewaySectionSubtitle =>
      'Chat über die OpenAI-kompatible HTTP-API deines Gateways (z. B. Port 18789). Wenn aktiv und konfiguriert, hat das Vorrang vor direktem OpenAI.';

  @override
  String get gatewayUseForChat => 'Gateway für Chat nutzen';

  @override
  String get gatewayUseForChatDesc =>
      'Benötigt Basis-URL und Operator-Token. Hat Vorrang vor OpenAI-API-Key / OAuth im Chat.';

  @override
  String get gatewayBaseUrlLabel => 'Gateway-Basis-URL';

  @override
  String get gatewayBaseUrlHint => 'http://192.168.1.10:18789';

  @override
  String get gatewayTokenLabel => 'Operator-Token';

  @override
  String get gatewayTokenHintSaved =>
      'Token ist auf dem Gerät gespeichert. Neuen Wert eintragen zum Ersetzen.';

  @override
  String get gatewayTokenHintEmpty =>
      'Gateway-Auth-Token einfügen (siehe Gateway-Doku).';

  @override
  String get gatewaySave => 'Gateway-Einstellungen speichern';

  @override
  String get gatewayTest => 'Verbindung testen';

  @override
  String gatewayTestSuccess(Object count) {
    return 'Gateway OK — $count Modell(e) gemeldet.';
  }

  @override
  String gatewayTestFail(Object detail) {
    return 'Verbindung fehlgeschlagen: $detail';
  }

  @override
  String get gatewaySaved => 'Gateway-Einstellungen gespeichert.';

  @override
  String get gatewayErrNoUrl => 'Zuerst eine Gateway-Basis-URL eintragen.';

  @override
  String get gatewayErrNoToken =>
      'Zuerst ein Operator-Token eintragen oder speichern.';

  @override
  String get gatewayWsTest => 'WebSocket testen (hello-ok)';

  @override
  String gatewayWsSuccess(Object protocol, Object server) {
    return 'WebSocket hello-ok — Protokoll $protocol, Server $server.';
  }

  @override
  String gatewayWsFail(Object error) {
    return 'WebSocket: $error';
  }

  @override
  String get chatNoMessagePlaceholder => '(keine Nachricht)';

  @override
  String get chatMockSayEmpty => 'Schreib etwas oder hänge eine Datei an.';

  @override
  String get chatMockSayText => 'Schreib etwas, um zu starten.';

  @override
  String chatMockAttachmentIntro(Object name) {
    return 'Anhang „$name“ erhalten (Mock: nicht hochgeladen). ';
  }

  @override
  String get chatMockAttachmentAddContext =>
      'Füge eine Nachricht hinzu, wenn du Kontext brauchst.';

  @override
  String chatMockRuntimeReply(Object gateway, Object model, Object lifecycle,
      Object heartbeat, Object depth) {
    return 'Gateway: $gateway. Modell/API: $model. Laufzeit ist $lifecycle. $heartbeat Warteschlange: $depth.';
  }

  @override
  String chatMockDiagReply(Object count) {
    return 'Diagnose enthält $count aktuelle Ereignisse. Tab „Diagnose“ für Details.';
  }

  @override
  String get chatMockHello => 'Hi. Frag nach Laufzeitstatus oder Diagnose.';

  @override
  String get chatMockDefault =>
      'Verstanden. Probiere: „runtime status“ oder „show diagnostics“.';

  @override
  String get lifecycleStoppedWord => 'gestoppt';

  @override
  String get lifecycleStartingWord => 'startet';

  @override
  String get lifecycleRunningWord => 'läuft';

  @override
  String get lifecycleDegradedWord => 'eingeschränkt';

  @override
  String get lifecycleErrorWord => 'Fehler';

  @override
  String get runtimeTitle => 'Laufzeit';

  @override
  String get runtimeSubtitle =>
      'Hintergrundaktivität steuern und Status prüfen.';

  @override
  String get runtimeStatusSection => 'Laufzeitstatus';

  @override
  String get runtimeQuickActions => 'Schnellaktionen';

  @override
  String get runtimeStart => 'Laufzeit starten';

  @override
  String get runtimeRestart => 'Laufzeit neu starten';

  @override
  String get runtimeHealthCheck => 'Health-Check';

  @override
  String get runtimeHealthChecking => 'Prüfe…';

  @override
  String get runtimeQueuePause => 'Warteschlange pausieren';

  @override
  String get runtimeQueueResume => 'Warteschlange fortsetzen';

  @override
  String get runtimeStop => 'Laufzeit stoppen';

  @override
  String get runtimeHealthChecks => 'Health-Checks';

  @override
  String get runtimeNoChecksStopped =>
      'Keine Checks, solange die Laufzeit gestoppt ist.';

  @override
  String runtimeModeLine(Object mode) {
    return 'Modus: $mode';
  }

  @override
  String runtimeQueueLine(Object depth) {
    return 'Warteschlange: $depth ausstehend';
  }

  @override
  String get runtimeDotStopped => 'Gestoppt';

  @override
  String get runtimeDotStarting => 'Startet';

  @override
  String get runtimeDotHealthy => 'Healthy';

  @override
  String get runtimeDotAttention => 'Hinweis';

  @override
  String get runtimeDotError => 'Fehler';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get diagnosticsSubtitle => 'Health, Ereignisse und Laufzeit-Logs.';

  @override
  String get diagnosticsHealthSummary => 'Health-Übersicht';

  @override
  String get diagnosticsChecksPassing => 'Bestandene Checks';

  @override
  String get diagnosticsActiveWarnings => 'Aktive Warnungen';

  @override
  String get diagnosticsLastScan => 'Letzter Scan';

  @override
  String get diagnosticsRecentEvents => 'Letzte Ereignisse';

  @override
  String get diagnosticsNoEvents => 'Noch keine Ereignisse.';

  @override
  String get diagnosticsLogPreview => 'Log-Vorschau';

  @override
  String get diagnosticsLogPreviewSubtitle => 'Neueste Einträge';

  @override
  String get diagnosticsSummaryStopped => 'Gestoppt';

  @override
  String get diagnosticsSummaryAttention => 'Hinweis';

  @override
  String get diagnosticsSummaryHealthy => 'Healthy';

  @override
  String diagnosticsToday(Object time) {
    return 'Heute, $time';
  }

  @override
  String diagnosticsDateTime(Object date, Object time) {
    return '$date $time';
  }

  @override
  String get openAiApiKeyTitle => 'API-Schlüssel (optional)';

  @override
  String get openAiApiKeyBody =>
      'Für zuverlässigen Zugriff auf api.openai.com einen API-Schlüssel von platform.openai.com/api-keys einfügen. Nur verschlüsselt auf dem Gerät; nie geloggt.';

  @override
  String get openAiApiKeyHasSaved =>
      'Ein Schlüssel ist gespeichert. Neuen eingeben zum Ersetzen.';

  @override
  String get openAiApiKeyFieldLabel => 'OpenAI API-Schlüssel';

  @override
  String get openAiApiKeyFieldHint => 'sk-…';

  @override
  String get openAiApiKeySave => 'Speichern';

  @override
  String get openAiApiKeyRemove => 'Entfernen';

  @override
  String get openAiApiKeySaved => 'API-Schlüssel auf diesem Gerät gespeichert.';

  @override
  String get openAiApiKeyRemoved => 'API-Schlüssel entfernt.';
}
