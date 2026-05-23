import 'package:dogmatch_ai/features/favorites/data/local_favorites_repository.dart';
import 'package:dogmatch_ai/features/favorites/domain/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stellt die konkrete Repository-Implementierung bereit.
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return const LocalFavoritesRepository();
});

/// Haelt die aktuelle Menge favorisierter Rassen-Ids. Beim ersten Zugriff
/// werden die Ids asynchron aus der Persistenz geladen ([AsyncNotifier.build]).
/// Aenderungen werden sofort im State sichtbar und parallel persistiert.
class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() {
    return ref.read(favoritesRepositoryProvider).loadFavoriteIds();
  }

  /// Fuegt die Id hinzu, wenn sie fehlt - sonst wird sie entfernt.
  Future<void> toggle(String breedId) async {
    final current = state.value ?? const <String>{};
    final next = Set<String>.from(current);
    if (!next.add(breedId)) {
      next.remove(breedId);
    }
    state = AsyncData(next);
    await ref.read(favoritesRepositoryProvider).saveFavoriteIds(next);
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);
