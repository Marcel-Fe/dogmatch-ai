import 'dart:convert';

import 'package:dogmatch_ai/features/training/domain/training_progress.dart';
import 'package:dogmatch_ai/features/training/domain/training_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert den Trainings-Fortschritt lokal. Web -> localStorage,
/// Mobile -> SharedPreferences. Pro `planId` ein Eintrag als JSON.
class LocalTrainingProgressRepository implements TrainingProgressRepository {
  const LocalTrainingProgressRepository();

  static const String _key = 'training_progress';

  @override
  Future<Map<String, TrainingProgress>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      final map = (jsonDecode(raw) as Map<String, dynamic>);
      return map.map(
        (k, v) =>
            MapEntry(k, TrainingProgress.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }

  @override
  Future<void> save(TrainingProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAll();
    all[progress.planId] = progress;
    final serialized = all.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_key, jsonEncode(serialized));
  }

  @override
  Future<void> reset(String planId) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAll();
    all.remove(planId);
    final serialized = all.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_key, jsonEncode(serialized));
  }
}
