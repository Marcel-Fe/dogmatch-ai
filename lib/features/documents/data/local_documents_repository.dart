import 'dart:convert';

import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/domain/documents_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDocumentsRepository implements DocumentsRepository {
  const LocalDocumentsRepository();

  static const String _key = 'documents_v1';

  @override
  Future<List<DogDocument>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((e) {
          try {
            return DogDocument.fromJson(
              jsonDecode(e) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<DogDocument>()
        .toList();
  }

  @override
  Future<void> save(List<DogDocument> docs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      docs.map((d) => jsonEncode(d.toJson())).toList(),
    );
  }
}
