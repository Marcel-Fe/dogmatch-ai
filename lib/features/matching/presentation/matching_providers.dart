import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/matching/domain/match_result.dart';
import 'package:dogmatch_ai/features/matching/domain/matching_engine.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reine Engine-Instanz - dependency injection ueber Riverpod, damit
/// Tests sie ggf. ersetzen koennen.
final matchingEngineProvider = Provider<MatchingEngine>((ref) {
  return const MatchingEngine();
});

/// Berechnet die Match-Ergebnisse aus den aktuellen Quiz-Antworten und
/// der Rassenliste. Aktualisiert sich automatisch, sobald sich eine der
/// beiden Quellen aendert.
final matchResultsProvider = FutureProvider<List<MatchResult>>((ref) async {
  final breeds = await ref.watch(breedsProvider.future);
  final answers = ref.watch(quizControllerProvider).answers;
  return ref.watch(matchingEngineProvider).compute(answers, breeds);
});
