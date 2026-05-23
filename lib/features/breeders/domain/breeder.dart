import 'package:equatable/equatable.dart';

/// Eine Nutzerbewertung eines Zuechters.
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

  /// Bewertung von 1 bis 5.
  final int rating;
  final String comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id];
}

/// Ein Hundezuechter im Zuechter-Finder.
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
    this.website,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String city;

  // Koordinaten - Grundlage fuer die spaetere Geo-Umkreissuche.
  final double latitude;
  final double longitude;

  /// Ids der angebotenen Rassen (Verweis auf `DogBreed.id`).
  final List<String> breedIds;

  /// Verifizierungsstatus - nur seriöse, geprUefte Zuechter werden bevorzugt.
  final bool isVerified;
  final int experienceYears;
  final double averageRating;
  final String? website;
  final String? imageUrl;

  @override
  List<Object?> get props => [id];
}
