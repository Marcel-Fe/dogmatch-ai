import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:equatable/equatable.dart';

/// Eine Hunderasse mit allen Profil-Daten. Unveraenderlich (alle Felder final).
///
/// Die Bewertungsfelder ([grooming], [shedding], [childFriendliness],
/// [beginnerFriendliness], [trainability], [exerciseNeed]) sind Skalenwerte
/// von 1 (gering) bis 5 (hoch).
class DogBreed extends Equatable {
  const DogBreed({
    required this.id,
    required this.name,
    required this.origin,
    required this.size,
    required this.temperament,
    required this.description,
    required this.energyLevel,
    required this.grooming,
    required this.shedding,
    required this.childFriendliness,
    required this.beginnerFriendliness,
    required this.trainability,
    required this.exerciseNeed,
    required this.lifeExpectancyYears,
    required this.weightKgMin,
    required this.weightKgMax,
    required this.monthlyCostEur,
    required this.commonHealthIssues,
    required this.traits,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String origin;
  final DogSize size;
  final String temperament;
  final String description;
  final ActivityLevel energyLevel;

  // Bewertungen 1-5.
  final int grooming;
  final int shedding;
  final int childFriendliness;
  final int beginnerFriendliness;
  final int trainability;
  final int exerciseNeed;

  final int lifeExpectancyYears;
  final double weightKgMin;
  final double weightKgMax;
  final int monthlyCostEur;
  final List<String> commonHealthIssues;
  final List<String> traits;
  final String? imageUrl;

  /// Erzeugt eine Rasse aus einer JSON-Map (gebuendelte Daten oder Firestore).
  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'] as String,
      name: json['name'] as String,
      origin: json['origin'] as String,
      size: DogSize.values.byName(json['size'] as String),
      temperament: json['temperament'] as String,
      description: json['description'] as String,
      energyLevel: ActivityLevel.values.byName(json['energyLevel'] as String),
      grooming: json['grooming'] as int,
      shedding: json['shedding'] as int,
      childFriendliness: json['childFriendliness'] as int,
      beginnerFriendliness: json['beginnerFriendliness'] as int,
      trainability: json['trainability'] as int,
      exerciseNeed: json['exerciseNeed'] as int,
      lifeExpectancyYears: json['lifeExpectancyYears'] as int,
      weightKgMin: (json['weightKgMin'] as num).toDouble(),
      weightKgMax: (json['weightKgMax'] as num).toDouble(),
      monthlyCostEur: json['monthlyCostEur'] as int,
      commonHealthIssues:
          (json['commonHealthIssues'] as List<dynamic>).cast<String>(),
      traits: (json['traits'] as List<dynamic>).cast<String>(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'size': size.name,
      'temperament': temperament,
      'description': description,
      'energyLevel': energyLevel.name,
      'grooming': grooming,
      'shedding': shedding,
      'childFriendliness': childFriendliness,
      'beginnerFriendliness': beginnerFriendliness,
      'trainability': trainability,
      'exerciseNeed': exerciseNeed,
      'lifeExpectancyYears': lifeExpectancyYears,
      'weightKgMin': weightKgMin,
      'weightKgMax': weightKgMax,
      'monthlyCostEur': monthlyCostEur,
      'commonHealthIssues': commonHealthIssues,
      'traits': traits,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id];
}
