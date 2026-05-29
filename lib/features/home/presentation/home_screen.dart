import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
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
import 'package:dogmatch_ai/features/home/presentation/widgets/dog_hero_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/dog_switcher_row.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/for_you_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/main_drawer.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/my_dog_section.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/popular_breeds_row.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/stats_row.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/today_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/wisdom_quote_card.dart';
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
    final greetingName = prefs != null && prefs.hasName ? prefs.displayName : null;

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: const Text('DogMatch AI')),
      body: breedsAsync.when(
        loading: () => const LoadingView(message: 'Rassen werden geladen ...'),
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

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // 1) Hund-Wechsler (nur wenn mind. 1 Hund da)
              if (allDogs.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                DogSwitcherRow(dogs: allDogs, activeDog: activeDog),
                const SizedBox(height: AppSpacing.sm),
              ],

              // 2) Hero
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: DogHeroCard(
                  dog: activeDog,
                  greetingName: greetingName,
                  breedImageUrl: breedImageUrl,
                ),
              ),

              // 3) Heute fuer <Hund> - personalisiertes Tagesbriefing
              if (activeDog != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: TodayCard(dog: activeDog),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 4) Hunde-Weisheit der Stunde (rotiert jede Stunde)
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: WisdomQuoteCard(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 5) Schnellaktionen
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: const QuickActionGrid(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4) Termine (kompakt) - nur wenn aktiver Hund da
              if (showMyDog && (prefs?.showUpcomingOnHome ?? true)) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: const UpcomingEventsCard(),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // 5) MyDogSection - der zentrale Punkt der Familien-App
              if (showMyDog) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: MyDogSection(dog: activeDog, allBreeds: breeds),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // 6) Beliebte Rassen (Inspiration)
              PopularBreedsRow(
                allBreeds: breeds,
                activeBreedName: activeDog?.breed,
              ),
              const SizedBox(height: AppSpacing.xl),

              // 7) Fuer dich (personalisiert)
              if (prefs?.showForYouOnHome ?? true) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: ForYouSection(allBreeds: breeds, prefs: prefs),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // 8) Statistik-Zeile
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: const StatsRow(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 9) Entdecken: BreedSearchBar + alle Rassen (am Ende)
              if (prefs?.showAllBreedsOnHome ?? true) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Entdecken: Alle Rassen',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      Consumer(builder: (context, ref, _) {
                        final filtered =
                            ref.watch(filteredBreedsProvider);
                        return Text(
                          '${filtered.length}/${breeds.length}',
                          style: theme.textTheme.bodySmall,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: const BreedSearchBar(),
                ),
                const SizedBox(height: AppSpacing.md),
                Consumer(builder: (context, ref, _) {
                  final filtered = ref.watch(filteredBreedsProvider);
                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Text(
                          'Keine Rasse passt zu deinen Filtern.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final breed in filtered) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: BreedCard(
                            breed: breed,
                            onTap: () => context.push(
                                '${AppRoutes.breedDetail}/${breed.id}'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  );
                }),
              ],
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }
}

