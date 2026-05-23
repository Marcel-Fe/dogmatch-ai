import 'dart:convert';

import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert die Nutzer-Personalisierung als JSON-String in den
/// Plattform-Einstellungen (Web: localStorage, Mobile: SharedPreferences).
class LocalUserPreferencesRepository implements UserPreferencesRepository {
  const LocalUserPreferencesRepository();

  static const String _key = 'user_preferences';

  @override
  Future<UserPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const UserPreferences();
    try {
      return UserPreferences.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const UserPreferences();
    }
  }

  @override
  Future<void> save(UserPreferences value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(value.toJson()));
  }
}
