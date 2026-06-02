import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/places/data/geo_service.dart';
import 'package:dogmatch_ai/features/products/data/product_catalog.dart';
import 'package:flutter/material.dart';

/// Empfehlungen fuer den aktiven Hund: passende Fellbuerste + Futter,
/// gematcht ueber Felltyp/Groesse/Aktivitaet der Rasse. Bild + Richtpreis +
/// Kauf-Link. Preise sind Richtwerte (kein Live-Preis).
class ProductRecommendations extends StatelessWidget {
  const ProductRecommendations({super.key, required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brush = ProductCatalog.brushFor(breed);
    final food = ProductCatalog.foodFor(breed);
    final profile = ProductCatalog.foodProfile(breed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Empfohlen fuer ${breed.name}', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Futter-Profil: $profile',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _ProductTile(product: food, theme: theme),
        const SizedBox(height: AppSpacing.sm),
        _ProductTile(product: brush, theme: theme),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Preise sind Richtwerte. Tipp aufs Produkt oeffnet eine Suche im Shop.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.theme});

  final ProductRecommendation product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () => GeoService().openExternal(product.shopUrl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 192,
                    errorBuilder: (_, _, _) => Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(
                        product.kind == ProductKind.food
                            ? Icons.restaurant_rounded
                            : Icons.brush_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      product.subtitle,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.priceHintEur,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded,
                  size: 18, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
