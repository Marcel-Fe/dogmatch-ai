import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/home/presentation/widgets/breed_hero_card.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Personalisierte Rassen-Empfehlungen. Erste Empfehlung als grosse
/// Hero-Bildkarte, danach zwei kleinere BreedCards.
class ForYouSection extends StatelessWidget {
  const ForYouSection({
    super.key,
    required this.allBreeds,
    required this.prefs,
  });

  final List<DogBreed> allBreeds;
  final UserPreferences? prefs;

  List<DogBreed> _picks() {
    var pool = List<DogBreed>.from(allBreeds);
    if (prefs?.preferredSize != null) {
      pool = pool.where((b) => b.size == prefs!.preferredSize).toList();
    }
    if (prefs?.preferredActivity != null) {
      final filtered = pool
          .where((b) => b.energyLevel == prefs!.preferredActivity)
          .toList();
      if (filtered.isNotEmpty) pool = filtered;
    }
    if (pool.isEmpty) pool = List<DogBreed>.from(allBreeds);
    return pool.take(8).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final picks = _picks();
    if (picks.isEmpty) return const SizedBox.shrink();

    final hasFilters =
        prefs?.preferredSize != null || prefs?.preferredActivity != null;
    final subtitle = hasFilters
        ? 'Passend zu deinen Vorlieben'
        : 'Erste Empfehlungen - personalisiere dein Profil fuer noch passendere Treffer';

    final hero = picks.first;
    final rest = picks.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fuer dich', style: theme.textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(subtitle, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        BreedHeroCard(
          breed: hero,
          onTap: () =>
              context.push('${AppRoutes.breedDetail}/${hero.id}'),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final breed in rest) ...[
          BreedCard(
            breed: breed,
            onTap: () =>
                context.push('${AppRoutes.breedDetail}/${breed.id}'),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
