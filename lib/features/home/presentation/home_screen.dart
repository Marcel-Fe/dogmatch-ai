import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/home/domain/daily_tip.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/for_you_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/hero_header.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/stats_row.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Modernes Dashboard (Tab 1). Hero, Stats, personalisierte Empfehlungen,
/// Tipp des Tages, Feature-Grid und vollstaendige Rassenliste.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsAsync = ref.watch(breedsProvider);
    final prefs = ref.watch(userPreferencesProvider).value;
    final theme = Theme.of(context);
    final tip = DailyTip.forToday();
    final greeting = prefs != null && prefs.hasName
        ? 'Hallo, ${prefs.displayName}!'
        : 'Willkommen!';
    final heroSubtitle = prefs != null && prefs.hasName
        ? 'Schoen, dass du da bist. Lass uns deinen perfekten Hund finden.'
        : 'Finde die Hunderasse, die wirklich zu deinem Leben passt.';

    return Scaffold(
      appBar: AppBar(title: const Text('DogMatch AI')),
      body: breedsAsync.when(
        loading: () => const LoadingView(message: 'Rassen werden geladen ...'),
        error: (_, _) => ErrorView(
          message: 'Rassen konnten nicht geladen werden.',
          onRetry: () => ref.invalidate(breedsProvider),
        ),
        data: (breeds) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            HeroHeader(greeting: greeting, subtitle: heroSubtitle),
            const SizedBox(height: AppSpacing.xl),
            const StatsRow(),
            const SizedBox(height: AppSpacing.xl),
            ForYouSection(allBreeds: breeds, prefs: prefs),
            const SizedBox(height: AppSpacing.sm),
            _DailyTipCard(tip: tip),
            const SizedBox(height: AppSpacing.xl),
            const _FeatureGrid(),
            const SizedBox(height: AppSpacing.xl),
            Text('Alle Rassen', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final breed in breeds) ...[
              BreedCard(
                breed: breed,
                onTap: () =>
                    context.push('${AppRoutes.breedDetail}/${breed.id}'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  const _DailyTipCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIPP DES TAGES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      _FeatureItem(
        icon: Icons.quiz_rounded,
        label: 'Quiz starten',
        route: AppRoutes.quiz,
        switchTab: true,
      ),
      _FeatureItem(
        icon: Icons.smart_toy_rounded,
        label: 'KI-Berater',
        route: AppRoutes.assistant,
        switchTab: true,
      ),
      _FeatureItem(
        icon: Icons.favorite_rounded,
        label: 'Favoriten',
        route: AppRoutes.favorites,
        switchTab: true,
      ),
      _FeatureItem(
        icon: Icons.workspace_premium_outlined,
        label: 'Premium',
        route: AppRoutes.premium,
        switchTab: false,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _FeatureCard(item: items[0])),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _FeatureCard(item: items[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _FeatureCard(item: items[2])),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _FeatureCard(item: items[3])),
          ],
        ),
      ],
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.switchTab,
  });

  final IconData icon;
  final String label;
  final String route;
  final bool switchTab;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item});

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () =>
          item.switchTab ? context.go(item.route) : context.push(item.route),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
