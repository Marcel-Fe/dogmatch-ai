import 'package:dogmatch_ai/features/training/data/asset_training_plan_repository.dart';
import 'package:dogmatch_ai/features/training/data/local_training_progress_repository.dart';
import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/domain/training_progress.dart';
import 'package:dogmatch_ai/features/training/domain/training_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingPlanRepositoryProvider =
    Provider<TrainingPlanRepository>((ref) {
  return const AssetTrainingPlanRepository();
});

final trainingProgressRepositoryProvider =
    Provider<TrainingProgressRepository>((ref) {
  return const LocalTrainingProgressRepository();
});

/// Liefert alle Trainingsplaene (statisch aus dem Bundle).
final trainingPlansProvider = FutureProvider<List<TrainingPlan>>((ref) {
  return ref.read(trainingPlanRepositoryProvider).loadAll();
});

/// Haelt Fortschritt fuer alle Plaene als Map. Bei jeder Schritt-Aktion
/// wird der Eintrag aktualisiert und persistiert.
class TrainingProgressNotifier
    extends AsyncNotifier<Map<String, TrainingProgress>> {
  @override
  Future<Map<String, TrainingProgress>> build() {
    return ref.read(trainingProgressRepositoryProvider).loadAll();
  }

  TrainingProgress _ensure(String planId) {
    final current = state.value?[planId];
    if (current != null) return current;
    return TrainingProgress(
      planId: planId,
      startedAt: DateTime.now(),
    );
  }

  Future<void> toggleStep(String planId, String stepId) async {
    final progress = _ensure(planId);
    final updatedSteps = Set<String>.from(progress.completedStepIds);
    if (updatedSteps.contains(stepId)) {
      updatedSteps.remove(stepId);
    } else {
      updatedSteps.add(stepId);
    }
    final next = progress.copyWith(
      completedStepIds: updatedSteps,
      lastActivityAt: DateTime.now(),
      startedAt: progress.startedAt ?? DateTime.now(),
    );
    final all = Map<String, TrainingProgress>.from(state.value ?? const {});
    all[planId] = next;
    state = AsyncData(all);
    await ref.read(trainingProgressRepositoryProvider).save(next);
  }

  Future<void> resetPlan(String planId) async {
    final all = Map<String, TrainingProgress>.from(state.value ?? const {});
    all.remove(planId);
    state = AsyncData(all);
    await ref.read(trainingProgressRepositoryProvider).reset(planId);
  }
}

final trainingProgressProvider = AsyncNotifierProvider<
    TrainingProgressNotifier, Map<String, TrainingProgress>>(
  TrainingProgressNotifier.new,
);
