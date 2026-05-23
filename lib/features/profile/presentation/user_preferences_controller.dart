import 'package:dogmatch_ai/features/profile/data/local_user_preferences_repository.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPreferencesRepositoryProvider =
    Provider<UserPreferencesRepository>((ref) {
  return const LocalUserPreferencesRepository();
});

/// Haelt die personalisierten Einstellungen des Nutzers. Beim ersten
/// Zugriff werden sie asynchron aus der Persistenz geladen; Aenderungen
/// landen sofort im State und werden parallel gespeichert.
class UserPreferencesNotifier extends AsyncNotifier<UserPreferences> {
  @override
  Future<UserPreferences> build() {
    return ref.read(userPreferencesRepositoryProvider).load();
  }

  /// Speichert die Aenderungen sofort in den State und persistiert sie
  /// im Hintergrund. Bewusst nicht `update` genannt, weil der Name in
  /// Riverpod 3 von `AsyncNotifier` bereits belegt ist.
  Future<void> save(UserPreferences next) async {
    state = AsyncData(next);
    await ref.read(userPreferencesRepositoryProvider).save(next);
  }
}

final userPreferencesProvider =
    AsyncNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  UserPreferencesNotifier.new,
);
