import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Horizontal scrollbare Reihe mit runden Bild-Avataren der beliebtesten
/// Rassen - Instagram-Story-Stil als visueller Anker oben am Dashboard.
class PopularBreedsRow extends StatelessWidget {
  const PopularBreedsRow({super.key, required this.allBreeds});

  final List<DogBreed> allBreeds;

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
  ];

  List<DogBreed> _picks() {
    final byId = {for (final b in allBreeds) b.id: b};
    final list = <DogBreed>[];
    for (final id in _popularIds) {
      final b = byId[id];
      if (b != null) list.add(b);
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
    return Image.network(
      breed.imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback(),
    );
  }
}
