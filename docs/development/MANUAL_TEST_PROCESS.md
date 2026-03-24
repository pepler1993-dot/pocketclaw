# PocketClaw Flutter — manueller Testprozess

Dieses Dokument ist die **festgelegte Reihenfolge**, um die aktuelle App **funktionsweise abzudecken** (manuell auf Gerät oder Emulator). Assistenten können es bei „alles testen“ oder QA **Schritt für Schritt abarbeiten**; Ergebnisse werden mit **Pass / Fail / N/A** notiert.

**Code-Pfad:** `app/mobile/flutter_app/`

---

## 0. Automatische Vorprüfung (jedes Mal)

Im Projektordner `app/mobile/flutter_app`:

| Schritt | Befehl | Erwartung |
|--------|--------|-----------|
| A0.1 | `flutter pub get` | Ohne Fehler |
| A0.2 | `flutter analyze` | Keine Errors (Infos/Warnungen dokumentieren) |
| A0.3 | `flutter test` | Alle Tests grün |

Wenn A0.2/A0.3 fehlschlagen: zuerst beheben, dann manuelle Phasen starten.

---

## 1. Vorbereitung manueller Lauf

| Schritt | Aktion |
|--------|--------|
| M1.1 | App auf **Android** starten (Emulator oder echtes Gerät), Debug-Build. |
| M1.2 | Optional **frischer Erstkauf**: App-Daten löschen / App deinstallieren, damit Onboarding wieder erscheint. Sonst: Flow aus Abschnitt 3 überspringen, wo schon „bereits eingeloggt“. |

**Regel für Assistenten (Cursor, Automatisierung):** PocketClaw ist **Android-first**. Wenn der Nutzer die App starten oder manuell testen soll, **immer zuerst** ein Android-Ziel wählen: `flutter devices` aus `app/mobile/flutter_app`; bei Eintrag für Emulator oder physisches Gerät `flutter run -d <id>` (oder `flutter run`, wenn nur dieses Ziel sichtbar). **`flutter run -d windows`** (oder Web) **nur**, wenn **kein** Android-Gerät/-Emulator in der Geräteliste erscheint **oder** der Nutzer ausdrücklich Desktop/Web verlangt. Wenn die Liste leer wirkt, aber der Nutzer ein verbundenes Gerät meldet: Android SDK/`adb` im PATH und USB-Debugging prüfen lassen — nicht still auf Desktop ausweichen.

---

## 2. Navigations-Grundlage (Haupt-Shell)

Nach erfolgreichem Setup (Shell mit **unterer Navigation**):

| ID | Prüfpunkt | Erwartung |
|----|-----------|-----------|
| N2.1 | Vier Tabs sichtbar | Chat, Runtime, Diagnostics, Settings |
| N2.2 | Tab-Wechsel | Jeder Tab lädt ohne Crash; Titel passen |

---

## 3. Erststart: Onboarding → OpenAI → Modell

Nur wenn `pc_onboarding_done` noch nicht gesetzt / App frisch.

| ID | Aktion | Erwartung |
|----|--------|-----------|
| O3.1 | Onboarding lesen, „OpenClaw“ / Branding sichtbar | Inhalt scrollt, kein Layoutbruch |
| O3.2 | **Connection setup** tippen | Wechsel zu **Sign in with OpenAI** |
| L3.3 | **Sign in with OpenAI** | Nur aktiv, wenn OAuth per `--dart-define` konfiguriert; sonst Button gedimmt, Hinweis in „Configuration“ |
| L3.4 | **Simulate OAuth (debug only)** (nur Debug-Build) | Wechsel zu **Choose a model** ohne Browser |
| L3.5 | Echtes OAuth (falls konfiguriert) | Nach erfolgreichem Login → Modellauswahl |
| M3.6 | Modell per **Radio** wählen | Auswahl bleibt markiert |
| M3.7 | **Continue to PocketClaw** | Haupt-Shell (vier Tabs), kein Rücksprung zu Login |

---

## 4. Chat

Tab **Chat**.

| ID | Aktion | Erwartung |
|----|--------|-----------|
| C4.1 | Erste Assistant-Nachricht | Enthält Model/API- und Gateway-Kurztext (Deployment-Label) |
| C4.2 | Text senden: `runtime status` | Antwort mit Runtime-/Gateway-Bezug (Mock oder API je nach Key/OAuth) |
| C4.3 | Text senden: `show diagnostics` / `diag` | Antwort verweist auf Diagnostics / Event-Anzahl (Mock-Verhalten) |
| C4.4 | **Anhang** wählen (Datei-Picker) | Nachricht mit Anhang; Assistant reagiert (Mock-Text zu Anhang) |
| C4.5 | **Mikrofon** (falls sichtbar/OS erlaubt) | Spracheingabe startet/stoppt ohne Crash; bei Fehler Snackbar (nicht stiller Absturz) |
| C4.6 | Leere Eingabe senden | Sinnvolle Hinweis-Antwort oder kein harter Crash |

*Hinweis:* Echte **OpenAI Chat Completions** nur mit gültigem **API-Key** in Settings und/oder nutzbarem OAuth-Token; sonst Mock- oder Fallback-Antworten laut `OpenAiChatService`.

---

## 5. Runtime

Tab **Runtime**.

| ID | Aktion | Erwartung |
|----|--------|-----------|
| R5.1 | Status-Anzeige | Lifecycle (z. B. Healthy / Stopped) und Untertitel aktualisieren sich |
| R5.2 | **Runtime starten** (falls gestoppt) | Übergang Starting → Running, Heartbeat-Text plausibel |
| R5.3 | **Stop** | Stopped, keine Exceptions |
| R5.4 | **Restart** | Stop + Start durchläuft |
| R5.5 | **Run health check** | Läuft durch, ggf. „Checking…“, danach Zeitstempel / Events |
| R5.6 | **Pause / Resume queue** | Toggle wirkt; UI aktualisiert |

---

## 6. Diagnostics

Tab **Diagnostics**.

| ID | Prüfpunkt | Erwartung |
|----|-----------|-----------|
| D6.1 | Events-Liste | Einträge mit Zeit/Level/Text |
| D6.2 | Log-Vorschau | Text sichtbar, scrollt falls lang |
| D6.3 | Letzter Health-Check | Zeile konsistent mit Runtime-Tab nach Health-Check |

---

## 7. Settings

Tab **Settings**.

| ID | Aktion | Erwartung |
|----|--------|-----------|
| S7.1 | **Chat model** Dropdown | Änderung setzt Modell; Chat-Header/Provider-Label passt nach Wechsel (ggf. Tab wechseln) |
| S7.1b | **Language** | Standard **English** (auch ohne gespeicherte Einstellung); optional **Deutsch**; **Systemstandard** nutzt die Gerätesprache mit Fallback auf Englisch. Änderung wirkt sofort; Einstellung bleibt nach App-Neustart erhalten. |
| S7.2 | **API key (optional)** | Speichern → Snackbar „saved“; **Remove** → Key entfernt, Snackbar |
| S7.3 | **Runtime location** | Jede Option wählbar; Runtime-Tab zeigt passendes Deployment-Label |
| S7.4 | **Auto-start**, **Alert level**, **Sync frequency**, **Diagnostics upload** | Werte ändern, App stürzt nicht ab; bei erneutem Start persistiert (Spot-Check) |
| S7.5 | **Sign out** → Dialog **Abbrechen** | Bleibt in Shell |
| S7.6 | **Sign out** → bestätigen | Zurück zu OpenAI-Login/Flow; Tokens/Setup gemäß Implementierung geleert |

---

## 8. Sign-out und Wiedereinstieg

| ID | Aktion | Erwartung |
|----|--------|-----------|
| E8.1 | Nach Sign-out erneut **Simulate OAuth** oder echtes Login | Wieder Modellauswahl → Shell |
| E8.2 | App komplett schließen und öffnen | Zustand entspricht gespeicherten Prefs (Onboarding nicht erneut, wenn schon erledigt) |

---

## 9. Weitere Plattformen (optional)

| ID | Kontext | Kurzprüfung |
|----|---------|-------------|
| P9.1 | `flutter run -d windows` | Startet, UI bedienbar |
| P9.2 | `flutter run -d chrome` | Startet (Web-Einschränkungen beachten) |

---

## 10. Bericht (für Agent oder Mensch)

Nach Durchlauf festhalten:

- **Build:** Datum, Commit/Branch, `flutter --version`
- **Gerät:** Emulator-Name/API oder Gerätemodell
- **Tabelle:** Pro ID aus den Abschnitten 2–8 **Pass / Fail / N/A** + eine Zeile Notiz bei Fail (inkl. **S7.1b Language**, falls getestet)
- **Analyzer/Test:** Ausgabe von `flutter analyze` / `flutter test` angehängt oder zusammengefasst

---

## Kurz: Reihenfolge für den Assistenten

1. Abschnitt **0** ausführen (Shell-Befehle).
2. Nutzer bitten, **M1** zu bestätigen (App läuft), oder App gemäß Projektregeln starten — **Android zuerst** (siehe Hinweis unter §1 M1.2).
3. Checklisten **2 → 3** (falls Erststart) **→ 4 → 5 → 6 → 7 → 8** in dieser Reihenfolge abarbeiten.
4. Abschnitt **10** ausfüllen oder dem Nutzer als Vorlage geben.

Bei gezieltem Test („nur Chat“) nur die passenden IDs ausführen, aber **0** nicht überspringen, wenn sich Code geändert hat.
