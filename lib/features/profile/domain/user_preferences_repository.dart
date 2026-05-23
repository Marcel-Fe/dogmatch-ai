import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';

/// Vertrag fuer das Persistieren der Nutzer-Personalisierung.
abstract interface class UserPreferencesRepository {
  Future<UserPreferences> load();
  Future<void> save(UserPreferences prefs);
}
