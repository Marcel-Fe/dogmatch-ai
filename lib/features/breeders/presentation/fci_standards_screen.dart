import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/utils/external_link.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Die 10 offiziellen FCI-Gruppen (+ Sammelkategorie). Reihenfolge = Anzeige.
const List<String> _kGroupOrder = [
  'g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7', 'g8', 'g9', 'g10', 'other',
];

/// (Kurzname, Beschreibung) je Gruppe - aus den offiziellen FCI-Gruppen.
const Map<String, (String, String)> _kGroups = {
  'g1': ('Gruppe 1', 'Hüte- und Treibhunde'),
  'g2': ('Gruppe 2', 'Pinscher, Schnauzer, Molosser & Sennenhunde'),
  'g3': ('Gruppe 3', 'Terrier'),
  'g4': ('Gruppe 4', 'Dachshunde'),
  'g5': ('Gruppe 5', 'Spitze und Hunde vom Urtyp'),
  'g6': ('Gruppe 6', 'Lauf- und Schweißhunde'),
  'g7': ('Gruppe 7', 'Vorstehhunde'),
  'g8': ('Gruppe 8', 'Apportier-, Stöber- und Wasserhunde'),
  'g9': ('Gruppe 9', 'Gesellschafts- und Begleithunde'),
  'g10': ('Gruppe 10', 'Windhunde'),
  'other': ('Ohne FCI-Gruppe', 'Mischlinge & (noch) nicht anerkannte Rassen'),
};

String _groupKeyOf(DogBreed b) {
  final raw = b.fciGroup;
  if (raw == null) return 'other';
  final m = RegExp(r'Gruppe\s*(\d+)').firstMatch(raw);
  if (m == null) return 'other';
  final key = 'g${m.group(1)}';
  return _kGroups.containsKey(key) ? key : 'other';
}

/// FCI-Standards: alle Rassen nach den 10 FCI-Gruppen kategorisiert, mit
/// Suche und Standard-Kurzprofil. Der vollstaendige, offizielle Standardtext
/// liegt rechtlich bei der FCI - die App zeigt ein Strukturprofil und
/// verlinkt direkt auf das offizielle Dokument.
class FciStandardsScreen extends ConsumerStatefulWidget {
  const FciStandardsScreen({super.key});

  @override
  ConsumerState<FciStandardsScreen> createState() => _FciStandardsScreenState();
}

class _FciStandardsScreenState extends ConsumerState<FciStandardsScreen> {
  String _query = '';
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final breedsAsync = ref.watch(breedsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FCI-Standards')),
      body: breedsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (breeds) {
          final q = _query.trim().toLowerCase();
          final sorted = [...breeds]..sort((a, b) => a.name.compareTo(b.name));

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _IntroBox(theme: theme),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rasse suchen',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (q.isNotEmpty)
                ..._buildSearchResults(sorted, q, theme)
              else
                ..._buildGroups(sorted, theme),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildSearchResults(
      List<DogBreed> sorted, String q, ThemeData theme) {
    final hits = sorted
        .where((b) => b.name.toLowerCase().contains(q))
        .toList(growable: false);
    if (hits.isEmpty) {
      return [
        Text('Keine Rasse zu "$q" gefunden.',
            style: theme.textTheme.bodyMedium),
      ];
    }
    return [
      Text('${hits.length} Treffer', style: theme.textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      for (final b in hits)
        _BreedTile(
          breed: b,
          groupLabel: _kGroups[_groupKeyOf(b)]!.$1,
          onTap: () => _openSheet(b),
        ),
    ];
  }

  List<Widget> _buildGroups(List<DogBreed> sorted, ThemeData theme) {
    final byGroup = <String, List<DogBreed>>{};
    for (final b in sorted) {
      byGroup.putIfAbsent(_groupKeyOf(b), () => []).add(b);
    }
    final widgets = <Widget>[];
    for (final key in _kGroupOrder) {
      final list = byGroup[key];
      if (list == null || list.isEmpty) continue;
      final g = _kGroups[key]!;
      final open = _expanded.contains(key);
      widgets.add(_GroupHeader(
        number: g.$1,
        name: g.$2,
        count: list.length,
        open: open,
        theme: theme,
        onTap: () => setState(() {
          if (open) {
            _expanded.remove(key);
          } else {
            _expanded.add(key);
          }
        }),
      ));
      widgets.add(
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: open
              ? Column(
                  children: [
                    for (final b in list)
                      _BreedTile(
                        breed: b,
                        groupLabel: null,
                        onTap: () => _openSheet(b),
                      ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      );
      widgets.add(const SizedBox(height: AppSpacing.sm));
    }
    return widgets;
  }

  void _openSheet(DogBreed breed) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _StandardSheet(breed: breed),
    );
  }
}

class _IntroBox extends StatelessWidget {
  const _IntroBox({required this.theme});

  final ThemeData theme;

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
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Rassestandards nach FCI',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Jede Rasse gehoert zu einer der 10 FCI-Gruppen. Hier findest du '
            'zu jeder Rasse ein Standard-Kurzprofil - tippe eine Rasse an. '
            'Den vollstaendigen, offiziellen Standard fuehrt die FCI; er ist '
            'pro Rasse direkt verlinkt.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.number,
    required this.name,
    required this.count,
    required this.open,
    required this.onTap,
    required this.theme,
  });

  final String number;
  final String name;
  final int count;
  final bool open;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$number  ·  $count Rassen',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(name, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(open
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded),
          ],
        ),
      ),
    );
  }
}

class _BreedTile extends StatelessWidget {
  const _BreedTile({
    required this.breed,
    required this.groupLabel,
    required this.onTap,
  });

  final DogBreed breed;
  final String? groupLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sub = groupLabel != null
        ? '$groupLabel · ${breed.origin}'
        : '${breed.size.label} · ${breed.origin}';
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      leading: Icon(Icons.pets_rounded, color: theme.colorScheme.primary),
      title: Text(breed.name),
      subtitle: Text(sub, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

/// Standard-Kurzprofil + Link auf den offiziellen FCI-Standard.
class _StandardSheet extends StatelessWidget {
  const _StandardSheet({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final key = _groupKeyOf(breed);
    final g = _kGroups[key]!;
    final fciSearch =
        'https://www.google.com/search?q=${Uri.encodeComponent('FCI Standard ${breed.name} site:fci.be')}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text(breed.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text('${g.$1} – ${g.$2}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: AppSpacing.md),
            _kv('Ursprung', breed.origin, theme),
            _kv('Groesse', breed.size.label, theme),
            _kv('Gewicht',
                '${breed.weightKgMin.toInt()}–${breed.weightKgMax.toInt()} kg',
                theme),
            if (breed.coatType != null && breed.coatType!.isNotEmpty)
              _kv('Fell', breed.coatType!, theme),
            _kv('Lebenserwartung', '${breed.lifeExpectancyYears} Jahre', theme),
            _kv('Wesen', breed.temperament, theme),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Hinweis: Dies ist ein Kurzprofil aus den App-Daten. Der '
              'verbindliche, vollstaendige Rassestandard wird von der FCI '
              'gefuehrt.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => openExternalLink(fciSearch),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Offiziellen FCI-Standard oeffnen'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('${AppRoutes.breedDetail}/${breed.id}');
                },
                icon: const Icon(Icons.pets_rounded, size: 18),
                label: const Text('Zum Rasseprofil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
          ),
          Expanded(
            child: Text(value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
