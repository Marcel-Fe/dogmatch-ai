import 'package:equatable/equatable.dart';

/// Fortschritt eines einzelnen Trainingsplans.
class TrainingProgress extends Equatable {
  const TrainingProgress({
    required this.planId,
    this.completedStepIds = const {},
    this.startedAt,
    this.lastActivityAt,
  });

  final String planId;
  final Set<String> completedStepIds;
  final DateTime? startedAt;
  final DateTime? lastActivityAt;

  bool isStepDone(String stepId) => completedStepIds.contains(stepId);

  int get completedCount => completedStepIds.length;

  TrainingProgress copyWith({
    Set<String>? completedStepIds,
    DateTime? startedAt,
    DateTime? lastActivityAt,
  }) {
    return TrainingProgress(
      planId: planId,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      startedAt: startedAt ?? this.startedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  factory TrainingProgress.fromJson(Map<String, dynamic> json) {
    final ids = (json['completedStepIds'] as List?)?.cast<String>() ?? const [];
    return TrainingProgress(
      planId: json['planId'] as String,
      completedStepIds: ids.toSet(),
      startedAt: (json['startedAt'] as String?) == null
          ? null
          : DateTime.tryParse(json['startedAt'] as String),
      lastActivityAt: (json['lastActivityAt'] as String?) == null
          ? null
          : DateTime.tryParse(json['lastActivityAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'planId': planId,
        'completedStepIds': completedStepIds.toList(),
        'startedAt': startedAt?.toIso8601String(),
        'lastActivityAt': lastActivityAt?.toIso8601String(),
      };

  @override
  List<Object?> get props =>
      [planId, completedStepIds, startedAt, lastActivityAt];
}
