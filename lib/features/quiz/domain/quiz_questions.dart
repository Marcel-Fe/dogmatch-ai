import 'package:dogmatch_ai/features/quiz/domain/quiz_question.dart';

/// Fragenkatalog des Matching-Quiz. Die [QuizQuestion.id] und
/// [QuizOption.id] sind die Schluessel, mit denen die Matching-Engine
/// scort - also bewusst stabil halten.
const List<QuizQuestion> kQuizQuestions = [
  QuizQuestion(
    id: 'living_space',
    question: 'Wie wohnst du?',
    options: [
      QuizOption(id: 'apartment', label: 'Wohnung'),
      QuizOption(id: 'house_garden', label: 'Haus mit Garten'),
    ],
  ),
  QuizQuestion(
    id: 'activity_level',
    question: 'Wie aktiv bist du im Alltag?',
    options: [
      QuizOption(id: 'low', label: 'Wenig - kurze Spaziergaenge'),
      QuizOption(id: 'medium', label: 'Mittel - 1 bis 2 Stunden taeglich'),
      QuizOption(id: 'high', label: 'Viel - Sport, Wandern, lange Touren'),
    ],
  ),
  QuizQuestion(
    id: 'experience',
    question: 'Wie viel Erfahrung hast du mit Hunden?',
    options: [
      QuizOption(id: 'first', label: 'Mein erster Hund'),
      QuizOption(id: 'some', label: 'Etwas Erfahrung'),
      QuizOption(id: 'experienced', label: 'Sehr erfahren'),
    ],
  ),
  QuizQuestion(
    id: 'children',
    question: 'Leben Kinder im Haushalt?',
    options: [
      QuizOption(id: 'yes', label: 'Ja'),
      QuizOption(id: 'no', label: 'Nein'),
    ],
  ),
  QuizQuestion(
    id: 'size_preference',
    question: 'Welche Groesse soll dein Hund haben?',
    options: [
      QuizOption(id: 'small', label: 'Klein'),
      QuizOption(id: 'medium', label: 'Mittel'),
      QuizOption(id: 'large', label: 'Gross'),
      QuizOption(id: 'any', label: 'Egal'),
    ],
  ),
];
