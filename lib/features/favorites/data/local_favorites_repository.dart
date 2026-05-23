import 'package:dogmatch_ai/features/favorites/domain/favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert die Favoriten-Ids in den Plattform-Einstellungen
/// (Android/iOS: SharedPreferences/UserDefaults, Web: localStorage).
class LocalFavoritesRepository implements FavoritesRepository {
  const LocalFavoritesRepository();

  static const String _key = 'favorite_breed_ids';

  @override
  Future<Set<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}
