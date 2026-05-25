import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Verwaltung aller Hunde des Nutzers. Aktiven Hund umschalten,
/// neue anlegen, bestehende bearbeiten oder loeschen.
class ManageDogsScreen extends ConsumerWidget {
  const ManageDogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogsAsync = ref.watch(dogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meine Hunde')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addDog),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Hund hinzufuegen'),
      ),
      body: dogsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (state) {
          if (state.dogs.isEmpty) {
            return EmptyView(
              icon: Icons.pets_outlined,
              title: 'Noch kein Hund hinterlegt',
              message:
                  'Lege deinen Hund an - dann personalisieren wir Kalender, '
                  'Erinnerungen und Empfehlungen darauf.',
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.addDog),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Ersten Hund anlegen'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.dogs.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final dog = state.dogs[index];
              final isActive = dog.id == state.activeDog?.id;
              return _DogTile(
                dog: dog,
                isActive: isActive,
                onTap: () =>
                    context.push('${AppRoutes.editDog}/${dog.id}'),
                onActivate: () =>
                    ref.read(dogsProvider.notifier).setActive(dog.id),
                onDelete: () => _confirmDelete(context, ref, dog),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Dog dog,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hund loeschen?'),
        content: Text(
          '${dog.name} wird inklusive Foto entfernt. Termine und Dokumente '
          'bleiben in der App, sind danach aber keinem Hund mehr zugeordnet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Loeschen'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(dogsProvider.notifier).removeDog(dog.id);
    }
  }
}

class _DogTile extends StatelessWidget {
  const _DogTile({
    required this.dog,
    required this.isActive,
    required this.onTap,
    required this.onActivate,
    required this.onDelete,
  });

  final Dog dog;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onActivate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = <String>[
      if (dog.breed != null) dog.breed!,
      if (dog.ageYears != null) '${dog.ageYears} Jahre',
      if (dog.weightKg != null) '${dog.weightKg!.toStringAsFixed(1)} kg',
    ].join(' · ');

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          DogAvatar(
            size: 56,
            photoBase64: dog.photoBase64,
            borderColor: isActive ? theme.colorScheme.primary : null,
            borderWidth: isActive ? 2 : 0,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(dog.name, style: theme.textTheme.titleMedium),
                    if (isActive) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusPill,
                          ),
                        ),
                        child: Text(
                          'Aktiv',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'activate') {
                onActivate();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (_) => [
              if (!isActive)
                const PopupMenuItem(
                  value: 'activate',
                  child: Text('Als aktiv waehlen'),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Loeschen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
