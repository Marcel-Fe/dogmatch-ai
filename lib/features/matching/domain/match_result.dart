import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:equatable/equatable.dart';

/// Ergebnis der Matching-Engine fuer eine Rasse.
class MatchResult extends Equatable {
  const MatchResult({
    required this.breed,
    required this.score,
    required this.reasons,
    required this.cons,
  });

  final DogBreed breed;

  /// Passgenauigkeit in Prozent (0-100).
  final int score;

  /// Warum die Rasse zum Nutzer passt.
  final List<String> reasons;

  /// Moegliche Nachteile bzw. worauf der Nutzer achten sollte.
  final List<String> cons;

  @override
  List<Object?> get props => [breed.id, score];
}
