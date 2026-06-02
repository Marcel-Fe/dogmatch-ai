import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/presentation/documents_controller.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Digitale Hunde-Akte: buendelt Stammdaten, Gesundheitstermine und
/// Dokumente eines Hundes auf einer Seite.
class DogRecordScreen extends ConsumerStatefulWidget {
  const DogRecordScreen({super.key});

  @override
  ConsumerState<DogRecordScreen> createState() => _DogRecordScreenState();
}

class _DogRecordScreenState extends ConsumerState<DogRecordScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dogsState = ref.watch(dogsProvider).value;
    final dogs = dogsState?.dogs ?? const <Dog>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Hunde-Akte')),
      body: dogs.isEmpty
          ? _EmptyDogs(theme: theme)
          : _buildForDog(context, dogs),
    );
  }

  Widget _buildForDog(BuildContext context, List<Dog> dogs) {
    final theme = Theme.of(context);
    final activeId = ref.watch(dogsProvider).value?.activeDogId;
    final currentId = _selectedId ?? activeId ?? dogs.first.id;
    final dog = dogs.firstWhere((d) => d.id == currentId, orElse: () => dogs.first);

    final events = (ref.watch(healthProvider).value ?? const <HealthEvent>[])
        .where((e) => e.dogId == dog.id)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final upcoming = events.where((e) => e.isUpcoming).toList();
    final past = events.where((e) => !e.isUpcoming).toList().reversed.toList();

    final docs = (ref.watch(documentsProvider).value ?? const <DogDocument>[])
        .where((d) => d.dogId == dog.id)
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (dogs.length > 1) ...[
          DropdownButtonFormField<String>(
            initialValue: dog.id,
            decoration: const InputDecoration(
              labelText: 'Hund',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final d in dogs)
                DropdownMenuItem(value: d.id, child: Text(d.name)),
            ],
            onChanged: (v) => setState(() => _selectedId = v),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Stammdaten
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              DogAvatar(size: 64, photoBase64: dog.photoBase64),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dog.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 2),
                    if (dog.breed != null)
                      Text(dog.breed!, style: theme.textTheme.bodyMedium),
                    Text(
                      [
                        if (dog.ageYears != null) '${dog.ageYears} Jahre',
                        if (dog.weightKg != null) '${dog.weightKg} kg',
                      ].join('  ·  '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Bearbeiten',
                onPressed: () =>
                    context.push('${AppRoutes.editDog}/${dog.id}'),
              ),
            ],
          ),
        ),
        if (dog.notes != null && dog.notes!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(dog.notes!, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: AppSpacing.xl),

        // Versicherung (#2) - nur wenn hinterlegt
        if (dog.insurance != null && !dog.insurance!.isEmpty) ...[
          _SectionHeader(
            icon: Icons.shield_rounded,
            title: 'Versicherung',
            actionLabel: 'Bearbeiten',
            onAction: () => context.push('${AppRoutes.editDog}/${dog.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dog.insurance!.provider != null)
                  _kv('Anbieter', dog.insurance!.provider!, theme),
                if (dog.insurance!.tariff != null)
                  _kv('Tarif', dog.insurance!.tariff!, theme),
                if (dog.insurance!.policyNumber != null)
                  _kv('Nummer', dog.insurance!.policyNumber!, theme),
                if (dog.insurance!.monthlyEur != null)
                  _kv('Beitrag/Monat',
                      '${dog.insurance!.monthlyEur!.toStringAsFixed(2)} EUR',
                      theme),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Kosten (#13) - nur wenn erfasst
        if (dog.costs.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.payments_rounded,
            title: 'Kosten',
            actionLabel: 'Bearbeiten',
            onAction: () => context.push('${AppRoutes.editDog}/${dog.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final c in dog.costs)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(child: Text(c.label, style: theme.textTheme.bodyMedium)),
                  Text('${c.amountEur.toStringAsFixed(2)} EUR',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text('Summe', style: theme.textTheme.titleSmall),
              ),
              Text('${dog.totalCostsEur.toStringAsFixed(2)} EUR',
                  style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Gesundheit
        _SectionHeader(
          icon: Icons.health_and_safety_rounded,
          title: 'Gesundheit & Termine',
          actionLabel: 'Kalender',
          onAction: () => context.push(AppRoutes.healthCalendar),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (upcoming.isEmpty && past.isEmpty)
          _EmptyHint(
            theme: theme,
            text: 'Noch keine Termine fuer ${dog.name} eingetragen.',
          )
        else ...[
          if (upcoming.isNotEmpty) ...[
            Text('Kommende', style: theme.textTheme.titleSmall),
            for (final e in upcoming.take(5)) _EventTile(event: e, theme: theme),
          ],
          if (past.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Erledigt / vergangen', style: theme.textTheme.titleSmall),
            for (final e in past.take(3)) _EventTile(event: e, theme: theme),
          ],
        ],
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.addHealthEvent),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Termin hinzufuegen'),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Dokumente
        _SectionHeader(
          icon: Icons.folder_rounded,
          title: 'Dokumente & Befunde',
          actionLabel: 'Alle',
          onAction: () => context.push(AppRoutes.documents),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (docs.isEmpty)
          _EmptyHint(
            theme: theme,
            text: 'Noch keine Dokumente. Impfpass, Befunde oder Rechnungen '
                'kannst du hier sammeln.',
          )
        else
          for (final d in docs.take(5))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                d.isPdf
                    ? Icons.picture_as_pdf_rounded
                    : Icons.image_rounded,
                color: theme.colorScheme.primary,
              ),
              title: Text(d.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(_fmtDate(d.addedAt)),
            ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.documents),
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('Dokument hinzufuegen'),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.'
      '${d.month.toString().padLeft(2, '0')}.${d.year}';

  static Widget _kv(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(value,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EmptyDogs extends StatelessWidget {
  const _EmptyDogs({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets_rounded,
                size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Lege zuerst einen Hund an, dann fuellt sich seine Akte '
              'automatisch mit Terminen und Dokumenten.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.addDog),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Hund anlegen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, required this.theme});

  final HealthEvent event;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            event.done
                ? Icons.check_circle_rounded
                : Icons.event_rounded,
            size: 18,
            color: event.done
                ? Colors.green
                : theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title.isEmpty ? event.type.label : event.title,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '${event.type.label} · '
                  '${event.date.day.toString().padLeft(2, '0')}.'
                  '${event.date.month.toString().padLeft(2, '0')}.'
                  '${event.date.year}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.theme, required this.text});

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
