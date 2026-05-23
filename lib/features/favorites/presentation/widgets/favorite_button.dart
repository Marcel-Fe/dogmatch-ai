import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/features/favorites/presentation/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Herz-Button zum Hinzufuegen/Entfernen einer Rasse aus den Favoriten.
/// Reagiert live auf den globalen Favoriten-State.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.breedId, this.size = 24});

  final String breedId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
        (value) => value.value?.contains(breedId) ?? false,
      ),
    );
    final theme = Theme.of(context);

    return IconButton(
      iconSize: size,
      tooltip:
          isFav ? 'Aus Favoriten entfernen' : 'Zu Favoriten hinzufuegen',
      icon: Icon(
        isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
        color: isFav ? AppColors.error : theme.colorScheme.onSurfaceVariant,
      ),
      onPressed: () =>
          ref.read(favoritesProvider.notifier).toggle(breedId),
    );
  }
}
