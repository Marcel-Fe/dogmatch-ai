import 'package:equatable/equatable.dart';

class BreederReview extends Equatable {
  const BreederReview({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id];
}

class Breeder extends Equatable {
  const Breeder({
    required this.id,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.breedIds,
    required this.isVerified,
    required this.experienceYears,
    required this.averageRating,
    this.country = 'DE',
    this.website,
    this.imageUrl,
    this.description = '',
    this.verificationNote = '',
    this.specialties = const [],
  });

  final String id;
  final String name;
  final String city;
  final String country;

  final double latitude;
  final double longitude;

  final List<String> breedIds;

  /// True = vom VDH/FCI/Dachverband anerkannt oder gepruefter Rassezuchtverein.
  final bool isVerified;
  final int experienceYears;
  final double averageRating;
  final String? website;
  final String? imageUrl;

  /// Was zeichnet diesen Zuechter aus?
  final String description;

  /// Konkrete Begruendung warum "verifiziert".
  final String verificationNote;

  /// Schwerpunkt-Rassen als Klartext-Labels.
  final List<String> specialties;

  factory Breeder.fromJson(Map<String, dynamic> json) {
    return Breeder(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String? ?? 'DE',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      breedIds:
          (json['breedIds'] as List?)?.cast<String>() ?? const <String>[],
      isVerified: json['isVerified'] as bool? ?? false,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      website: json['website'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String? ?? '',
      verificationNote: json['verificationNote'] as String? ?? '',
      specialties:
          (json['specialties'] as List?)?.cast<String>() ?? const <String>[],
    );
  }

  @override
  List<Object?> get props => [id];
}
