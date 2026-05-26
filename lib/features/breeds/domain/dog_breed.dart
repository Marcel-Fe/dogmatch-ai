import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_insurance.dart';
import 'package:dogmatch_ai/features/breeds/domain/country_breed_info.dart';
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
    this.imageAsset,
    this.countryInfo = const {},
    this.fciGroup,
    this.coatType,
    this.idealOwner,
    this.dailyExerciseHours,
    this.noiseLevel,
    this.apartmentSuitable,
    this.goodWithCats,
    this.typicalTasks = const [],
    this.insurance,
    this.acquisitionCostEurMin,
    this.acquisitionCostEurMax,
    this.dailyFoodCostEur,
    this.vetCostPerYearEur,
    this.careTips = const [],
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

  /// Externe Bild-URL (z. B. Wikimedia Commons). Wird benutzt, wenn
  /// [imageAsset] leer ist - lazy geladen, braucht Internet.
  final String? imageUrl;

  /// Lokaler Bundle-Asset-Pfad, z. B. `assets/images/breeds/labrador.jpg`.
  /// Hat Vorrang vor [imageUrl] - kein Netz noetig, sofort scharf.
  final String? imageAsset;

  /// Land-spezifische Hinweise, indexiert nach [Country.code] (z. B. "DE").
  /// Default: leere Map - dann zeigt die UI keinen Laender-Block.
  final Map<String, CountryBreedInfo> countryInfo;

  /// FCI-Gruppe (1-10) als Klartext, z. B. "Gruppe 1 - Huetehunde".
  final String? fciGroup;

  /// Felltyp, z. B. "Kurzhaar", "Doppeltes Stockhaar", "Lockig".
  final String? coatType;

  /// Empfohlener Halter-Typ, z. B. "Aktive Familien", "Erstbesitzer".
  final String? idealOwner;

  /// Empfohlene taegliche Aktivitaet in Stunden.
  final double? dailyExerciseHours;

  /// Bell-Neigung 1 (leise) - 5 (laut).
  final int? noiseLevel;

  /// Eignung fuer Wohnungshaltung.
  final bool? apartmentSuitable;

  /// Vertraegt sich gut mit Katzen.
  final bool? goodWithCats;

  /// Typische historische / heute uebliche Aufgaben (z. B. "Hueten",
  /// "Apportieren", "Begleithund").
  final List<String> typicalTasks;

  /// Versicherungs-Richtwerte und Hinweise pro Monat.
  final BreedInsurance? insurance;

  /// Anschaffungskosten beim seriösen Züchter (EUR-Spanne).
  final int? acquisitionCostEurMin;
  final int? acquisitionCostEurMax;

  /// Tagesfutter-Kosten in EUR (Hochwertiges Trocken-/Nassfutter).
  final double? dailyFoodCostEur;

  /// Tierarzt-Routine pro Jahr (Impfung, Check-Up, Wurmkur) - keine Notfall-OPs.
  final int? vetCostPerYearEur;

  /// Konkrete Pflege- und Halterungs-Tipps fuer diese Rasse.
  final List<String> careTips;

  /// Erzeugt eine Rasse aus einer JSON-Map (gebuendelte Daten oder Firestore).
  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'] as String,
      name: json['name'] as String,
      origin: json['origin'] as String,
      size: _parseSize(json['size'] as String),
      temperament: json['temperament'] as String,
      description: json['description'] as String,
      energyLevel: _parseEnergy(json['energyLevel'] as String),
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
      imageAsset: json['imageAsset'] as String?,
      countryInfo: _parseCountryInfo(json['countryInfo']),
      fciGroup: json['fciGroup'] as String?,
      coatType: json['coatType'] as String?,
      idealOwner: json['idealOwner'] as String?,
      dailyExerciseHours:
          (json['dailyExerciseHours'] as num?)?.toDouble(),
      noiseLevel: (json['noiseLevel'] as num?)?.toInt(),
      apartmentSuitable: json['apartmentSuitable'] as bool?,
      goodWithCats: json['goodWithCats'] as bool?,
      typicalTasks:
          (json['typicalTasks'] as List?)?.cast<String>() ?? const [],
      insurance: json['insurance'] is Map
          ? BreedInsurance.fromJson(
              (json['insurance'] as Map).cast<String, dynamic>(),
            )
          : null,
      acquisitionCostEurMin:
          (json['acquisitionCostEurMin'] as num?)?.toInt(),
      acquisitionCostEurMax:
          (json['acquisitionCostEurMax'] as num?)?.toInt(),
      dailyFoodCostEur: (json['dailyFoodCostEur'] as num?)?.toDouble(),
      vetCostPerYearEur: (json['vetCostPerYearEur'] as num?)?.toInt(),
      careTips: (json['careTips'] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Robustes Parsing von Size-Werten - akzeptiert Enum-Namen sowie ein
  /// paar Synonyme aus aelteren Daten.
  static DogSize _parseSize(String raw) {
    final v = raw.toLowerCase();
    for (final s in DogSize.values) {
      if (s.name == v) return s;
    }
    return DogSize.medium;
  }

  /// Robustes Parsing von ActivityLevel - akzeptiert Synonyme wie
  /// "medium" (-> moderate), "very_high"/"very-high" (-> veryHigh).
  static ActivityLevel _parseEnergy(String raw) {
    final v = raw.toLowerCase().replaceAll('-', '').replaceAll('_', '');
    for (final a in ActivityLevel.values) {
      if (a.name.toLowerCase() == v) return a;
    }
    switch (v) {
      case 'medium':
      case 'mid':
        return ActivityLevel.moderate;
      case 'veryhigh':
      case 'extreme':
        return ActivityLevel.veryHigh;
    }
    return ActivityLevel.moderate;
  }

  static Map<String, CountryBreedInfo> _parseCountryInfo(dynamic raw) {
    if (raw is! Map) return const {};
    final result = <String, CountryBreedInfo>{};
    raw.forEach((key, value) {
      if (key is String && value is Map) {
        result[key] = CountryBreedInfo.fromJson(
          value.cast<String, dynamic>(),
        );
      }
    });
    return result;
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
      'imageAsset': imageAsset,
      'countryInfo': {
        for (final entry in countryInfo.entries)
          entry.key: entry.value.toJson(),
      },
      'fciGroup': fciGroup,
      'coatType': coatType,
      'idealOwner': idealOwner,
      'dailyExerciseHours': dailyExerciseHours,
      'noiseLevel': noiseLevel,
      'apartmentSuitable': apartmentSuitable,
      'goodWithCats': goodWithCats,
      'typicalTasks': typicalTasks,
      'insurance': insurance?.toJson(),
      'acquisitionCostEurMin': acquisitionCostEurMin,
      'acquisitionCostEurMax': acquisitionCostEurMax,
      'dailyFoodCostEur': dailyFoodCostEur,
      'vetCostPerYearEur': vetCostPerYearEur,
      'careTips': careTips,
    };
  }

  @override
  List<Object?> get props => [id];
}
