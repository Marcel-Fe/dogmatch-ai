import 'dart:convert';

import 'package:dogmatch_ai/features/breeders/domain/breeder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Laedt das kuratierte Zuechter-Verzeichnis aus dem Asset-Bundle.
class AssetBreederRepository {
  const AssetBreederRepository();

  static const String _assetPath = 'assets/data/breeders.json';

  Future<List<Breeder>> loadAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(Breeder.fromJson).toList(growable: false);
  }
}

final breederRepositoryProvider = Provider<AssetBreederRepository>((ref) {
  return const AssetBreederRepository();
});

final breedersProvider = FutureProvider<List<Breeder>>((ref) {
  return ref.read(breederRepositoryProvider).loadAll();
});
