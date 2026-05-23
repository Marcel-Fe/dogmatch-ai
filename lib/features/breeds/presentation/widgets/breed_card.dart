import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

/// Kompakte Vorschaukarte einer Rasse fuer Listen (Home, Match-Ergebnisse).
class BreedCard extends StatelessWidget {
  const BreedCard({super.key, required this.breed, this.onTap});

  final DogBreed breed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(Icons.pets_rounded, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(breed.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${breed.origin}  ·  ${breed.size.label}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _Tag(text: 'Energie: ${breed.energyLevel.label}'),
                    _Tag(text: '~${breed.monthlyCostEur} EUR/Monat'),
                  ],
                ),
              ],
            ),
          ),
          FavoriteButton(breedId: breed.id),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }
}
