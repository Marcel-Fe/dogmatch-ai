import 'package:dogmatch_ai/features/documents/domain/document.dart';

abstract interface class DocumentsRepository {
  Future<List<DogDocument>> load();
  Future<void> save(List<DogDocument> docs);
}
