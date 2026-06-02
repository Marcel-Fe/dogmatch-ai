import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/matching/domain/match_result.dart';
import 'package:dogmatch_ai/features/quiz/domain/quiz_question.dart';

/// Reine, deterministische Matching-Funktion: Quiz-Antworten + Rassen
/// -> sortierte Liste von Treffern mit Score 0-100 und Begruendungen.
///
/// Bewusst ohne Flutter- oder Riverpod-Abhaengigkeiten - so kann diese
/// Klasse direkt mit Unit-Tests abgedeckt werden.
class MatchingEngine {
  const MatchingEngine();

  List<MatchResult> compute(QuizAnswers answers, List<DogBreed> breeds) {
    final results = breeds.map((b) => _score(b, answers)).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  MatchResult _score(DogBreed breed, QuizAnswers answers) {
    var score = 50;
    final reasons = <String>[];
    final cons = <String>[];

    final living = answers.answers['living_space']?.firstOrNull;
    if (living == 'apartment') {
      final isSmallish =
          breed.size == DogSize.small || breed.size == DogSize.medium;
      if (isSmallish && breed.exerciseNeed <= 3) {
        score += 15;
        reasons.add('Wohnungstauglich');
      }
      if (breed.size == DogSize.giant || breed.exerciseNeed == 5) {
        score -= 20;
        cons.add('Kann in einer Wohnung schnell unterfordert sein');
      }
    } else if (living == 'house_garden') {
      score += 5;
      if (breed.exerciseNeed >= 4) {
        reasons.add('Profitiert von Auslauf im Garten');
      }
    }

    final activity = answers.answers['activity_level']?.firstOrNull;
    if (activity == 'low') {
      if (breed.exerciseNeed <= 2) {
        score += 20;
        reasons.add('Passt zu einem ruhigen Alltag');
      }
      if (breed.exerciseNeed >= 4) {
        score -= 25;
        cons.add('Braucht deutlich mehr Bewegung als geplant');
      }
    } else if (activity == 'medium') {
      if (breed.exerciseNeed >= 3 && breed.exerciseNeed <= 4) {
        score += 15;
        reasons.add('Bewegungsbedarf passt zu deinem Alltag');
      }
      if (breed.exerciseNeed == 5) {
        score -= 10;
        cons.add('Will eigentlich noch mehr Action');
      }
    } else if (activity == 'high') {
      if (breed.exerciseNeed >= 4) {
        score += 20;
        reasons.add('Passt zu deinem aktiven Lebensstil');
      }
      if (breed.exerciseNeed <= 2) {
        score -= 15;
        cons.add('Eher ruhig - wird mit dir nicht mithalten wollen');
      }
    }

    final experience = answers.answers['experience']?.firstOrNull;
    if (experience == 'first') {
      if (breed.beginnerFriendliness >= 4) {
        score += 20;
        reasons.add('Sehr anfaengerfreundlich');
      }
      if (breed.beginnerFriendliness <= 2) {
        score -= 20;
        cons.add('Eher fuer erfahrene Halter geeignet');
      }
    } else if (experience == 'some' && breed.beginnerFriendliness >= 3) {
      score += 5;
    }

    final children = answers.answers['children']?.firstOrNull;
    if (children == 'yes') {
      if (breed.childFriendliness >= 4) {
        score += 15;
        reasons.add('Kinderfreundlich');
      }
      if (breed.childFriendliness <= 2) {
        score -= 25;
        cons.add('Mit Kindern eher zurueckhaltend');
      }
    }

    final sizePref = answers.answers['size_preference']?.firstOrNull;
    if (sizePref == 'small' && breed.size == DogSize.small) {
      score += 15;
      reasons.add('Kleine Groesse - genau wie gewuenscht');
    } else if (sizePref == 'medium' && breed.size == DogSize.medium) {
      score += 15;
      reasons.add('Mittlere Groesse - genau wie gewuenscht');
    } else if (sizePref == 'large' && breed.size == DogSize.large) {
      score += 15;
      reasons.add('Grosse Groesse - genau wie gewuenscht');
    } else if (sizePref != null && sizePref != 'any') {
      score -= 10;
    }

    // Fellpflege-Bereitschaft
    final grooming = answers.answers['grooming_pref']?.firstOrNull;
    if (grooming == 'low') {
      if (breed.grooming <= 2) {
        score += 12;
        reasons.add('Pflegeleicht');
      }
      if (breed.grooming >= 4) {
        score -= 15;
        cons.add('Braucht regelmaessige, aufwendige Fellpflege');
      }
    } else if (grooming == 'high' && breed.grooming >= 4) {
      score += 8;
      reasons.add('Aufwendige Pflege passt zu dir');
    }

    // Haaren
    final shedding = answers.answers['shedding_pref']?.firstOrNull;
    if (shedding == 'low_shedding') {
      if (breed.shedding <= 2) {
        score += 12;
        reasons.add('Haart wenig');
      }
      if (breed.shedding >= 4) {
        score -= 15;
        cons.add('Haart stark - nichts fuer Haar-Empfindliche');
      }
    }

    // Bell-Neigung / Wachsamkeit (noiseLevel ist optional)
    final noise = answers.answers['noise_pref']?.firstOrNull;
    final nl = breed.noiseLevel;
    if (noise == 'quiet' && nl != null) {
      if (nl <= 2) {
        score += 10;
        reasons.add('Eher leise');
      }
      if (nl >= 4) {
        score -= 12;
        cons.add('Neigt zum Bellen');
      }
    } else if (noise == 'watchdog' && nl != null && nl >= 4) {
      score += 8;
      reasons.add('Wachsam - schlaegt zuverlaessig an');
    }

    // Katzen / Kleintiere
    final cats = answers.answers['cats']?.firstOrNull;
    if (cats == 'yes' && breed.goodWithCats != null) {
      if (breed.goodWithCats == true) {
        score += 12;
        reasons.add('Vertraegt sich gut mit Katzen');
      } else {
        score -= 15;
        cons.add('Hoher Jagdtrieb - mit Katzen heikel');
      }
    }

    // Allein-Zeit
    final alone = answers.answers['alone_time']?.firstOrNull;
    if (alone == 'few_hours') {
      // Sehr menschenbezogene/aktive Rassen leiden eher beim Alleinsein.
      if (breed.exerciseNeed >= 4 && breed.trainability >= 4) {
        score -= 8;
        cons.add('Bleibt nur ungern lange allein');
      }
    }

    return MatchResult(
      breed: breed,
      score: score.clamp(0, 100),
      reasons: reasons,
      cons: cons,
    );
  }
}
