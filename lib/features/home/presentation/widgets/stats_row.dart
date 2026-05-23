import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/favorites/presentation/favorites_controller.dart';
import 'package:dogmatch_ai/features/quiz/domain/quiz_questions.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Drei kleine Mini-Karten mit Live-Daten: Anzahl Rassen, Favoriten, Quiz-Status.
class StatsRow extends ConsumerWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedCount = ref.watch(breedsProvider).value?.length ?? 0;
    final favCount = ref.watch(favoritesProvider).value?.length ?? 0;
    final answered = ref.watch(quizControllerProvider).answers.answers.length;
    final quizDone = answered >= kQuizQuestions.length;
    final quizLabel = quizDone ? 'Fertig' : '$answered/${kQuizQuestions.length}';

    return Row(
      children: [
        Expanded(child: _StatCard(value: '$breedCount', label: 'Rassen')),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _StatCard(value: '$favCount', label: 'Favoriten')),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _StatCard(value: quizLabel, label: 'Quiz')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
