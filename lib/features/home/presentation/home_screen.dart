import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_background.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_matcher.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_filter_controller.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_search_bar.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/health/presentation/widgets/upcoming_events_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/dashboard_ai_bar.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/dog_hero_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/discover_more_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/dog_switcher_row.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/for_you_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/main_drawer.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/my_dog_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/popular_breeds_row.dart';
import 'package:dogmatch_ai/features/products/presentation/product_recommendations.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/stats_row.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/today_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/welcome_dialog.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/wisdom_quote_card.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:dogmatch_ai/features/weather/presentation/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Einmal pro App-Start: das Begruessungs-Popup wurde schon gezeigt.
/// Modul-Ebene, damit es Tab-Wechsel ueberlebt, aber beim echten
/// App-Neustart (Reload) zurueckgesetzt wird.
bool _welcomeShown = false;

/// Modernes Dashboard (Tab 1). Hero, Stats, personalisierte Empfehlungen,
/// Tipp des Tages, Feature-Grid und vollstaendige Rassenliste.
///
/// Das [DashboardLayout] aus den Einstellungen bestimmt, welche Bausteine in
/// welcher Reihenfolge und Dichte erscheinen (Standard, Fokus, Kompakt,
/// Magazin). Die Section-Toggles des Nutzers bleiben zusaetzlich wirksam.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsAsync = ref.watch(breedsProvider);
    final prefs = ref.watch(userPreferencesProvider).value;
    final dogsState = ref.watch(dogsProvider).value;
    final activeDog = dogsState?.activeDog;
    final greetingName = prefs != null && prefs.hasName
        ? prefs.displayName
        : null;

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: const Text('DogMatch AI')),
      body: Stack(
        children: [
          Positioned.fill(
            child: AppBackground(
              background:
                  prefs?.dashboardBackground ?? DashboardBackground.gradient,
              seed: prefs?.dashboardStyle.seed ?? AppColors.primary,
            ),
          ),
          breedsAsync.when(
            loading: () =>
                const LoadingView(message: 'Rassen werden geladen ...'),
            error: (_, _) => ErrorView(
              message: 'Rassen konnten nicht geladen werden.',
              onRetry: () => ref.invalidate(breedsProvider),
            ),
            data: (breeds) {
              // Bild der Hund-Rasse als Fallback, wenn der eigene Hund kein
              // Foto hat - matchBreed toleriert Umlaute (Neufundländer ↔ Neufundlaender).
              final matched = matchBreed(activeDog?.breed, breeds);
              final String? breedImageUrl = matched?.imageUrl;
              final allDogs = dogsState?.dogs ?? const <Dog>[];
              final showMyDog = activeDog != null;
              final layout = prefs?.dashboardLayout ?? DashboardLayout.standard;

              // Begruessungs-Popup einmal pro App-Start nach dem ersten Frame.
              if (!_welcomeShown) {
                _welcomeShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showWelcomeDialog(
                      context,
                      dog: activeDog,
                      userName: greetingName,
                    );
                  }
                });
              }

              // Benannte Bausteine - nur sichtbare (Toggles + Verfuegbarkeit)
              // landen in der Map; das Layout entscheidet ueber die Reihenfolge.
              const hPad = EdgeInsets.symmetric(horizontal: AppSpacing.lg);
              final sec = <String, Widget>{};
              if (allDogs.isNotEmpty) {
                sec['dogSwitcher'] = DogSwitcherRow(
                  dogs: allDogs,
                  activeDog: activeDog,
                );
              }
              sec['aiBar'] = const Padding(
                padding: hPad,
                child: DashboardAiBar(),
              );
              sec['hero'] = Padding(
                padding: hPad,
                child: DogHeroCard(
                  dog: activeDog,
                  greetingName: greetingName,
                  breedImageUrl: breedImageUrl,
                ),
              );
              if (activeDog != null) {
                sec['today'] = Padding(
                  padding: hPad,
                  child: TodayCard(dog: activeDog),
                );
              }
              sec['weather'] = Padding(
                padding: hPad,
                child: WeatherCard(dogName: activeDog?.name),
              );
              sec['wisdom'] = const Padding(
                padding: hPad,
                child: WisdomQuoteCard(),
              );
              if (prefs?.showFeatureGridOnHome ?? true) {
                sec['quick'] = const Padding(
                  padding: hPad,
                  child: QuickActionGrid(),
                );
              }
              sec['discover'] = const DiscoverMoreSection();
              if (showMyDog && (prefs?.showUpcomingOnHome ?? true)) {
                sec['upcoming'] = const Padding(
                  padding: hPad,
                  child: UpcomingEventsCard(),
                );
              }
              if (showMyDog) {
                sec['myDog'] = Padding(
                  padding: hPad,
                  child: MyDogSection(dog: activeDog, allBreeds: breeds),
                );
              }
              if (showMyDog && matched != null) {
                sec['products'] = Padding(
                  padding: hPad,
                  child: ProductRecommendations(breed: matched),
                );
              }
              sec['popular'] = PopularBreedsRow(
                allBreeds: breeds,
                activeBreedName: activeDog?.breed,
              );
              if (prefs?.showForYouOnHome ?? true) {
                sec['forYou'] = Padding(
                  padding: hPad,
                  child: ForYouSection(allBreeds: breeds, prefs: prefs),
                );
              }
              sec['stats'] = const Padding(padding: hPad, child: StatsRow());
              if (prefs?.showAllBreedsOnHome ?? true) {
                sec['breeds'] = const _BreedsPreviewSection();
              }

              const standard = [
                'dogSwitcher',
                'aiBar',
                'hero',
                'today',
                'weather',
                'wisdom',
                'quick',
                'discover',
                'upcoming',
                'myDog',
                'products',
                'popular',
                'forYou',
                'stats',
                'breeds',
              ];
              const focus = [
                'dogSwitcher',
                'aiBar',
                'hero',
                'today',
                'weather',
                'upcoming',
                'myDog',
              ];
              const compact = [
                'dogSwitcher',
                'aiBar',
                'quick',
                'hero',
                'today',
                'myDog',
                'upcoming',
                'stats',
                'popular',
                'breeds',
              ];
              const magazine = [
                'dogSwitcher',
                'hero',
                'popular',
                'discover',
                'aiBar',
                'today',
                'myDog',
                'products',
                'forYou',
                'wisdom',
                'breeds',
                'stats',
              ];
              final order = switch (layout) {
                DashboardLayout.standard => standard,
                DashboardLayout.focus => focus,
                DashboardLayout.compact => compact,
                DashboardLayout.magazine => magazine,
              };
              final gap = layout == DashboardLayout.compact
                  ? AppSpacing.lg
                  : AppSpacing.xl;

              final sections = <Widget>[const SizedBox(height: AppSpacing.md)];
              for (final key in order) {
                final w = sec[key];
                if (w == null) continue;
                sections.add(w);
                sections.add(SizedBox(height: gap));
              }
              sections.add(const SizedBox(height: AppSpacing.xxl));

              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => sections[index],
                      childCount: sections.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// "Entdecken: Rassen" - Suchleiste + Vorschau (max 8). Die volle Liste lebt
/// auf dem eigenen Rassen-Screen. Eigenes Widget, damit nur dieser Block neu
/// baut, wenn sich der Suchfilter aendert.
class _BreedsPreviewSection extends ConsumerWidget {
  const _BreedsPreviewSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filtered = ref.watch(filteredBreedsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Entdecken: Rassen',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.breedList),
                child: const Text('Alle anzeigen'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: BreedSearchBar(),
        ),
        const SizedBox(height: AppSpacing.md),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                'Keine Rasse passt zu deinen Filtern.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
        else ...[
          for (final breed in filtered.take(8)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BreedCard(
                breed: breed,
                onTap: () =>
                    context.push('${AppRoutes.breedDetail}/${breed.id}'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (filtered.length > 8)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.breedList),
                icon: const Icon(Icons.grid_view_rounded),
                label: Text('Alle ${filtered.length} Rassen ansehen'),
              ),
            ),
        ],
      ],
    );
  }
}
