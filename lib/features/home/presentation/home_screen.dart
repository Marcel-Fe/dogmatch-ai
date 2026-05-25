import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/health/presentation/widgets/upcoming_events_card.dart';
import 'package:dogmatch_ai/features/home/domain/hourly_quote.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/dog_hero_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/for_you_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/quick_actions.dart';
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
    final dogsState = ref.watch(dogsProvider).value;
    final activeDog = dogsState?.activeDog;
    final theme = Theme.of(context);
    final quote = HourlyQuote.forNow();
    final greetingName = prefs != null && prefs.hasName ? prefs.displayName : null;

    return Scaffold(
      appBar: AppBar(title: const Text('DogMatch AI')),
      body: breedsAsync.when(
        loading: () => const LoadingView(message: 'Rassen werden geladen ...'),
        error: (_, _) => ErrorView(
          message: 'Rassen konnten nicht geladen werden.',
          onRetry: () => ref.invalidate(breedsProvider),
        ),
        data: (breeds) => ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: DogHeroCard(
                dog: activeDog,
                quote: quote,
                greetingName: greetingName,
              ),
            ),
            QuickActions(),
            const SizedBox(height: AppSpacing.lg),
            if (activeDog != null &&
                (prefs?.showUpcomingOnHome ?? true)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: const UpcomingEventsCard(),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: const StatsRow(),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (prefs?.showForYouOnHome ?? true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: ForYouSection(allBreeds: breeds, prefs: prefs),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (prefs?.showFeatureGridOnHome ?? true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: const _FeatureGrid(),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
            if (prefs?.showAllBreedsOnHome ?? true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Text(
                  'Alle Rassen',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final breed in breeds) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: BreedCard(
                    breed: breed,
                    onTap: () =>
                        context.push('${AppRoutes.breedDetail}/${breed.id}'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ],
        ),
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
        icon: Icons.pets_rounded,
        label: 'Mein Hund',
        route: AppRoutes.manageDogs,
        switchTab: false,
      ),
      _FeatureItem(
        icon: Icons.calendar_month_rounded,
        label: 'Kalender',
        route: AppRoutes.healthCalendar,
        switchTab: false,
      ),
      _FeatureItem(
        icon: Icons.folder_open_rounded,
        label: 'Dokumente',
        route: AppRoutes.documents,
        switchTab: false,
      ),
      _FeatureItem(
        icon: Icons.smart_toy_rounded,
        label: 'KI-Berater',
        route: AppRoutes.assistant,
        switchTab: true,
      ),
      _FeatureItem(
        icon: Icons.quiz_rounded,
        label: 'Quiz starten',
        route: AppRoutes.quiz,
        switchTab: true,
      ),
      _FeatureItem(
        icon: Icons.favorite_rounded,
        label: 'Favoriten',
        route: AppRoutes.favorites,
        switchTab: true,
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: _FeatureCard(item: items[i])),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: i + 1 < items.length
                    ? _FeatureCard(item: items[i + 1])
                    : const SizedBox(),
              ),
            ],
          ),
          if (i + 2 < items.length) const SizedBox(height: AppSpacing.md),
        ],
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
