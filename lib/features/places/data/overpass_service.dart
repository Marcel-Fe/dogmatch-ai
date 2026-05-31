import 'dart:convert';
import 'dart:math' as math;

import 'package:dogmatch_ai/features/places/domain/place.dart';
import 'package:http/http.dart' as http;

/// Fragt Orte (Tieraerzte, Kotbeutel-Spender) aus OpenStreetMap ueber die
/// kostenlose Overpass-API ab. Kein API-Key noetig, CORS ist erlaubt.
class OverpassService {
  OverpassService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _endpoint = 'https://overpass-api.de/api/interpreter';

  /// Sucht Orte und erweitert den Radius automatisch, bis Treffer kommen.
  /// So funktioniert die Suche auch auf dem Land, wo der naechste Tierarzt
  /// weiter weg sein kann. Liefert die Treffer und den genutzten Radius (km).
  Future<({List<Place> places, int radiusKm})> searchNearby({
    required PlaceCategory category,
    required double latitude,
    required double longitude,
  }) async {
    // Je nach Kategorie unterschiedlich weit eskalieren: Tieraerzte koennen
    // auf dem Land weit weg sein, Kotbeutel-Spender sind nur lokal sinnvoll.
    final radii = switch (category) {
      PlaceCategory.vet => const [12000, 30000, 60000],
      PlaceCategory.shelter => const [15000, 40000, 80000],
      PlaceCategory.dogPark ||
      PlaceCategory.petShop =>
        const [8000, 20000, 40000],
      PlaceCategory.poopBag => const [10000, 25000],
    };
    for (final r in radii) {
      final result = await search(
        category: category,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: r,
      );
      if (result.isNotEmpty || r == radii.last) {
        return (places: result, radiusKm: r ~/ 1000);
      }
    }
    return (places: const <Place>[], radiusKm: radii.last ~/ 1000);
  }

  /// Sucht Orte einer Kategorie im Umkreis [radiusMeters] um die Position.
  /// Ergebnis ist nach Entfernung sortiert.
  Future<List<Place>> search({
    required PlaceCategory category,
    required double latitude,
    required double longitude,
    int radiusMeters = 8000,
  }) async {
    final around = '(around:$radiusMeters,$latitude,$longitude)';
    final filter = '["${category.osmKey}"="${category.osmValue}"]';
    final query = '[out:json][timeout:25];'
        '(node$filter$around;way$filter$around;);'
        'out center tags;';

    final uri = Uri.parse('$_endpoint?data=${Uri.encodeComponent(query)}');
    final response = await _client.get(uri).timeout(
          const Duration(seconds: 30),
        );
    if (response.statusCode != 200) {
      throw Exception('Overpass HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = (json['elements'] as List?) ?? const [];
    final places = <Place>[];

    for (final raw in elements) {
      if (raw is! Map) continue;
      final tags = (raw['tags'] as Map?)?.cast<String, dynamic>() ?? const {};

      // Koordinaten: node hat lat/lon direkt, way hat center.
      final lat = (raw['lat'] as num?)?.toDouble() ??
          ((raw['center'] as Map?)?['lat'] as num?)?.toDouble();
      final lon = (raw['lon'] as num?)?.toDouble() ??
          ((raw['center'] as Map?)?['lon'] as num?)?.toDouble();
      if (lat == null || lon == null) continue;

      final name = (tags['name'] as String?)?.trim();
      final phone = (tags['phone'] ?? tags['contact:phone']) as String?;
      final website =
          (tags['website'] ?? tags['contact:website']) as String?;
      final street = _composeStreet(tags);
      final emergency = (tags['emergency'] as String?) == 'yes';

      places.add(
        Place(
          id: '${raw['type']}/${raw['id']}',
          name: name == null || name.isEmpty ? category.fallbackName : name,
          category: category,
          latitude: lat,
          longitude: lon,
          distanceKm: _haversineKm(latitude, longitude, lat, lon),
          phone: phone?.trim(),
          website: website?.trim(),
          street: street,
          isEmergency: emergency,
        ),
      );
    }

    places.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return places;
  }

  String? _composeStreet(Map<String, dynamic> tags) {
    final street = tags['addr:street'] as String?;
    final number = tags['addr:housenumber'] as String?;
    final city = tags['addr:city'] as String?;
    final parts = <String>[];
    if (street != null) {
      parts.add(number != null ? '$street $number' : street);
    }
    if (city != null) parts.add(city);
    return parts.isEmpty ? null : parts.join(', ');
  }

  /// Luftlinie zwischen zwei Koordinaten in Kilometern (Haversine).
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthKm = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _rad(double deg) => deg * math.pi / 180.0;
}
