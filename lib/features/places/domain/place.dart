import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Art eines gefundenen Ortes in der Umgebung.
enum PlaceCategory {
  vet('Tieraerzte', 'amenity', 'veterinary', Icons.local_hospital_rounded,
      'Tierarztpraxis'),
  dogPark('Hundewiesen', 'leisure', 'dog_park', Icons.park_rounded,
      'Hundewiese / Hundeauslauf'),
  petShop('Tierhandlung', 'shop', 'pet', Icons.storefront_rounded,
      'Tierhandlung'),
  shelter('Tierheime', 'amenity', 'animal_shelter', Icons.pets_rounded,
      'Tierheim'),
  poopBag('Kotbeutel', 'vending', 'excrement_bags',
      Icons.delete_outline_rounded, 'Kotbeutel-Spender');

  const PlaceCategory(
    this.label,
    this.osmKey,
    this.osmValue,
    this.icon,
    this.fallbackName,
  );

  final String label;
  final String osmKey;
  final String osmValue;
  final IconData icon;

  /// Anzeigename, wenn ein Ort in OSM keinen Namen hat.
  final String fallbackName;
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
