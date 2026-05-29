import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsKey = 'checklist_done_v1';

/// Welche Item-Indices pro Checkliste abgehakt sind.
/// Format in SharedPreferences: pro Checklisten-ID die gemerkten
/// Item-Indices, serialisiert als String "id:1,2,3|id2:0,4".
class ChecklistProgressNotifier
    extends AsyncNotifier<Map<String, Set<int>>> {
  @override
  Future<Map<String, Set<int>>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return {};
    return _decode(raw);
  }

  Future<void> toggleItem(String checklistId, int index) async {
    final current = Map<String, Set<int>>.from(state.value ?? {});
    final set = Set<int>.from(current[checklistId] ?? const <int>{});
    if (set.contains(index)) {
      set.remove(index);
    } else {
      set.add(index);
    }
    current[checklistId] = set;
    state = AsyncData(current);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _encode(current));
  }

  Future<void> resetChecklist(String checklistId) async {
    final current = Map<String, Set<int>>.from(state.value ?? {});
    current.remove(checklistId);
    state = AsyncData(current);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _encode(current));
  }

  static String _encode(Map<String, Set<int>> data) {
    return data.entries
        .map((e) => '${e.key}:${e.value.toList().join(',')}')
        .join('|');
  }

  static Map<String, Set<int>> _decode(String raw) {
    final result = <String, Set<int>>{};
    for (final part in raw.split('|')) {
      if (part.isEmpty) continue;
      final colon = part.indexOf(':');
      if (colon <= 0) continue;
      final id = part.substring(0, colon);
      final rest = part.substring(colon + 1);
      final indices = <int>{};
      for (final n in rest.split(',')) {
        final v = int.tryParse(n);
        if (v != null) indices.add(v);
      }
      result[id] = indices;
    }
    return result;
  }
}

final checklistProgressProvider = AsyncNotifierProvider<
    ChecklistProgressNotifier, Map<String, Set<int>>>(
  ChecklistProgressNotifier.new,
);
