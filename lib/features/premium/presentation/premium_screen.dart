import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/premium/domain/premium_status.dart';
import 'package:dogmatch_ai/features/premium/presentation/premium_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium-Upgrade-Seite. Zeigt aktuellen Status, Feature-Liste und einen
/// Demo-Aktivierungs-Button (kein echter Zahlungs-Anbieter angebunden).
class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  static const List<_Feature> _features = [
    _Feature(
      icon: Icons.all_inclusive_rounded,
      title: 'Unbegrenzte KI-Beratung',
      description:
          'Kein Tageslimit mehr - frag den KI-Berater so oft du willst.',
    ),
    _Feature(
      icon: Icons.fitness_center_rounded,
      title: 'Alle Trainingsplaene',
      description:
          'Komplette Schritt-fuer-Schritt-Anleitungen inklusive Fortschritts-Tracking.',
    ),
    _Feature(
      icon: Icons.image_rounded,
      title: 'Bilder im Chat',
      description:
          'Schick dem KI-Berater Fotos deines Hundes fuer praezise Antworten.',
    ),
    _Feature(
      icon: Icons.cloud_sync_rounded,
      title: 'Mehrfach-Hunde-Sync',
      description:
          'Halte mehrere Hunde-Profile geraetuebergreifend synchron.',
    ),
    _Feature(
      icon: Icons.support_agent_rounded,
      title: 'Priorisierter Support',
      description:
          'Antwort innerhalb von 24 Stunden statt 3-5 Werktagen.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusAsync = ref.watch(premiumStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DogMatch Premium')),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (status) => _Body(status: status, theme: theme, ref: ref),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.status, required this.theme, required this.ref});

  final PremiumStatus status;
  final ThemeData theme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _StatusCard(status: status, theme: theme),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Das bekommst du mit Premium',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        ...PremiumScreen._features.map(
          (f) => _FeatureTile(feature: f, theme: theme),
        ),
        const SizedBox(height: AppSpacing.xl),
        _ActionButtons(status: status, ref: ref),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Hinweis: Diese Phase aktiviert Premium nur lokal auf diesem '
          'Geraet - es wird (noch) kein Zahlungs-Anbieter angesprochen.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.theme});

  final PremiumStatus status;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isPremium = status.isPremium;
    final color = isPremium ? Colors.amber.shade700 : theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            isPremium
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            size: 48,
            color: color,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPremium ? 'Premium aktiv' : 'Free-Stufe',
                  style: theme.textTheme.titleLarge?.copyWith(color: color),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isPremium
                      ? 'Alle Funktionen freigeschaltet.'
                      : 'Du nutzt aktuell die kostenlose Stufe mit '
                          '${AppConstants.freeAiMessageLimit} KI-Nachrichten '
                          'pro Session.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature, required this.theme});

  final _Feature feature;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(feature.icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  feature.description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.status, required this.ref});

  final PremiumStatus status;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (status.isPremium) {
      return OutlinedButton.icon(
        onPressed: () =>
            ref.read(premiumStatusProvider.notifier).deactivate(),
        icon: const Icon(Icons.cancel_outlined),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text('Premium deaktivieren (Demo)'),
        ),
      );
    }
    return FilledButton.icon(
      onPressed: () => ref.read(premiumStatusProvider.notifier).activate(),
      icon: const Icon(Icons.workspace_premium_rounded),
      label: const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text('Premium aktivieren (Demo)'),
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
