import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/domain/training_progress.dart';

abstract class TrainingPlanRepository {
  Future<List<TrainingPlan>> loadAll();
}

abstract class TrainingProgressRepository {
  Future<Map<String, TrainingProgress>> loadAll();
  Future<void> save(TrainingProgress progress);
  Future<void> reset(String planId);
}
