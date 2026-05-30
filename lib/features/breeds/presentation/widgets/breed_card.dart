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
          BreedThumbnail(breed: breed, size: 72),
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

/// Wiederverwendbares Vorschaubild einer Rasse. Bevorzugt [DogBreed.imageAsset]
/// (Bundle), faellt auf [DogBreed.imageUrl] (Netz) zurueck und zeigt im
/// Fehlerfall ein Icon-Placeholder mit Markenfarbe.
class BreedThumbnail extends StatelessWidget {
  const BreedThumbnail({
    super.key,
    required this.breed,
    this.size = 64,
    this.borderRadius,
  });

  final DogBreed breed;
  final double size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd);

    Widget fallback() => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: radius,
          ),
          child: Icon(
            Icons.pets_rounded,
            color: theme.colorScheme.primary,
            size: size * 0.45,
          ),
        );

    // BoxFit.contain damit der Hund auch im Thumbnail komplett sichtbar
    // bleibt - die Hintergrundfarbe fuellt eventuelle Aussparungen.
    final bg = theme.colorScheme.primary.withValues(alpha: 0.08);
    Widget? child;
    if (breed.imageAsset != null && breed.imageAsset!.isNotEmpty) {
      child = Container(
        width: size,
        height: size,
        color: bg,
        child: Image.asset(
          breed.imageAsset!,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => fallback(),
        ),
      );
    } else if (breed.imageUrl != null && breed.imageUrl!.isNotEmpty) {
      // Bild nur in Anzeigegroesse dekodieren (statt voller Wikimedia-
      // Aufloesung) - spart auf dem Handy enorm Speicher und verhindert
      // Ruckeln beim Scrollen durch viele Rassen.
      final cacheW =
          (size * MediaQuery.devicePixelRatioOf(context)).round();
      child = Container(
        width: size,
        height: size,
        color: bg,
        child: Image.network(
          breed.imageUrl!,
          fit: BoxFit.contain,
          cacheWidth: cacheW,
          loadingBuilder: (ctx, c, p) {
            if (p == null) return c;
            return Container(
              width: size,
              height: size,
              color: theme.colorScheme.surfaceContainerHighest,
            );
          },
          errorBuilder: (_, _, _) => fallback(),
        ),
      );
    }

    if (child == null) return fallback();
    return ClipRRect(borderRadius: radius, child: child);
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
