import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/domain/health_repository.dart';

/// Firestore-Variante des [HealthRepository]. Daten liegen unter
/// `users/{uid}/healthEvents/{eventId}`.
class FirestoreHealthRepository implements HealthRepository {
  FirestoreHealthRepository({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _db = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(userId).collection('healthEvents');

  @override
  Future<List<HealthEvent>> loadEvents() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => HealthEvent.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<void> saveEvents(List<HealthEvent> events) async {
    final batch = _db.batch();
    final existing = await _col.get();
    for (final d in existing.docs) {
      if (!events.any((e) => e.id == d.id)) batch.delete(d.reference);
    }
    for (final e in events) {
      batch.set(_col.doc(e.id), e.toJson());
    }
    await batch.commit();
  }
}
