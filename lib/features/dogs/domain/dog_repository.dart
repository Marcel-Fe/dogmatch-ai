import 'package:dogmatch_ai/features/dogs/domain/dog.dart';

/// Persistenz fuer die Hunde des Nutzers. Phase A nutzt SharedPreferences,
/// Phase B (Firebase) wechselt auf Firestore - die UI bleibt gleich.
abstract interface class DogRepository {
  Future<List<Dog>> loadDogs();
  Future<void> saveDogs(List<Dog> dogs);

  Future<String?> loadActiveDogId();
  Future<void> saveActiveDogId(String? id);
}
