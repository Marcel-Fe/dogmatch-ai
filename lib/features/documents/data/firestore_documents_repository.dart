import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/domain/documents_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firestore + Storage Variante des [DocumentsRepository].
/// - Metadaten: `users/{uid}/documents/{docId}`
/// - Dateibytes: Storage `users/{uid}/documents/{docId}/{name}`
///
/// Beim Save wird ein `data:...`-Base64-Eintrag automatisch in Storage
/// hochgeladen, die DownloadURL ersetzt dann den Base64-Inhalt. Beim
/// Loeschen wird die Datei im Storage mitentfernt.
class FirestoreDocumentsRepository implements DocumentsRepository {
  FirestoreDocumentsRepository({
    required this.userId,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final String userId;
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(userId).collection('documents');

  Reference _storageRef(String docId, String name) =>
      _storage.ref('users/$userId/documents/$docId/$name');

  @override
  Future<List<DogDocument>> load() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => DogDocument.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<void> save(List<DogDocument> docs) async {
    final existing = await _col.get();
    final existingIds = existing.docs.map((d) => d.id).toSet();
    final keepIds = docs.map((d) => d.id).toSet();

    // Geloeschte Eintraege: Storage-File und Firestore-Doc entfernen.
    for (final d in existing.docs) {
      if (!keepIds.contains(d.id)) {
        final name = d.data()['name'] as String?;
        if (name != null) {
          try {
            await _storageRef(d.id, name).delete();
          } catch (_) {
            // Datei evtl. nie hochgeladen (Storage-URL als Original).
          }
        }
        await d.reference.delete();
      }
    }

    // Bestehende oder neue Eintraege: Base64 ggf. nach Storage migrieren.
    for (final doc in docs) {
      final isNew = !existingIds.contains(doc.id);
      final isInline = doc.dataUrl.startsWith('data:');

      DogDocument toWrite = doc;
      if (isInline) {
        final bytes = _decodeDataUrl(doc.dataUrl);
        final ref = _storageRef(doc.id, doc.name);
        await ref.putData(
          bytes,
          SettableMetadata(contentType: doc.mimeType),
        );
        final url = await ref.getDownloadURL();
        toWrite = DogDocument(
          id: doc.id,
          dogId: doc.dogId,
          name: doc.name,
          mimeType: doc.mimeType,
          dataUrl: url,
          sizeBytes: doc.sizeBytes,
          addedAt: doc.addedAt,
        );
      } else if (isNew && doc.dataUrl.startsWith('http')) {
        // Bereits eine Remote-URL - nichts zu tun, einfach weiterschreiben.
      }

      await _col.doc(toWrite.id).set(toWrite.toJson());
    }
  }

  Uint8List _decodeDataUrl(String dataUrl) {
    final idx = dataUrl.indexOf(',');
    final b64 = idx >= 0 ? dataUrl.substring(idx + 1) : dataUrl;
    return base64Decode(b64);
  }
}
