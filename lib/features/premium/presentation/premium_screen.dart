import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/premium/domain/premium_status.dart';
import 'package:dogmatch_ai/features/premium/presentation/premium_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium-Upgrade-Seite mit 3-stufiger Preis-Auswahl. Zeigt Status,
/// Feature-Liste und die Tarife. Die Auswahl ist visuell; aktiviert wird
/// Premium aktuell nur lokal (Demo, kein Zahlungs-Anbieter angebunden).
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
      icon: Icons.image_rounded,
      title: 'Foto-Erkennung im Chat',
      description:
          'Schick dem KI-Berater Fotos deines Hundes fuer praezise Antworten.',
    ),
    _Feature(
      icon: Icons.fitness_center_rounded,
      title: 'Alle Trainingsplaene & Rezepte',
      description:
          'Komplette Schritt-fuer-Schritt-Anleitungen inklusive Fortschritt.',
    ),
    _Feature(
      icon: Icons.cloud_sync_rounded,
      title: 'Unbegrenzt Hunde & Dokumente',
      description:
          'Mehrere Hunde-Profile, Akte und Befunde geraetuebergreifend synchron.',
    ),
    _Feature(
      icon: Icons.block_rounded,
      title: 'Komplett werbefrei',
      description: 'Keine Werbung, voller Fokus auf dich und deinen Hund.',
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
        data: (status) => _Body(status: status, theme: theme),
      ),
    );
  }
}

/// Tarif-Definition. `monthlyEquivalent` wird unter dem Jahres-Tarif als
/// "entspricht X /Monat" angezeigt, um den Spar-Vorteil sichtbar zu machen.
class _Plan {
  const _Plan({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    this.subtitle,
    this.badge,
  });
  final String id;
  final String title;
  final String price;
  final String period;
  final String? subtitle;
  final String? badge;
}

const _plans = <_Plan>[
  _Plan(
    id: 'monthly',
    title: 'Monatlich',
    price: '2,99 €',
    period: 'pro Monat',
    subtitle: 'Flexibel, jederzeit kuendbar',
  ),
  _Plan(
    id: 'yearly',
    title: 'Jaehrlich',
    price: '19,99 €',
    period: 'pro Jahr',
    subtitle: 'entspricht 1,67 € / Monat - 44 % guenstiger',
    badge: 'BELIEBT',
  ),
  _Plan(
    id: 'lifetime',
    title: 'Einmalig',
    price: '39,99 €',
    period: 'fuer immer',
    subtitle: 'Einmal zahlen, dauerhaft Premium',
  ),
];

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.status, required this.theme});

  final PremiumStatus status;
  final ThemeData theme;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  // Jahres-Tarif ist vorausgewaehlt (bester Anker).
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final status = widget.status;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _StatusCard(status: status, theme: theme),
        const SizedBox(height: AppSpacing.xl),
        Text('Das bekommst du mit Premium', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...PremiumScreen._features.map(
          (f) => _FeatureTile(feature: f, theme: theme),
        ),
        if (!status.isPremium) ...[
          const SizedBox(height: AppSpacing.xl),
          Text('Waehle deinen Tarif', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < _plans.length; i++)
            _PlanCard(
              plan: _plans[i],
              selected: _selected == i,
              theme: theme,
              onTap: () => setState(() => _selected = i),
            ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _ActionButtons(
          status: status,
          ref: ref,
          selectedPlan: _plans[_selected],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Hinweis: Premium wird aktuell nur lokal auf diesem Geraet '
          'aktiviert - es wird (noch) kein Zahlungs-Anbieter angesprochen. '
          'Die echte Bezahlung folgt mit dem App-Store-Release.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  final _Plan plan;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: selected
            ? accent.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: selected
                    ? accent
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? accent : theme.colorScheme.outline,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(plan.title, style: theme.textTheme.titleMedium),
                          if (plan.badge != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                plan.badge!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (plan.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          plan.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.price,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(plan.period, style: theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
                Text(feature.title, style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(feature.description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.status,
    required this.ref,
    required this.selectedPlan,
  });

  final PremiumStatus status;
  final WidgetRef ref;
  final _Plan selectedPlan;

  @override
  Widget build(BuildContext context) {
    if (status.isPremium) {
      return OutlinedButton.icon(
        onPressed: () => ref.read(premiumStatusProvider.notifier).deactivate(),
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
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text('${selectedPlan.title} fuer ${selectedPlan.price} freischalten'),
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
