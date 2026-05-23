import 'package:equatable/equatable.dart';

/// Eine einzelne Antwortoption einer Quizfrage.
class QuizOption extends Equatable {
  const QuizOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;

  /// Optionaler Material-Icon-Name fuer die Anzeige.
  final String? icon;

  @override
  List<Object?> get props => [id];
}

/// Eine Quizfrage. Die [id] entspricht spaeter einem Kriterium der
/// Matching-Engine (z.B. "living_space", "activity_level").
class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.multiSelect = false,
  });

  final String id;
  final String question;
  final List<QuizOption> options;

  /// Sind mehrere Antworten erlaubt?
  final bool multiSelect;

  @override
  List<Object?> get props => [id];
}

/// Die gesammelten Antworten des Nutzers:
/// Frage-id -> Liste der gewaehlten Options-ids.
class QuizAnswers extends Equatable {
  const QuizAnswers({this.answers = const {}});

  final Map<String, List<String>> answers;

  QuizAnswers copyWith({Map<String, List<String>>? answers}) {
    return QuizAnswers(answers: answers ?? this.answers);
  }

  /// Liefert eine neue [QuizAnswers]-Instanz mit aktualisierter Antwort.
  QuizAnswers select(String questionId, List<String> optionIds) {
    final next = Map<String, List<String>>.from(answers);
    next[questionId] = optionIds;
    return QuizAnswers(answers: next);
  }

  @override
  List<Object?> get props => [answers];
}
