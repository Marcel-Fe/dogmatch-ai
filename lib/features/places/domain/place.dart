import 'package:equatable/equatable.dart';

/// Art eines gefundenen Ortes in der Umgebung.
enum PlaceCategory {
  vet('Tieraerzte & Kliniken', 'amenity', 'veterinary'),
  poopBag('Kotbeutel-Spender', 'vending', 'excrement_bags');

  const PlaceCategory(this.label, this.osmKey, this.osmValue);

  final String label;
  final String osmKey;
  final String osmValue;
}

/// Ein Ort aus OpenStreetMap (Tierarzt, Klinik, Kotbeutel-Spender).
class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    this.phone,
    this.website,
    this.street,
    this.isEmergency = false,
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final double latitude;
  final double longitude;

  /// Luftlinie zum aktuellen Standort in Kilometern.
  final double distanceKm;

  final String? phone;
  final String? website;
  final String? street;

  /// True, wenn der Ort als Notdienst markiert ist (OSM `emergency=yes`).
  final bool isEmergency;

  @override
  List<Object?> get props => [id];
}
