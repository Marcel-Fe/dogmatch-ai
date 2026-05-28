import 'package:equatable/equatable.dart';

/// Schwierigkeitsstufe eines Trainingsplans.
enum TrainingDifficulty { beginner, intermediate, advanced }

extension TrainingDifficultyLabel on TrainingDifficulty {
  String get label {
    switch (this) {
      case TrainingDifficulty.beginner:
        return 'Anfaenger';
      case TrainingDifficulty.intermediate:
        return 'Fortgeschritten';
      case TrainingDifficulty.advanced:
        return 'Profi';
    }
  }
}

/// Ein Trainingsplan besteht aus mehreren Schritten, die in Reihenfolge
/// abgearbeitet werden. Daten kommen aus assets/data/training_plans.json.
class TrainingPlan extends Equatable {
  const TrainingPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedDays,
    required this.steps,
    this.isPremium = false,
    this.icon = 'paw',
  });

  final String id;
  final String title;
  final String description;
  final TrainingDifficulty difficulty;
  final int estimatedDays;
  final List<TrainingStep> steps;

  /// True -> nur fuer Premium-Nutzer zugaenglich.
  final bool isPremium;

  /// Material-Icon-Kennung, vom UI auf Icons.X gemappt.
  final String icon;

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    final difficultyRaw = (json['difficulty'] as String? ?? 'beginner');
    final stepsRaw = (json['steps'] as List?) ?? const [];
    return TrainingPlan(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      difficulty: TrainingDifficulty.values.firstWhere(
        (d) => d.name == difficultyRaw,
        orElse: () => TrainingDifficulty.beginner,
      ),
      estimatedDays: (json['estimatedDays'] as num?)?.toInt() ?? 7,
      steps: stepsRaw
          .map((e) => TrainingStep.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      isPremium: (json['isPremium'] as bool?) ?? false,
      icon: json['icon'] as String? ?? 'paw',
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, difficulty, estimatedDays, steps, isPremium, icon];
}

class TrainingStep extends Equatable {
  const TrainingStep({
    required this.id,
    required this.order,
    required this.title,
    required this.description,
    this.tip,
    this.videoSearch,
  });

  final String id;
  final int order;
  final String title;
  final String description;
  final String? tip;

  /// Optionaler YouTube-Such-Begriff fuer den Schritt. Im UI wird daraus
  /// ein `https://www.youtube.com/results?search_query=...` Link, der im
  /// neuen Tab oeffnet. Wir nutzen Suche statt fester Video-IDs, weil
  /// hardcoded IDs schnell tot sind.
  final String? videoSearch;

  /// URL zur YouTube-Suche, oder null wenn kein Suchbegriff gesetzt ist.
  String? get videoSearchUrl {
    final q = videoSearch?.trim();
    if (q == null || q.isEmpty) return null;
    return 'https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(q)}';
  }

  factory TrainingStep.fromJson(Map<String, dynamic> json) {
    return TrainingStep(
      id: json['id'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      tip: json['tip'] as String?,
      videoSearch: json['videoSearch'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, order, title, description, tip, videoSearch];
}
