import 'dart:convert';

import 'package:http/http.dart' as http;

/// Aktuelles Wetter am Standort - aus der kostenlosen Open-Meteo-API
/// (kein API-Key, CORS-frei). Wird im Dashboard fuer den Gassi-Tipp genutzt.
class Weather {
  const Weather({
    required this.temperatureC,
    required this.code,
    required this.isDay,
    this.maxTempC,
    this.minTempC,
    this.precipitationProb,
  });

  final double temperatureC;
  final int code; // WMO-Wettercode
  final bool isDay;
  final double? maxTempC;
  final double? minTempC;
  final int? precipitationProb; // % Regenwahrscheinlichkeit heute

  /// Kurzbeschreibung des WMO-Codes auf Deutsch.
  String get description {
    if (code == 0) return 'Klar';
    if (code <= 2) return 'Leicht bewoelkt';
    if (code == 3) return 'Bewoelkt';
    if (code <= 48) return 'Neblig';
    if (code <= 57) return 'Nieselregen';
    if (code <= 67) return 'Regen';
    if (code <= 77) return 'Schnee';
    if (code <= 82) return 'Regenschauer';
    if (code <= 86) return 'Schneeschauer';
    return 'Gewitter';
  }

  bool get isRainy => (code >= 51 && code <= 67) || (code >= 80 && code <= 99);
  bool get isSnowy => (code >= 71 && code <= 77) || (code >= 85 && code <= 86);
}

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Weather?> fetch(double lat, double lon) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lon'
      '&current=temperature_2m,weather_code,is_day'
      '&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=auto&forecast_days=1',
    );
    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final cur = json['current'] as Map<String, dynamic>?;
      if (cur == null) return null;
      final daily = json['daily'] as Map<String, dynamic>?;

      double? firstNum(dynamic list) {
        if (list is List && list.isNotEmpty && list.first is num) {
          return (list.first as num).toDouble();
        }
        return null;
      }

      return Weather(
        temperatureC: (cur['temperature_2m'] as num).toDouble(),
        code: (cur['weather_code'] as num).toInt(),
        isDay: (cur['is_day'] as num?)?.toInt() == 1,
        maxTempC: firstNum(daily?['temperature_2m_max']),
        minTempC: firstNum(daily?['temperature_2m_min']),
        precipitationProb:
            firstNum(daily?['precipitation_probability_max'])?.toInt(),
      );
    } catch (_) {
      return null;
    }
  }
}
