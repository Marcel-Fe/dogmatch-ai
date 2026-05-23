import 'dart:convert';

import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_repository.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Liest die Rassen aus der gebuendelten JSON-Datei (`assets/data/breeds.json`).
/// Die Liste wird nach dem ersten Laden zwischengespeichert.
class BreedRepositoryImpl implements BreedRepository {
  List<DogBreed>? _cache;

  @override
  Future<Result<List<DogBreed>>> getBreeds() async {
    final cached = _cache;
    if (cached != null) return Success(cached);

    try {
      final raw = await rootBundle.loadString(AppConstants.breedsAssetPath);
      final breeds = (jsonDecode(raw) as List<dynamic>)
          .map((e) => DogBreed.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache = breeds;
      return Success(breeds);
    } catch (_) {
      return const FailureResult(CacheFailure());
    }
  }

  @override
  Future<Result<DogBreed>> getBreedById(String id) async {
    final result = await getBreeds();
    switch (result) {
      case Success(:final value):
        final matches = value.where((breed) => breed.id == id);
        if (matches.isEmpty) {
          return const FailureResult(CacheFailure('Rasse nicht gefunden.'));
        }
        return Success(matches.first);
      case FailureResult(:final failure):
        return FailureResult(failure);
    }
  }
}
