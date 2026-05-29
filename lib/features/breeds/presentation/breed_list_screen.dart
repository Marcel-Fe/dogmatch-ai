import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_filter_controller.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Durchblaetterbare Liste aller Rassen mit Suche, Filter und Sortierung.
/// Nutzt die vorhandenen Bausteine (Suchleiste, Filter, Karten) und ist
/// ueber das Drawer-Menue erreichbar.
class BreedListScreen extends ConsumerWidget {
  const BreedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final breedsAsync = ref.watch(breedsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alle Rassen')),
      body: breedsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Rassen konnten nicht geladen werden.',
          onRetry: () => ref.invalidate(breedsProvider),
        ),
        data: (allBreeds) {
          final filtered = ref.watch(filteredBreedsProvider);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BreedSearchBar(),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${filtered.length} von ${allBreeds.length} Rassen',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'Keine Rasse passt zu deiner Suche. Aendere die '
                            'Filter oder den Suchbegriff.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xxl,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final breed = filtered[index];
                          return BreedCard(
                            breed: breed,
                            onTap: () => context.push(
                              '${AppRoutes.breedDetail}/${breed.id}',
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
