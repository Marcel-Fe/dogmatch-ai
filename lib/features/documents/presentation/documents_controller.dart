import 'package:dogmatch_ai/features/documents/data/local_documents_repository.dart';
import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/domain/documents_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
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
