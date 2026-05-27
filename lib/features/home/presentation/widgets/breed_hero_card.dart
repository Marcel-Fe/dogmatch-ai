import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

/// Grosse Hero-Karte fuer eine Rasse mit Bild, Gradient-Overlay und
/// Name/Stats unten - fuer die "Fuer dich"-Empfehlungen.
class BreedHeroCard extends StatelessWidget {
  const BreedHeroCard({
    super.key,
    required this.breed,
    this.onTap,
    this.height = 220,
  });

  final DogBreed breed;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AppSpacing.radiusLg);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ImageLayer(breed: breed),
              const _GradientOverlay(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Material(
                          color: Colors.black.withValues(alpha: 0.32),
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: FavoriteButton(breedId: breed.id),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      breed.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${breed.origin}  ·  ${breed.size.label}  ·  Energie ${breed.energyLevel.label}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        shadows: const [
                          Shadow(blurRadius: 6, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _Pill(
                          icon: Icons.euro_rounded,
                          text: '~${breed.monthlyCostEur} EUR/Monat',
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _Pill(
                          icon: Icons.cake_outlined,
                          text: '${breed.lifeExpectancyYears} Jahre',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageLayer extends StatelessWidget {
  const _ImageLayer({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget fallback() => Container(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
          child: Icon(
            Icons.pets_rounded,
            size: 96,
            color: theme.colorScheme.primary,
          ),
        );

    // BoxFit.contain damit der Hund komplett sichtbar bleibt (kein Anschnitt).
    // Hintergrund-Container nimmt die Aussparung optisch auf.
    final bg = theme.colorScheme.primary.withValues(alpha: 0.12);

    if (breed.imageAsset != null && breed.imageAsset!.isNotEmpty) {
      return Container(
        color: bg,
        child: Image.asset(
          breed.imageAsset!,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => fallback(),
        ),
      );
    }
    if (breed.imageUrl != null && breed.imageUrl!.isNotEmpty) {
      return Container(
        color: bg,
        child: Image.network(
          breed.imageUrl!,
          fit: BoxFit.contain,
          loadingBuilder: (ctx, c, p) {
            if (p == null) return c;
            return Container(color: theme.colorScheme.surfaceContainerHighest);
          },
          errorBuilder: (_, _, _) => fallback(),
        ),
      );
    }
    return fallback();
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0x66000000),
            Color(0xCC000000),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
