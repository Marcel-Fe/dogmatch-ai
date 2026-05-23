/// Vertrag fuer das Speichern der favorisierten Rassen-Ids.
/// Lokale Persistenz in Phase 2; spaeter ggf. eine zusaetzliche
/// Firestore-Variante, ohne die UI anzufassen.
abstract interface class FavoritesRepository {
  /// Liefert alle bisher gespeicherten Favoriten-Ids.
  Future<Set<String>> loadFavoriteIds();

  /// Speichert die gesamte Menge der Favoriten-Ids.
  Future<void> saveFavoriteIds(Set<String> ids);
}
