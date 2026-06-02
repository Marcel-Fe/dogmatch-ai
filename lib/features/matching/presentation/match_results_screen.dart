import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/matching/presentation/matching_providers.dart';
import 'package:dogmatch_ai/features/matching/presentation/widgets/match_result_card.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Zeigt die berechneten Match-Ergebnisse nach Score sortiert.
/// Tipp auf eine Karte oeffnet das vollstaendige Rassenprofil.
class MatchResultsScreen extends ConsumerWidget {
  const MatchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchResultsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Deine Matches')),
      body: matchesAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Ergebnisse konnten nicht berechnet werden.',
          onRetry: () => ref.invalidate(matchResultsProvider),
        ),
        data: (matches) {
          if (matches.isEmpty) {
            return const EmptyView(
              title: 'Noch keine Ergebnisse',
              message: 'Beantworte zuerst das Quiz.',
              icon: Icons.emoji_events_outlined,
            );
          }
          // Eingrenzung (#24): nur die wirklich passenden Rassen zeigen.
          // Bevorzugt alle mit >= 90%; gibt es zu wenige, die besten bis 10.
          final strong =
              matches.where((m) => m.score >= 90).toList(growable: false);
          final shown = strong.length >= 3
              ? strong.take(10).toList(growable: false)
              : matches.take(10).toList(growable: false);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Top-Treffer fuer dich',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strong.length >= 3
                    ? 'Deine besten Treffer ab 90% Uebereinstimmung - '
                        'tippe eine Rasse fuer alle Infos.'
                    : 'Die ${shown.length} passendsten Rassen fuer dich - '
                        'tippe eine Rasse fuer alle Infos.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final match in shown) ...[
                MatchResultCard(
                  match: match,
                  onTap: () => context.push(
                    '${AppRoutes.breedDetail}/${match.breed.id}',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(quizControllerProvider.notifier).restart();
                  context.pop();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Quiz neu starten'),
              ),
            ],
          );
        },
      ),
    );
  }
}
