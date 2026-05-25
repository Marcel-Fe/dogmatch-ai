import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart' show DogsState, dogsProvider;
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Gesundheits-Kalender. Zwei Abschnitte: bevorstehende und vergangene
/// Termine. Pro Eintrag: Hund, Typ, Datum, optional Notiz, Haken zum
/// Abhaken, Loeschen.
class HealthCalendarScreen extends ConsumerWidget {
  const HealthCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(healthProvider);
    final dogsState = ref.watch(dogsProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addHealthEvent),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Termin hinzufuegen'),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (events) {
          if (events.isEmpty) {
            return EmptyView(
              icon: Icons.event_note_outlined,
              title: 'Noch keine Termine',
              message:
                  'Lege Impfungen, Entwurmungen oder Tierarzt-Besuche an - '
                  'die App erinnert dich an die naechsten Faelligkeiten.',
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.addHealthEvent),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Ersten Termin anlegen'),
              ),
            );
          }

          final upcoming = events.where((e) => e.isUpcoming).toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          final past = events.where((e) => !e.isUpcoming).toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (upcoming.isNotEmpty) ...[
                _SectionHeader(label: 'Bevorstehend (${upcoming.length})'),
                for (final e in upcoming)
                  _EventTile(event: e, dogName: _dogName(dogsState, e.dogId)),
                const SizedBox(height: AppSpacing.xl),
              ],
              if (past.isNotEmpty) ...[
                _SectionHeader(label: 'Vergangen (${past.length})'),
                for (final e in past)
                  _EventTile(event: e, dogName: _dogName(dogsState, e.dogId)),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _dogName(DogsState? dogsState, String dogId) {
  if (dogsState == null) return 'Unbekannt';
  for (final d in dogsState.dogs) {
    if (d.id == dogId) return d.name;
  }
  return 'Unbekannt';
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.sm),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({required this.event, this.dogName});

  final HealthEvent event;
  final String? dogName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateStr = DateFormat.yMMMMd('de').format(event.date);
    final daysAway = event.date
        .difference(DateTime.now())
        .inDays;
    final relative = daysAway == 0
        ? 'heute'
        : daysAway > 0
            ? 'in $daysAway Tagen'
            : 'vor ${-daysAway} Tagen';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor(event.type, theme).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                _iconFor(event.type),
                color: _iconColor(event.type, theme),
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      decoration: event.done
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${event.type.label} · ${dogName ?? "Unbekannt"}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '$dateStr · $relative',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (event.notes != null && event.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        event.notes!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: event.done ? 'Erledigt' : 'Als erledigt markieren',
                  icon: Icon(
                    event.done
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: event.done ? theme.colorScheme.primary : null,
                  ),
                  onPressed: () =>
                      ref.read(healthProvider.notifier).toggleDone(event.id),
                ),
                IconButton(
                  tooltip: 'Loeschen',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      ref.read(healthProvider.notifier).removeEvent(event.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(HealthEventType type) {
    switch (type) {
      case HealthEventType.vaccination:
        return Icons.vaccines_outlined;
      case HealthEventType.deworming:
        return Icons.medication_outlined;
      case HealthEventType.vetVisit:
        return Icons.medical_services_outlined;
      case HealthEventType.fleaTick:
        return Icons.bug_report_outlined;
      case HealthEventType.grooming:
        return Icons.content_cut_rounded;
      case HealthEventType.training:
        return Icons.school_outlined;
      case HealthEventType.other:
        return Icons.event_note_outlined;
    }
  }

  Color _iconColor(HealthEventType type, ThemeData theme) {
    switch (type) {
      case HealthEventType.vaccination:
      case HealthEventType.vetVisit:
        return Colors.redAccent;
      case HealthEventType.deworming:
      case HealthEventType.fleaTick:
        return Colors.orange;
      case HealthEventType.grooming:
        return Colors.teal;
      case HealthEventType.training:
        return theme.colorScheme.primary;
      case HealthEventType.other:
        return theme.colorScheme.outline;
    }
  }
}
