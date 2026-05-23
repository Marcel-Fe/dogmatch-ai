import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/breeds/data/breed_repository_impl.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_repository.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stellt die konkrete Repository-Implementierung bereit. Ein Austausch
/// (z.B. gegen eine Firestore-Variante) betrifft nur diese eine Zeile.
final breedRepositoryProvider = Provider<BreedRepository>((ref) {
  return BreedRepositoryImpl();
});

/// Laedt alle Rassen. Die UI nutzt den `AsyncValue`-Zustand fuer
/// Lade-, Fehler- und Daten-Anzeige.
final breedsProvider = FutureProvider<List<DogBreed>>((ref) async {
  final result = await ref.watch(breedRepositoryProvider).getBreeds();
  return switch (result) {
    Success(:final value) => value,
    FailureResult(:final failure) => throw Exception(failure.message),
  };
});

/// Laedt eine einzelne Rasse anhand ihrer id.
final breedByIdProvider =
    FutureProvider.family<DogBreed, String>((ref, id) async {
  final result = await ref.watch(breedRepositoryProvider).getBreedById(id);
  return switch (result) {
    Success(:final value) => value,
    FailureResult(:final failure) => throw Exception(failure.message),
  };
});
