import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Startseite (Tab 1). Zeigt eine Liste der verfuegbaren Rassen.
/// Tipp des Tages und Feature-Kacheln werden in einer spaeteren Etappe
/// ergaenzt.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsAsync = ref.watch(breedsProvider);
    final theme = Theme.of(context);

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
            Text('Finde deinen Hund', style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Entdecke beliebte Rassen oder starte das Matching-Quiz.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Beliebte Rassen', style: theme.textTheme.titleLarge),
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
