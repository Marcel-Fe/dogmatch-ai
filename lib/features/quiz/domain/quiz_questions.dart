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
  QuizQuestion(
    id: 'grooming_pref',
    question: 'Wie viel Fellpflege ist fuer dich ok?',
    options: [
      QuizOption(id: 'low', label: 'Wenig - moeglichst pflegeleicht'),
      QuizOption(id: 'medium', label: 'Etwas Buersten ist ok'),
      QuizOption(id: 'high', label: 'Auch aufwendige Pflege ist kein Problem'),
    ],
  ),
  QuizQuestion(
    id: 'shedding_pref',
    question: 'Wie wichtig ist dir wenig Haaren?',
    options: [
      QuizOption(id: 'low_shedding', label: 'Wichtig - moeglichst wenig Haare'),
      QuizOption(id: 'dont_care', label: 'Egal - Haare gehoeren dazu'),
    ],
  ),
  QuizQuestion(
    id: 'noise_pref',
    question: 'Wie ruhig sollte dein Hund sein?',
    options: [
      QuizOption(id: 'quiet', label: 'Eher ruhig - bellt wenig'),
      QuizOption(id: 'watchdog', label: 'Wachsam - darf anschlagen'),
      QuizOption(id: 'any_noise', label: 'Egal'),
    ],
  ),
  QuizQuestion(
    id: 'cats',
    question: 'Leben Katzen oder andere Kleintiere bei dir?',
    options: [
      QuizOption(id: 'yes', label: 'Ja'),
      QuizOption(id: 'no', label: 'Nein'),
    ],
  ),
  QuizQuestion(
    id: 'alone_time',
    question: 'Wie lange muss dein Hund alleine bleiben?',
    options: [
      QuizOption(id: 'rarely', label: 'Selten - ich bin meist da'),
      QuizOption(id: 'few_hours', label: 'Ein paar Stunden taeglich'),
    ],
  ),
];
