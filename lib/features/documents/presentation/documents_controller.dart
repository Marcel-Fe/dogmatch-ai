import 'package:dogmatch_ai/features/auth/presentation/auth_controller.dart';
import 'package:dogmatch_ai/features/documents/data/firestore_documents_repository.dart';
import 'package:dogmatch_ai/features/documents/data/local_documents_repository.dart';
import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/domain/documents_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Liefert Firestore+Storage-Repo wenn ein User eingeloggt ist, sonst lokal.
final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return FirestoreDocumentsRepository(userId: user.id);
  }
  return const LocalDocumentsRepository();
});

class DocumentsNotifier extends AsyncNotifier<List<DogDocument>> {
  @override
  Future<List<DogDocument>> build() {
    return ref.read(documentsRepositoryProvider).load();
  }

  Future<void> _persist(List<DogDocument> next) async {
    state = AsyncData(next);
    await ref.read(documentsRepositoryProvider).save(next);
  }

  Future<void> addDocument(DogDocument doc) async {
    final current = state.value ?? const [];
    await _persist([doc, ...current]);
  }

  Future<void> removeDocument(String id) async {
    final current = state.value ?? const [];
    await _persist(current.where((d) => d.id != id).toList());
  }
}

final documentsProvider =
    AsyncNotifierProvider<DocumentsNotifier, List<DogDocument>>(
  DocumentsNotifier.new,
);
