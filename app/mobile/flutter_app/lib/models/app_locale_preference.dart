import 'package:flutter/material.dart';

/// Stored under [AppPrefs]. Default is English; optional German or system locale.
enum AppLocalePreference {
  english,
  german,
  system,
}

extension AppLocalePreferenceStorage on AppLocalePreference {
  /// Value written to SharedPreferences.
  String get storageValue => switch (this) {
        AppLocalePreference.english => 'en',
        AppLocalePreference.german => 'de',
        AppLocalePreference.system => 'system',
      };

  /// `null` means let the device locale apply (with fallback to English).
  Locale? resolveLocale() => switch (this) {
        AppLocalePreference.english => const Locale('en'),
        AppLocalePreference.german => const Locale('de'),
        AppLocalePreference.system => null,
      };
}

AppLocalePreference appLocalePreferenceFromStorage(String? raw) {
  switch (raw) {
    case 'de':
      return AppLocalePreference.german;
    case 'system':
      return AppLocalePreference.system;
    case 'en':
    default:
      return AppLocalePreference.english;
  }
}
