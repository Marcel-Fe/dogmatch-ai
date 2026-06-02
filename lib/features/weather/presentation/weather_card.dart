import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/places/data/geo_service.dart';
import 'package:dogmatch_ai/features/weather/data/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holt einmalig Standort (Browser-Geolocation) + Wetter (Open-Meteo).
/// Liefert null, wenn der Nutzer den Standort ablehnt oder etwas schiefgeht -
/// dann zeigt die Karte gar nichts (kein Stoerer).
final weatherProvider = FutureProvider.autoDispose<Weather?>((ref) async {
  final pos = await GeoService().getCurrentPosition();
  if (pos == null) return null;
  return WeatherService().fetch(pos.latitude, pos.longitude);
});

/// Kompakte Wetter-Karte mit Gassi-Tipp - "soll ich jetzt raus?".
/// Der Hundename personalisiert den Tipp.
class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key, this.dogName});

  final String? dogName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(weatherProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (w) {
        if (w == null) return const SizedBox.shrink();
        final name = dogName ?? 'deinen Hund';
        final tip = _gassiTip(w, name);
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _bgColors(w),
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              Icon(_icon(w), color: Colors.white, size: 44),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${w.temperatureC.round()}°',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            w.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        if (w.maxTempC != null && w.minTempC != null)
                          Text(
                            '${w.maxTempC!.round()}° / ${w.minTempC!.round()}°',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> _bgColors(Weather w) {
    if (w.isRainy) return [const Color(0xFF5C6BC0), const Color(0xFF3949AB)];
    if (w.isSnowy) return [const Color(0xFF78909C), const Color(0xFF546E7A)];
    if (!w.isDay) return [const Color(0xFF3949AB), const Color(0xFF1A237E)];
    if (w.code == 0) return [const Color(0xFFFFB74D), const Color(0xFFFB8C00)];
    return [const Color(0xFF4FC3F7), const Color(0xFF0288D1)];
  }

  IconData _icon(Weather w) {
    if (w.isRainy) return Icons.umbrella_rounded;
    if (w.isSnowy) return Icons.ac_unit_rounded;
    if (!w.isDay) return Icons.nightlight_round;
    if (w.code == 0) return Icons.wb_sunny_rounded;
    if (w.code == 3) return Icons.cloud_rounded;
    return Icons.cloud_queue_rounded;
  }

  String _gassiTip(Weather w, String name) {
    if (w.isRainy) {
      return 'Es regnet - nimm fuer $name ein Handtuch mit. Kurze Runde reicht, '
          'danach Nasenarbeit drinnen.';
    }
    if (w.isSnowy) {
      return 'Schnee! Achte auf $name-Pfoten (Streusalz) - nach der Runde '
          'Pfoten abspuelen.';
    }
    if (w.temperatureC >= 25) {
      return 'Warm - geh mit $name frueh oder spaet raus und teste den Asphalt '
          'mit der Handflaeche (5-Sekunden-Test).';
    }
    if (w.temperatureC <= 0) {
      return 'Frostig - kurze, aktive Runden halten $name warm.';
    }
    final rain = w.precipitationProb;
    if (rain != null && rain >= 50) {
      return 'Aktuell trocken, aber $rain% Regenrisiko heute - Regenjacke '
          'einpacken fuer die Runde mit $name.';
    }
    return 'Gutes Gassi-Wetter fuer $name - viel Spass bei der Runde!';
  }
}
