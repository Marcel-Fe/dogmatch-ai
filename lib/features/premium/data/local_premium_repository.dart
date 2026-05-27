import 'dart:convert';

import 'package:dogmatch_ai/features/premium/domain/premium_repository.dart';
import 'package:dogmatch_ai/features/premium/domain/premium_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert den Premium-Status als JSON in den Plattform-Einstellungen.
/// Web -> localStorage, Mobile -> SharedPreferences.
class LocalPremiumRepository implements PremiumRepository {
  const LocalPremiumRepository();

  static const String _key = 'premium_status';

  @override
  Future<PremiumStatus> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const PremiumStatus();
    try {
      return PremiumStatus.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const PremiumStatus();
    }
  }

  @override
  Future<void> save(PremiumStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(status.toJson()));
  }
}
