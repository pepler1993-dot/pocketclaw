import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../config/openai_oauth_config.dart';
import '../flow/app_flow_controller.dart';
import '../services/openai_oauth_service.dart';
import '../widgets/product_widgets.dart';

class OpenAiLoginScreen extends StatefulWidget {
  const OpenAiLoginScreen({
    super.key,
    required this.flow,
  });

  final AppFlowController flow;

  @override
  State<OpenAiLoginScreen> createState() => _OpenAiLoginScreenState();
}

class _OpenAiLoginScreenState extends State<OpenAiLoginScreen> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await OpenAiOAuthService.signInWithPkce();
      if (!mounted) {
        return;
      }
      widget.flow.oauthSucceededGoToModelSelection();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.openAiSignInFailed(e.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _signInSimulated() async {
    assert(kDebugMode);
    setState(() => _busy = true);
    try {
      await OpenAiOAuthService.signInSimulatedForDebug();
      if (!mounted) {
        return;
      }
      widget.flow.oauthSucceededGoToModelSelection();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final bool configured = OpenAiOAuthConfig.isConfigured;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.openAiSignInTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          const ClawBrandMark(showLabel: false),
          const SizedBox(height: 16),
          Text(
            'Connect your OpenAI account',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'PocketClaw uses OAuth 2.0 with PKCE (no client secret in the app). '
            'After you sign in, you will choose a ChatGPT model for chat.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Configuration',
            child: Text(
              configured
                  ? 'OAuth endpoints are set via build flags (see docs/OPENAI_OAUTH.md).'
                  : 'OAuth is not configured. Add --dart-define values for OPENAI_OAUTH_CLIENT_ID, '
                      'OPENAI_OAUTH_AUTH_URL, and OPENAI_OAUTH_TOKEN_URL, or use the debug shortcut below.',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy || !configured ? null : _signIn,
              icon: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: Text(configured ? l10n.openAiSignInButton : l10n.openAiOAuthDisabled),
            ),
          ),
          if (kDebugMode) ...<Widget>[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _busy ? null : _signInSimulated,
                child: Text(l10n.openAiSimulateDebug),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
