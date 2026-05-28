import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Horizontal scrollbare Reihe mit runden Bild-Avataren der beliebtesten
/// Rassen - Instagram-Story-Stil als visueller Anker oben am Dashboard.
///
/// Wenn `activeBreedName` gesetzt ist und in der Rassen-Liste auftaucht,
/// wird die aktive Rasse als erstes Element eingefuegt - so sieht der
/// Nutzer "seinen" Hund immer prominent.
class PopularBreedsRow extends StatelessWidget {
  const PopularBreedsRow({
    super.key,
    required this.allBreeds,
    this.activeBreedName,
  });

  final List<DogBreed> allBreeds;
  final String? activeBreedName;

  /// Kuratierte Top-Liste. Bewusst breit gestreut: Familienhunde,
  /// Wachhunde, kleine + grosse Rassen, Mischlinge.
  static const _popularIds = [
    'labrador-retriever',
    'golden-retriever',
    'franzoesische-bulldogge',
    'deutscher-schaeferhund',
    'border-collie',
    'mops',
    'beagle',
    'dackel',
    'chihuahua',
    'goldendoodle',
    'australian-shepherd',
    'cavalier-king-charles',
    'siberian-husky',
    'boston-terrier',
    'shih-tzu',
    'neufundlaender',
    'bernhardiner',
    'berner-sennenhund',
    'akita',
    'cane-corso',
    'rottweiler',
    'doberman',
    'pudel',
    'yorkshire-terrier',
    'jack-russell-terrier',
    'malinois',
    'rhodesian-ridgeback',
    'leonberger',
    'havaneser',
    'shiba-inu',
  ];

  List<DogBreed> _picks() {
    final byId = {for (final b in allBreeds) b.id: b};
    final list = <DogBreed>[];
    final added = <String>{};

    // Aktive Rasse zuerst, falls vorhanden (case-insensitive Match auf
    // name oder id).
    final active = activeBreedName?.trim().toLowerCase();
    if (active != null && active.isNotEmpty) {
      for (final b in allBreeds) {
        if (b.name.toLowerCase() == active || b.id.toLowerCase() == active) {
          list.add(b);
          added.add(b.id);
          break;
        }
      }
    }

    for (final id in _popularIds) {
      if (added.contains(id)) continue;
      final b = byId[id];
      if (b != null) {
        list.add(b);
        added.add(id);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final picks = _picks();
    if (picks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text('Beliebte Rassen', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: picks.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, i) => _PopularItem(breed: picks[i]),
          ),
        ),
      ],
    );
  }
}

class _PopularItem extends StatelessWidget {
  const _PopularItem({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () =>
          context.push('${AppRoutes.breedDetail}/${breed.id}'),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: _img(theme),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              breed.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _img(ThemeData theme) {
    Widget fallback() => Container(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.pets_rounded, color: theme.colorScheme.primary),
        );

    if (breed.imageUrl == null || breed.imageUrl!.isEmpty) return fallback();
    // BoxFit.contain damit auch bei runden Avataren kein Hundekopf
    // weggeschnitten wird; Hintergrundfarbe fuellt den restlichen Kreis.
    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Image.network(
        breed.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => fallback(),
      ),
    );
  }
}
