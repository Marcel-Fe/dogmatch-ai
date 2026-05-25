import 'dart:convert';

import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/domain/health_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalHealthRepository implements HealthRepository {
  const LocalHealthRepository();

  static const String _key = 'health_events_v1';

  @override
  Future<List<HealthEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((e) {
          try {
            return HealthEvent.fromJson(
              jsonDecode(e) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<HealthEvent>()
        .toList();
  }

  @override
  Future<void> saveEvents(List<HealthEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      events.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
