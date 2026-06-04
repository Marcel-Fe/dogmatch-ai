import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/home_leading_button.dart';
import 'package:dogmatch_ai/features/quiz/domain/quiz_questions.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_controller.dart';
import 'package:dogmatch_ai/features/quiz/presentation/widgets/quiz_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Interaktiver Quiz-Bildschirm (Tab 2). Fortschrittsanzeige, eine Frage
/// pro Bildschirm, Zurueck- und Weiter-Buttons. Auf der letzten Frage
/// fuehrt "Ergebnisse anzeigen" zu den Match-Ergebnissen.
class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(quizControllerProvider);
    final controller = ref.read(quizControllerProvider.notifier);
    final theme = Theme.of(context);

    final question = kQuizQuestions[quiz.currentIndex];
    final selected = quiz.answers.answers[question.id]?.firstOrNull;
    final isLast = quiz.isLastQuestion;
    final progress = (quiz.currentIndex + 1) / kQuizQuestions.length;

    return Scaffold(
      appBar: AppBar(
        leading: const HomeLeadingButton(),
        title: const Text('Matching-Quiz'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Frage ${quiz.currentIndex + 1} von ${kQuizQuestions.length}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(question.question, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  children: [
                    for (final option in question.options) ...[
                      QuizOptionTile(
                        label: option.label,
                        isSelected: selected == option.id,
                        onTap: () =>
                            controller.selectOption(question.id, option.id),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (quiz.currentIndex > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.previous,
                        child: const Text('Zurueck'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: selected == null
                          ? null
                          : () {
                              if (isLast) {
                                context.push(AppRoutes.matchResults);
                              } else {
                                controller.next();
                              }
                            },
                      child: Text(
                        isLast ? 'Ergebnisse anzeigen' : 'Weiter',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
