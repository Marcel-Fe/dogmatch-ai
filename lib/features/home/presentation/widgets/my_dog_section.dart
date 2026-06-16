import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeders/data/asset_breeder_repository.dart';
import 'package:dogmatch_ai/features/breeders/domain/breeder.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_matcher.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/presentation/training_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Aggregations-Widget fuer den aktiven Hund.
///
/// Sucht die zugewiesene Rasse in `allBreeds` (case-insensitive auf Name+Id)
/// und zeigt Pflege-Tipps, Trainings-Fortschritt fuer den Hund, sowie passende
/// Zuechter-Verweise. Kosten und Versicherung leben bewusst nur in der
/// Hundeakte (dog-record), nicht auf dem Dashboard.
///
/// Wenn keine Rasse gematcht wird (Freitext-Eingabe), wird nur ein Hinweis
/// mit Link auf die Hund-Bearbeitung angezeigt.
class MyDogSection extends ConsumerWidget {
  const MyDogSection({
    super.key,
    required this.dog,
    required this.allBreeds,
  });

  final Dog dog;
  final List<DogBreed> allBreeds;

  DogBreed? _resolveBreed() => matchBreed(dog.breed, allBreeds);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final breed = _resolveBreed();

    if (breed == null) {
      return _NoBreedHint(theme: theme);
    }

    final breedersAsync = ref.watch(breedersProvider);
    final progressAsync = ref.watch(trainingProgressProvider);
    final plansAsync = ref.watch(trainingPlansProvider);

    final matchedBreeders = breedersAsync.value
            ?.where((b) => b.breedIds.contains(breed.id))
            .toList(growable: false) ??
        const <Breeder>[];
    final vdh = breedersAsync.value
        ?.firstWhere((b) => b.id == 'vdh-info', orElse: () => Breeder(
              id: 'vdh-info',
              name: 'VDH',
              city: 'Dortmund',
              latitude: 0,
              longitude: 0,
              breedIds: const [],
              isVerified: true,
              experienceYears: 0,
              averageRating: 0,
            ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Alles ueber ${dog.name}',
                style: theme.textTheme.titleLarge,
              ),
            ),
            TextButton.icon(
              onPressed: () =>
                  context.push('${AppRoutes.breedDetail}/${breed.id}'),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text('Rasse'),
            ),
          ],
        ),
        Text(
          'Rasse: ${breed.name}  ·  ${breed.size.label}  ·  '
          'Lebenserwartung ${breed.lifeExpectancyYears} J.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Pflege-Tipps
        _Card(
          icon: Icons.spa_outlined,
          title: 'Pflege & Haltung',
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final tip in breed.careTips.take(4)) _BulletLine(text: tip),
              if (breed.careTips.length > 4)
                _MoreLink(
                  label: '${breed.careTips.length - 4} weitere Tipps',
                  onTap: () =>
                      context.push('${AppRoutes.breedDetail}/${breed.id}'),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Training Fortschritt
        _Card(
          icon: Icons.school_outlined,
          title: 'Training fuer ${dog.name}',
          theme: theme,
          child: plansAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(
              'Trainingsplaene konnten nicht geladen werden.',
              style: theme.textTheme.bodySmall,
            ),
            data: (plans) {
              final progress = progressAsync.value ?? const {};
              // Angefangene Plaene zuerst, dann der Rest - aber nur eine
              // kurze Vorschau (max 5). Die volle Liste lebt im Training-Tab.
              final sorted = [...plans]..sort((a, b) {
                  final da = progress[a.id]?.completedStepIds.length ?? 0;
                  final db = progress[b.id]?.completedStepIds.length ?? 0;
                  return db.compareTo(da);
                });
              final preview = sorted.take(5).toList(growable: false);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final p in preview)
                    _TrainingProgressLine(
                      plan: p,
                      doneCount:
                          progress[p.id]?.completedStepIds.length ?? 0,
                      onTap: () =>
                          context.push('${AppRoutes.training}/${p.id}'),
                      theme: theme,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  _MoreLink(
                    label: 'Alle ${plans.length} Trainingsplaene oeffnen',
                    onTap: () => context.push(AppRoutes.training),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Zuechter fuer diese Rasse
        _Card(
          icon: Icons.verified_user_outlined,
          title: 'Wo bekomme ich einen ${breed.name}?',
          theme: theme,
          child: breedersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(
              'Zuechter konnten nicht geladen werden.',
              style: theme.textTheme.bodySmall,
            ),
            data: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (matchedBreeders.isEmpty) ...[
                  Text(
                    'Kein spezialisierter Rasseverein in unserer Liste fuer '
                    '${breed.name}. Der VDH ist die zentrale Anlaufstelle:',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (vdh != null) _BreederMini(breeder: vdh, theme: theme),
                ] else ...[
                  for (final b in matchedBreeders.take(3))
                    _BreederMini(breeder: b, theme: theme),
                ],
                const SizedBox(height: AppSpacing.xs),
                _MoreLink(
                  label: 'Alle Zuechter durchsuchen',
                  onTap: () => context.push(AppRoutes.breederFinder),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.icon,
    required this.title,
    required this.child,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _MoreLink extends StatelessWidget {
  const _MoreLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingProgressLine extends StatelessWidget {
  const _TrainingProgressLine({
    required this.plan,
    required this.doneCount,
    required this.onTap,
    required this.theme,
  });

  final TrainingPlan plan;
  final int doneCount;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final total = plan.steps.length;
    final pct = total == 0 ? 0.0 : doneCount / total;
    final isDone = doneCount == total && total > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.title,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '$doneCount/$total',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 4,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      valueColor: AlwaysStoppedAnimation(
                        isDone ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _BreederMini extends StatelessWidget {
  const _BreederMini({required this.breeder, required this.theme});

  final Breeder breeder;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(breeder.name, style: theme.textTheme.bodySmall),
                Text(
                  '${breeder.city} (${breeder.country})',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoBreedHint extends StatelessWidget {
  const _NoBreedHint({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rasse fehlt',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Trag bei deinem Hund die Rasse genau so ein, wie sie '
                  'in der Rassen-Liste heisst - dann erscheinen hier '
                  'Pflege-Tipps, Kosten und Trainings-Vorschlaege.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
