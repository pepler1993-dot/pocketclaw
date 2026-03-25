import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../persistence/app_prefs.dart';
import '../persistence/gateway_token_store.dart';
import '../services/openclaw_gateway_chat_service.dart';
import '../services/openclaw_gateway_util.dart';
import '../services/openclaw_gateway_ws_client.dart';
import 'product_widgets.dart';

/// Settings block: OpenClaw Gateway HTTP (URL + token + probe).
class GatewaySettingsSection extends StatefulWidget {
  const GatewaySettingsSection({super.key});

  @override
  State<GatewaySettingsSection> createState() => _GatewaySettingsSectionState();
}

class _GatewaySettingsSectionState extends State<GatewaySettingsSection> {
  final TextEditingController _url = TextEditingController();
  final TextEditingController _token = TextEditingController();

  bool _loading = true;
  bool _useGateway = false;
  bool _hasSavedToken = false;
  bool _saving = false;
  bool _testingHttp = false;
  bool _testingWs = false;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final AppPrefsSnapshot snap = await AppPrefs.load();
    final bool hasTok = await GatewayTokenStore.hasToken();
    if (!mounted) {
      return;
    }
    setState(() {
      _useGateway = snap.useGatewayForChat;
      _url.text = snap.gatewayBaseUrl;
      _hasSavedToken = hasTok;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    final String normalized = normalizeOpenClawGatewayBaseUrl(_url.text);
    setState(() => _saving = true);
    try {
      await AppPrefs.saveGatewayPrefs(
        useGatewayForChat: _useGateway,
        gatewayBaseUrl: normalized,
      );
      final String newTok = _token.text.trim();
      if (newTok.isNotEmpty) {
        await GatewayTokenStore.writeToken(newTok);
        _token.clear();
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _hasSavedToken = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.gatewaySaved)),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _test(AppLocalizations l10n) async {
    final String normalized = normalizeOpenClawGatewayBaseUrl(_url.text);
    if (normalized.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.gatewayErrNoUrl)),
      );
      return;
    }
    String token = _token.text.trim();
    if (token.isEmpty) {
      token = (await GatewayTokenStore.readToken())?.trim() ?? '';
    }
    if (!mounted) {
      return;
    }
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.gatewayErrNoToken)),
      );
      return;
    }

    setState(() => _testingHttp = true);
    try {
      final GatewayProbeResult r = await OpenClawGatewayChatService.probe(
        normalizedBaseUrl: normalized,
        bearerToken: token,
      );
      if (!mounted) {
        return;
      }
      if (r.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.gatewayTestSuccess(r.modelCount ?? 0))),
        );
      } else {
        final String detail = r.detail ?? '${r.statusCode ?? '?'}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.gatewayTestFail(detail))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _testingHttp = false);
      }
    }
  }

  Future<void> _testWebSocket(AppLocalizations l10n) async {
    final String normalized = normalizeOpenClawGatewayBaseUrl(_url.text);
    if (normalized.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.gatewayErrNoUrl)),
      );
      return;
    }
    String token = _token.text.trim();
    if (token.isEmpty) {
      token = (await GatewayTokenStore.readToken())?.trim() ?? '';
    }
    if (!mounted) {
      return;
    }
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.gatewayErrNoToken)),
      );
      return;
    }

    setState(() => _testingWs = true);
    try {
      final GatewayWsHandshakeResult r = await OpenClawGatewayWsClient.handshakeOnce(
        normalizedHttpBase: normalized,
        gatewayToken: token,
      );
      if (!mounted) {
        return;
      }
      if (r.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.gatewayWsSuccess(
                '${r.protocol ?? '?'}',
                r.serverVersion ?? '-',
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.gatewayWsFail(r.errorMessage ?? 'unknown'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _testingWs = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SectionCard(
      title: l10n.gatewaySectionTitle,
      subtitle: l10n.gatewaySectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.gatewayUseForChat),
            subtitle: Text(
              l10n.gatewayUseForChatDesc,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _useGateway,
            onChanged: (bool v) => setState(() => _useGateway = v),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _url,
            decoration: InputDecoration(
              labelText: l10n.gatewayBaseUrlLabel,
              hintText: l10n.gatewayBaseUrlHint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _token,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.gatewayTokenLabel,
              hintText: _hasSavedToken
                  ? l10n.gatewayTokenHintSaved
                  : l10n.gatewayTokenHintEmpty,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            autocorrect: false,
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: (_saving || _testingHttp || _testingWs) ? null : () => _save(l10n),
                  icon: const Icon(Icons.save_outlined, size: 20),
                  label: Text(l10n.gatewaySave),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (_saving || _testingHttp || _testingWs) ? null : () => _test(l10n),
                  icon: _testingHttp
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_tethering, size: 20),
                  label: Text(l10n.gatewayTest),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: (_saving || _testingHttp || _testingWs) ? null : () => _testWebSocket(l10n),
              icon: _testingWs
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.hub_outlined, size: 20),
              label: Text(l10n.gatewayWsTest),
            ),
          ),
        ],
      ),
    );
  }
}
