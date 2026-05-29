import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';

/// Findet die DogBreed, die zur User-Eingabe passt. Toleriert deutsche
/// Umlaute (Neufundländer <-> Neufundlaender), Bindestriche und Unterstriche.
///
/// Wird ueberall im Dashboard genutzt, wo der vom User eingetragene
/// Rassen-Freitext gegen die kuratierte breeds.json gematcht wird.
DogBreed? matchBreed(String? rawBreedInput, List<DogBreed> allBreeds) {
  if (rawBreedInput == null || rawBreedInput.trim().isEmpty) return null;
  final needle = _normalize(rawBreedInput);
  // Exakter Treffer auf Name oder ID
  for (final b in allBreeds) {
    if (_normalize(b.name) == needle || _normalize(b.id) == needle) return b;
  }
  // Substring-Fallback (z. B. User schreibt "Neufundlaender Welpe")
  for (final b in allBreeds) {
    final bn = _normalize(b.name);
    if (bn.contains(needle) || needle.contains(bn)) return b;
  }
  return null;
}

String _normalize(String s) {
  return s
      .trim()
      .toLowerCase()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll('-', ' ')
      .replaceAll('_', ' ');
}
