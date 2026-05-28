import 'package:equatable/equatable.dart';

enum BehaviorCategory {
  barking('Bellen & Lautaeusserung'),
  leash('Leinen-Verhalten'),
  fear('Angst & Stress'),
  aggression('Aggression'),
  social('Sozialverhalten'),
  housetraining('Stubenreinheit'),
  activity('Aktivitaet & Spielen'),
  other('Sonstiges');

  const BehaviorCategory(this.label);
  final String label;
}

class Behavior extends Equatable {
  const Behavior({
    required this.id,
    required this.label,
    required this.category,
  });

  final String id;
  final String label;
  final BehaviorCategory category;

  @override
  List<Object?> get props => [id, label, category];
}

enum BehaviorPriority {
  routine('Im Alltag trainieren', 'Geduldig zuhause trainieren - Fortschritt in 2-4 Wochen.'),
  focused('Strukturiertes Training noetig', 'Trainings-Plan empfehlenswert, ggf. ein paar Stunden mit Hundetrainer.'),
  professional('Professionelle Hilfe', 'Zertifizierter Hundetrainer / Verhaltensberater einbinden.'),
  vet('Tierarzt + Trainer', 'Erst Tierarzt zur Abklaerung medizinischer Ursachen, dann professionelles Training.');

  const BehaviorPriority(this.label, this.advice);
  final String label;
  final String advice;
}

/// Empfehlung der Engine. `trainingPlanId` verlinkt optional auf einen
/// vorhandenen TrainingPlan (z.B. "heel" fuer Leinen-Ziehen).
class BehaviorAssessment extends Equatable {
  const BehaviorAssessment({
    required this.title,
    required this.priority,
    required this.description,
    required this.recommendation,
    this.trainingPlanId,
  });

  final String title;
  final BehaviorPriority priority;
  final String description;
  final String recommendation;
  final String? trainingPlanId;

  @override
  List<Object?> get props =>
      [title, priority, description, recommendation, trainingPlanId];
}
