import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';

/// Vertrag der domain-Schicht fuer den Zugriff auf Rassendaten.
///
/// Die Praesentation kennt nur dieses Interface, nicht die konkrete Quelle.
/// In Phase 1/2 liefert die Implementierung gebuendelte Asset-Daten; spaeter
/// kann ohne Aenderung an der UI eine Firestore-Variante folgen.
abstract interface class BreedRepository {
  /// Liefert alle verfuegbaren Rassen.
  Future<Result<List<DogBreed>>> getBreeds();

  /// Liefert eine einzelne Rasse anhand ihrer [id].
  Future<Result<DogBreed>> getBreedById(String id);
}
