import 'dart:convert';

import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/domain/training_repository.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Laedt die Trainingsplaene aus assets/data/training_plans.json.
class AssetTrainingPlanRepository implements TrainingPlanRepository {
  const AssetTrainingPlanRepository();

  static const String _assetPath = 'assets/data/training_plans.json';

  @override
  Future<List<TrainingPlan>> loadAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(TrainingPlan.fromJson).toList(growable: false);
  }
}
