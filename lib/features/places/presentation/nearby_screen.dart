import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/places/data/geo_service.dart';
import 'package:dogmatch_ai/features/places/data/overpass_service.dart';
import 'package:dogmatch_ai/features/places/domain/place.dart';
import 'package:flutter/material.dart';

/// Umgebungs-Suche: Tieraerzte, Kliniken und Kotbeutel-Spender in der Naehe
/// auf Basis von OpenStreetMap (kostenlos). Anrufen und Webseite oeffnen
/// direkt aus der Liste.
class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  final _geo = GeoService();
  final _overpass = OverpassService();

  PlaceCategory _category = PlaceCategory.vet;
  bool _loading = false;
  String? _error;
  List<Place>? _places;
  GeoPosition? _position;

  Future<void> _findHere() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final pos = _position ?? await _geo.getCurrentPosition();
    if (pos == null) {
      setState(() {
        _loading = false;
        _error = 'Standort nicht verfuegbar. Bitte erlaube den Zugriff auf '
            'deinen Standort im Browser und versuche es erneut. Am Handy '
            'klappt das nur ueber eine sichere (https) Verbindung.';
      });
      return;
    }
    _position = pos;
    await _load(pos);
  }

  Future<void> _load(GeoPosition pos) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _overpass.search(
        category: _category,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      setState(() {
        _places = result;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Die Umgebungs-Daten konnten gerade nicht geladen werden. '
            'Bitte versuche es in einem Moment erneut.';
      });
    }
  }

  void _switchCategory(PlaceCategory cat) {
    if (cat == _category) return;
    setState(() {
      _category = cat;
      _places = null;
    });
    if (_position != null) _load(_position!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('In der Naehe')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          SegmentedButton<PlaceCategory>(
            segments: const [
              ButtonSegment(
                value: PlaceCategory.vet,
                label: Text('Tieraerzte'),
                icon: Icon(Icons.local_hospital_rounded),
              ),
              ButtonSegment(
                value: PlaceCategory.poopBag,
                label: Text('Kotbeutel'),
                icon: Icon(Icons.delete_outline_rounded),
              ),
            ],
            selected: {_category},
            onSelectionChanged: (s) => _switchCategory(s.first),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (_places == null && !_loading && _error == null)
            _IntroCard(theme: theme, onFind: _findHere),

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),

          if (_error != null)
            _MessageCard(
              theme: theme,
              icon: Icons.location_off_rounded,
              text: _error!,
              onRetry: _findHere,
            ),

          if (_places != null && !_loading) ...[
            if (_places!.isEmpty)
              _MessageCard(
                theme: theme,
                icon: Icons.search_off_rounded,
                text: _category == PlaceCategory.vet
                    ? 'In deiner Naehe sind keine Tieraerzte in OpenStreetMap '
                        'eingetragen. Das heisst nicht, dass es keine gibt - '
                        'die freien Daten sind oft unvollstaendig.'
                    : 'Keine Kotbeutel-Spender in OpenStreetMap gefunden. '
                        'Diese sind nur selten erfasst.',
                onRetry: _findHere,
              )
            else ...[
              Text(
                '${_places!.length} Treffer in der Naehe',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final p in _places!)
                _PlaceCard(place: p, theme: theme, onOpen: _geo.openExternal),
            ],
          ],

          const SizedBox(height: AppSpacing.lg),
          Text(
            'Datenquelle: OpenStreetMap-Mitwirkende. Angaben ohne Gewaehr - '
            'pruefe Oeffnungszeiten und Notdienst immer telefonisch.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.theme, required this.onFind});

  final ThemeData theme;
  final VoidCallback onFind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.near_me_rounded, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text('Hilfe in der Naehe finden',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Wir nutzen deinen Standort einmalig, um Tieraerzte, Kliniken und '
            'Kotbeutel-Spender in der Umgebung zu zeigen. Dein Standort wird '
            'nicht gespeichert.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onFind,
            icon: const Icon(Icons.my_location_rounded),
            label: const Text('In meiner Naehe suchen'),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.theme,
    required this.icon,
    required this.text,
    required this.onRetry,
  });

  final ThemeData theme;
  final IconData icon;
  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.place,
    required this.theme,
    required this.onOpen,
  });

  final Place place;
  final ThemeData theme;
  final void Function(String url) onOpen;

  @override
  Widget build(BuildContext context) {
    final distance = place.distanceKm < 1
        ? '${(place.distanceKm * 1000).round()} m'
        : '${place.distanceKm.toStringAsFixed(1)} km';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(place.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Text(distance,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            if (place.isEmergency) ...[
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text('Notdienst',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
            if (place.street != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(place.street!, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (place.phone != null)
                  FilledButton.icon(
                    onPressed: () => onOpen('tel:${place.phone}'),
                    icon: const Icon(Icons.call_rounded, size: 18),
                    label: const Text('Anrufen'),
                  ),
                if (place.website != null)
                  OutlinedButton.icon(
                    onPressed: () => onOpen(place.website!),
                    icon: const Icon(Icons.language_rounded, size: 18),
                    label: const Text('Webseite'),
                  ),
                OutlinedButton.icon(
                  onPressed: () => onOpen(
                    'https://www.google.com/maps/search/?api=1&query='
                    '${place.latitude},${place.longitude}',
                  ),
                  icon: const Icon(Icons.map_rounded, size: 18),
                  label: const Text('Karte'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
