import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/domain/training_progress.dart';
import 'package:dogmatch_ai/features/training/presentation/training_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail-Ansicht eines Trainingsplans: Beschreibung, Schritte zum Abhaken,
/// Reset-Button.
class TrainingDetailScreen extends ConsumerWidget {
  const TrainingDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(trainingPlansProvider);
    final progressAsync = ref.watch(trainingProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trainingsplan')),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (plans) {
          final plan = plans.firstWhere(
            (p) => p.id == planId,
            orElse: () => throw StateError('Plan $planId nicht gefunden'),
          );
          final progress = progressAsync.value?[planId];
          return _Body(plan: plan, progress: progress, theme: theme, ref: ref);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.plan,
    required this.progress,
    required this.theme,
    required this.ref,
  });

  final TrainingPlan plan;
  final TrainingProgress? progress;
  final ThemeData theme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final total = plan.steps.length;
    final done = progress?.completedCount ?? 0;
    final pct = total == 0 ? 0.0 : done / total;
    final isComplete = done == total && total > 0;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(plan.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${plan.difficulty.label} - ${plan.estimatedDays} Tage',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(plan.description, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation(
              isComplete ? Colors.green : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$done von $total Schritten erledigt',
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final step in plan.steps)
          _StepTile(
            step: step,
            done: progress?.isStepDone(step.id) ?? false,
            onToggle: () => ref
                .read(trainingProgressProvider.notifier)
                .toggleStep(plan.id, step.id),
            theme: theme,
          ),
        if (progress != null) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => ref
                .read(trainingProgressProvider.notifier)
                .resetPlan(plan.id),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Fortschritt zuruecksetzen'),
          ),
        ],
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.done,
    required this.onToggle,
    required this.theme,
  });

  final TrainingStep step;
  final bool done;
  final VoidCallback onToggle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: done
                ? Colors.green.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: done
                  ? Colors.green.withValues(alpha: 0.5)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green
                      : theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 20)
                    : Text(
                        '${step.order}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(step.description, style: theme.textTheme.bodySmall),
                    if (step.tip != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                step.tip!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
