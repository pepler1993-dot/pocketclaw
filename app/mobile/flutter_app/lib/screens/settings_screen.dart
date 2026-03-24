import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../models/app_locale_preference.dart';
import '../models/openai_chat_model_option.dart';
import '../models/runtime_deployment_model.dart';
import '../services/runtime_client.dart';
import '../widgets/openai_api_key_section.dart';
import '../widgets/product_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
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
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: session,
      builder: (BuildContext context, Widget? child) {
        final List<String> deploymentLabels = <String>[
          RuntimeDeploymentModel.labelThisPhone,
          RuntimeDeploymentModel.labelHomeNetworkLan,
          RuntimeDeploymentModel.labelOpenClawCloud,
          RuntimeDeploymentModel.labelCustomGateway,
        ];
        final String rawModelId = session.providerConfig.modelProfileLabel;
        final bool knownModel = OpenAiChatModelOption.defaults.any(
          (OpenAiChatModelOption m) => m.id == rawModelId,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: <Widget>[
            ScreenHeader(
              title: l10n.settingsTitle,
              subtitle: l10n.settingsSubtitle,
              trailing: const Icon(Icons.settings_outlined),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.languageSectionTitle,
              subtitle: l10n.languageSectionSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.languageDescription, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<AppLocalePreference>(
                    key: ValueKey<String>('locale_${localePreference.storageValue}'),
                    initialValue: localePreference,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: <DropdownMenuItem<AppLocalePreference>>[
                      DropdownMenuItem<AppLocalePreference>(
                        value: AppLocalePreference.english,
                        child: Text(l10n.languageEnglish),
                      ),
                      DropdownMenuItem<AppLocalePreference>(
                        value: AppLocalePreference.german,
                        child: Text(l10n.languageGerman),
                      ),
                      DropdownMenuItem<AppLocalePreference>(
                        value: AppLocalePreference.system,
                        child: Text(l10n.languageSystem),
                      ),
                    ],
                    onChanged: (AppLocalePreference? value) {
                      if (value != null) {
                        onLocaleChanged(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.settingsOpenAiSection,
              subtitle: l10n.settingsOpenAiSectionSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.settingsChatModel, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    key: ValueKey<String>('chat_model_$rawModelId'),
                    initialValue: rawModelId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: <DropdownMenuItem<String>>[
                      ...OpenAiChatModelOption.defaults.map(
                        (OpenAiChatModelOption m) => DropdownMenuItem<String>(
                          value: m.id,
                          child: Text(m.label),
                        ),
                      ),
                      if (!knownModel)
                        DropdownMenuItem<String>(
                          value: rawModelId,
                          child: Text(rawModelId),
                        ),
                    ],
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      session.setOpenAiChatModel(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const OpenAiApiKeySection(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final bool? ok = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(l10n.signOutDialogTitle),
                              content: Text(l10n.signOutDialogBody),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(l10n.signOutCancel),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(l10n.signOutConfirm),
                                ),
                              ],
                            );
                          },
                        );
                        if (ok == true && context.mounted) {
                          await onSignOut();
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.settingsSignOut),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.settingsRuntimeLocation,
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.smartphone_outlined,
                    title: l10n.settingsWhereRunsTitle,
                    description: _deploymentDescriptionFor(l10n, session.deployment),
                    trailing: DropdownButton<String>(
                      value: session.deployment.displayLabel,
                      underline: const SizedBox.shrink(),
                      items: deploymentLabels
                          .map(
                            (String label) => DropdownMenuItem<String>(
                              value: label,
                              child: Text(_deploymentMenuLabel(l10n, label)),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setDeployment(
                          RuntimeDeploymentModel.fromSelectionLabel(value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.settingsRuntimePrefs,
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.bolt_outlined,
                    title: l10n.settingsAutoStartTitle,
                    description: l10n.settingsAutoStartDesc,
                    trailing: Switch(
                      value: session.autoStartRuntime,
                      onChanged: (bool value) {
                        session.setAutoStart(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.notifications_outlined,
                    title: l10n.settingsAlertTitle,
                    description: l10n.settingsAlertDesc,
                    trailing: DropdownButton<String>(
                      value: session.alertLevel,
                      underline: const SizedBox.shrink(),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'Quiet',
                          child: Text(l10n.alertQuiet),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Moderate',
                          child: Text(l10n.alertModerate),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Verbose',
                          child: Text(l10n.alertVerbose),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setAlertLevel(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.wifi_tethering_outlined,
                    title: l10n.settingsSyncTitle,
                    description: l10n.settingsSyncDesc,
                    trailing: DropdownButton<String>(
                      value: session.syncFrequencyLabel,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(value: '15s', child: Text('15s')),
                        DropdownMenuItem<String>(value: '30s', child: Text('30s')),
                        DropdownMenuItem<String>(value: '60s', child: Text('60s')),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        session.setSyncFrequencyLabel(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.settingsDataPrivacy,
              child: Column(
                children: <Widget>[
                  _SettingRow(
                    icon: Icons.analytics_outlined,
                    title: l10n.settingsDiagUploadTitle,
                    description: l10n.settingsDiagUploadDesc,
                    trailing: Switch(
                      value: session.diagnosticsUploadEnabled,
                      onChanged: (bool value) {
                        session.setDiagnosticsUpload(value);
                      },
                    ),
                  ),
                  const Divider(height: 20),
                  _SettingRow(
                    icon: Icons.delete_outline,
                    title: l10n.settingsClearCacheTitle,
                    description: l10n.settingsClearCacheDesc,
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsClearCacheNotAvailable)),
                        );
                      },
                      child: Text(l10n.settingsClearCacheButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

String _deploymentMenuLabel(AppLocalizations l10n, String englishValue) {
  switch (englishValue) {
    case RuntimeDeploymentModel.labelThisPhone:
      return l10n.deploymentThisPhone;
    case RuntimeDeploymentModel.labelHomeNetworkLan:
      return l10n.deploymentLan;
    case RuntimeDeploymentModel.labelOpenClawCloud:
      return l10n.deploymentCloud;
    case RuntimeDeploymentModel.labelCustomGateway:
      return l10n.deploymentCustom;
    default:
      return englishValue;
  }
}

String _deploymentDescriptionFor(AppLocalizations l10n, RuntimeDeploymentModel d) {
  switch (d.kind) {
    case RuntimeDeploymentKind.thisPhone:
      return l10n.deploymentThisPhoneDesc;
    case RuntimeDeploymentKind.homeNetworkLan:
      return l10n.deploymentLanDesc;
    case RuntimeDeploymentKind.openClawCloud:
      return l10n.deploymentCloudDesc;
    case RuntimeDeploymentKind.customGateway:
      return l10n.deploymentCustomDesc;
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.description,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
