import 'package:dogmatch_ai/features/quiz/domain/quiz_question.dart';
import 'package:dogmatch_ai/features/quiz/domain/quiz_questions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Zustand des Matching-Quiz: aktueller Fragenindex + gesammelte Antworten.
class QuizState extends Equatable {
  const QuizState({required this.currentIndex, required this.answers});

  final int currentIndex;
  final QuizAnswers answers;

  bool get isLastQuestion => currentIndex == kQuizQuestions.length - 1;

  QuizState copyWith({int? currentIndex, QuizAnswers? answers}) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [currentIndex, answers];
}

/// Steuert den Quiz-Fluss. Hält die Auswahl, vor- und zurueckspringen und
/// kennt den Reset fuer ein neues Quiz.
class QuizController extends Notifier<QuizState> {
  @override
  QuizState build() {
    return const QuizState(currentIndex: 0, answers: QuizAnswers());
  }

  void selectOption(String questionId, String optionId) {
    state = state.copyWith(
      answers: state.answers.select(questionId, [optionId]),
    );
  }

  void next() {
    if (!state.isLastQuestion) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previous() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void restart() {
    state = const QuizState(currentIndex: 0, answers: QuizAnswers());
  }
}

final quizControllerProvider =
    NotifierProvider<QuizController, QuizState>(QuizController.new);
