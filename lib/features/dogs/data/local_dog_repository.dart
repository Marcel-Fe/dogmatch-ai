import 'dart:convert';

import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert Hunde lokal in SharedPreferences (Web: localStorage).
class LocalDogRepository implements DogRepository {
  const LocalDogRepository();

  static const String _dogsKey = 'dogs_v1';
  static const String _activeKey = 'active_dog_id_v1';

  @override
  Future<List<Dog>> loadDogs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_dogsKey) ?? const [];
    return raw
        .map((entry) {
          try {
            return Dog.fromJson(jsonDecode(entry) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<Dog>()
        .toList();
  }

  @override
  Future<void> saveDogs(List<Dog> dogs) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = dogs.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_dogsKey, encoded);
  }

  @override
  Future<String?> loadActiveDogId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeKey);
  }

  @override
  Future<void> saveActiveDogId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_activeKey);
    } else {
      await prefs.setString(_activeKey, id);
    }
  }
}
