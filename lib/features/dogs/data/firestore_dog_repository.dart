import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog_repository.dart';

/// Firestore-Variante des [DogRepository]. Daten liegen unter
/// `users/{uid}/dogs/{dogId}`; `users/{uid}/meta/state` haelt aktiveDogId.
class FirestoreDogRepository implements DogRepository {
  FirestoreDogRepository({required this.userId, FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _dogsCol =>
      _db.collection('users').doc(userId).collection('dogs');

  DocumentReference<Map<String, dynamic>> get _stateDoc =>
      _db.collection('users').doc(userId).collection('meta').doc('state');

  @override
  Future<List<Dog>> loadDogs() async {
    final snap = await _dogsCol.get();
    return snap.docs
        .map((d) => Dog.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<void> saveDogs(List<Dog> dogs) async {
    final batch = _db.batch();
    final existing = await _dogsCol.get();
    for (final d in existing.docs) {
      if (!dogs.any((x) => x.id == d.id)) batch.delete(d.reference);
    }
    for (final d in dogs) {
      batch.set(_dogsCol.doc(d.id), d.toJson());
    }
    await batch.commit();
  }

  @override
  Future<String?> loadActiveDogId() async {
    final snap = await _stateDoc.get();
    return snap.data()?['activeDogId'] as String?;
  }

  @override
  Future<void> saveActiveDogId(String? id) async {
    if (id == null) {
      await _stateDoc.set({'activeDogId': null}, SetOptions(merge: true));
    } else {
      await _stateDoc.set({'activeDogId': id}, SetOptions(merge: true));
    }
  }
}
