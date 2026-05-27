import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/utils/external_link.dart';
import 'package:dogmatch_ai/features/breeders/data/asset_breeder_repository.dart';
import 'package:dogmatch_ai/features/breeders/domain/breeder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Zuechter-Finder. Zeigt kuratiertes Verzeichnis von VDH/FCI-anerkannten
/// Rassezuchtvereinen und Dachverbaenden mit Filter nach Stichwort.
class BreederFinderScreen extends ConsumerStatefulWidget {
  const BreederFinderScreen({super.key});

  @override
  ConsumerState<BreederFinderScreen> createState() =>
      _BreederFinderScreenState();
}

class _BreederFinderScreenState extends ConsumerState<BreederFinderScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final breedersAsync = ref.watch(breedersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Seriose Zuechter finden')),
      body: breedersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (all) {
          final q = _query.trim().toLowerCase();
          final filtered = q.isEmpty
              ? all
              : all.where((b) {
                  return b.name.toLowerCase().contains(q) ||
                      b.city.toLowerCase().contains(q) ||
                      b.specialties
                          .any((s) => s.toLowerCase().contains(q)) ||
                      b.breedIds.any((id) => id.toLowerCase().contains(q));
                }).toList(growable: false);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _IntroBox(theme: theme),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rasse oder Stadt suchen',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${filtered.length} Eintrag${filtered.length == 1 ? '' : 'e'}',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final b in filtered)
                _BreederTile(breeder: b, theme: theme),
            ],
          );
        },
      ),
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
              Icon(Icons.verified_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Woran erkennst du seriose Zuechter?',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _Tip(text: 'Verein im VDH/FCI/OeKV/SKG (Dachverbaende).', theme: theme),
          _Tip(text: 'HD/ED- und rassetypische Gesundheitstests werden vorgelegt.', theme: theme),
          _Tip(text: 'Welpen werden fruehestens mit 8 Wochen abgegeben - mit Impfpass, Chip + Papieren.', theme: theme),
          _Tip(text: 'Du darfst die Mutterhuendin sehen, die Aufzucht-Umgebung wirkt sauber + sozialisiert.', theme: theme),
          _Tip(text: 'Der Zuechter stellt selbst Fragen - wem er den Welpen anvertraut, ist ihm nicht egal.', theme: theme),
          _Tip(text: 'Verdaechtig: "Ohne Papiere, dafuer guenstig", Online-Versand, kein Besuch moeglich.', theme: theme, warn: true),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.text, required this.theme, this.warn = false});

  final String text;
  final ThemeData theme;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final color =
        warn ? Colors.orange.shade800 : theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            warn ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _BreederTile extends StatelessWidget {
  const _BreederTile({required this.breeder, required this.theme});

  final Breeder breeder;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    breeder.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (breeder.isVerified)
                  Tooltip(
                    message: 'Verifiziert',
                    child: Icon(
                      Icons.verified_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${breeder.city} (${breeder.country})',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  breeder.averageRating.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  '${breeder.experienceYears} J. Erfahrung',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(breeder.description, style: theme.textTheme.bodyMedium),
            if (breeder.specialties.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: breeder.specialties
                    .map((s) => Chip(
                          label: Text(s),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: theme.colorScheme.primary
                              .withValues(alpha: 0.08),
                        ))
                    .toList(growable: false),
              ),
            ],
            if (breeder.verificationNote.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                breeder.verificationNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (breeder.website != null && breeder.website!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonalIcon(
                onPressed: () => openExternalLink(breeder.website!),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Zur Webseite'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
