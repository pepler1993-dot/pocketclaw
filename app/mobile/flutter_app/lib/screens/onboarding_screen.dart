import 'package:flutter/material.dart';
import 'package:pocketclaw_flutter_app/l10n/app_localizations.dart';

import '../widgets/product_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  colors.surface,
                  Color.lerp(colors.surface, const Color(0xFF0E0E0E), 0.85)!,
                ],
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: _GlowOrb(diameter: 280, color: colors.primary.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: 80,
            left: -100,
            child: _GlowOrb(diameter: 220, color: colors.secondary.withValues(alpha: 0.06)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const ClawBrandMark(size: 52),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.outline.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              l10n.onboardingBadge,
                              style: textTheme.labelSmall?.copyWith(
                                letterSpacing: 0.4,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Text.rich(
                            TextSpan(
                              style: textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                                letterSpacing: -0.5,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'OpenClaw',
                                  style: TextStyle(color: colors.primary),
                                ),
                                TextSpan(
                                  text: '\nin your pocket.',
                                  style: TextStyle(color: colors.onSurface),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.onboardingIntro,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            l10n.onboardingYouGet,
                            style: textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  colors.primary.withValues(alpha: 0.22),
                                  colors.outline.withValues(alpha: 0.25),
                                ],
                              ),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(color: colors.outline.withValues(alpha: 0.4)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
                                child: Column(
                                  children: <Widget>[
                                    _FeatureRow(
                                      icon: Icons.layers_outlined,
                                      title: 'Operational dark UI',
                                      subtitle: 'Low noise, high signal',
                                    ),
                                    SizedBox(height: 16),
                                    _FeatureRow(
                                      icon: Icons.monitor_heart_outlined,
                                      title: 'Runtime health at a glance',
                                      subtitle: 'Status, actions, checks',
                                    ),
                                    SizedBox(height: 16),
                                    _FeatureRow(
                                      icon: Icons.forum_outlined,
                                      title: 'Assistant-ready chat',
                                      subtitle: 'Voice or type — your choice',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    l10n.onboardingFooter,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onContinue,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 22),
                    label: Text(
                      l10n.onboardingContinue,
                      style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, color: colors.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
