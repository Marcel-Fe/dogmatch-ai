import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/favorites/presentation/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Favoriten (Tab 4). Zeigt die persistierten Lieblings-Rassen als Karten.
/// Reihenfolge: dieselbe wie im Rassenkatalog (stabile Anzeige).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final breedsAsync = ref.watch(breedsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriten')),
      body: favoritesAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Favoriten konnten nicht geladen werden.',
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
        data: (ids) {
          if (ids.isEmpty) {
            return const EmptyView(
              title: 'Noch keine Favoriten',
              message:
                  'Tippe in einem Rassenprofil oder auf der Startseite '
                  'auf das Herz, um Rassen hier zu sammeln.',
              icon: Icons.favorite_outline,
            );
          }
          return breedsAsync.when(
            loading: () => const LoadingView(),
            error: (_, _) => ErrorView(
              message: 'Rassen konnten nicht geladen werden.',
              onRetry: () => ref.invalidate(breedsProvider),
            ),
            data: (allBreeds) {
              final favorites =
                  allBreeds.where((b) => ids.contains(b.id)).toList();
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  for (final breed in favorites) ...[
                    BreedCard(
                      breed: breed,
                      onTap: () => context.push(
                        '${AppRoutes.breedDetail}/${breed.id}',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
