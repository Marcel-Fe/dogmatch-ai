import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/matching/domain/matching_engine.dart';
import 'package:dogmatch_ai/features/quiz/domain/quiz_question.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = MatchingEngine();

  group('MatchingEngine', () {
    test('Leere Antworten -> alle Rassen mit Basis-Score 50, ohne Reasons',
        () {
      final results = engine.compute(
        const QuizAnswers(),
        [_apartmentDog, _activeDog, _giantDog],
      );

      expect(results, hasLength(3));
      for (final r in results) {
        expect(r.score, 50);
        expect(r.reasons, isEmpty);
        expect(r.cons, isEmpty);
      }
    });

    test('Ergebnisse sind absteigend nach Score sortiert', () {
      final answers =
          const QuizAnswers().select('living_space', ['apartment']);

      final results =
          engine.compute(answers, [_giantDog, _apartmentDog, _activeDog]);

      for (var i = 1; i < results.length; i++) {
        expect(
          results[i].score,
          lessThanOrEqualTo(results[i - 1].score),
          reason: 'Index $i hat einen hoeheren Score als Index ${i - 1}',
        );
      }
    });

    test('Wohnung + wenig aktiv: Apartment-Hund gewinnt mit klaren Reasons',
        () {
      final answers = const QuizAnswers()
          .select('living_space', ['apartment'])
          .select('activity_level', ['low']);

      final results = engine.compute(answers, [_apartmentDog, _activeDog]);

      expect(results.first.breed.id, 'apartment-dog');
      expect(results.first.reasons, contains('Wohnungstauglich'));
      expect(results.first.reasons, contains('Passt zu einem ruhigen Alltag'));
    });

    test('Kinder + niedrige Kinderfreundlichkeit -> Warnung in cons', () {
      final answers = const QuizAnswers().select('children', ['yes']);

      final results = engine.compute(answers, [_giantDog]);

      expect(results.first.cons, contains('Mit Kindern eher zurueckhaltend'));
    });

    test('Maximale Negativfaktoren werden auf Score 0 geclampt', () {
      // _activeDog wuerde rechnerisch -50 ergeben - die Engine muss
      // dennoch >= 0 zurueckliefern.
      final answers = const QuizAnswers()
          .select('living_space', ['apartment'])
          .select('activity_level', ['low'])
          .select('experience', ['first'])
          .select('children', ['yes'])
          .select('size_preference', ['small']);

      final results = engine.compute(answers, [_activeDog]);

      expect(results.first.score, 0);
    });

    test(
        'Liefert immer genau so viele Ergebnisse wie Eingaben - '
        'keine Rasse faellt weg', () {
      final answers =
          const QuizAnswers().select('activity_level', ['high']);

      final results =
          engine.compute(answers, [_apartmentDog, _activeDog, _giantDog]);

      expect(results, hasLength(3));
      final ids = results.map((r) => r.breed.id).toSet();
      expect(
        ids,
        equals({'apartment-dog', 'active-dog', 'giant-dog'}),
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Test-Fixtures: minimale Rassen mit klar gewaehlten Eigenschaften, damit die
// Scoring-Erwartungen oben deterministisch reproduzierbar sind.
// ---------------------------------------------------------------------------

const _apartmentDog = DogBreed(
  id: 'apartment-dog',
  name: 'Apartment-Hund',
  origin: 'Test',
  size: DogSize.small,
  temperament: 'ruhig',
  description: 'Testrasse fuer Wohnungs-Szenarien',
  energyLevel: ActivityLevel.low,
  grooming: 2,
  shedding: 2,
  childFriendliness: 4,
  beginnerFriendliness: 5,
  trainability: 4,
  exerciseNeed: 2,
  lifeExpectancyYears: 14,
  weightKgMin: 5.0,
  weightKgMax: 8.0,
  monthlyCostEur: 60,
  commonHealthIssues: [],
  traits: [],
);

const _activeDog = DogBreed(
  id: 'active-dog',
  name: 'Aktiv-Hund',
  origin: 'Test',
  size: DogSize.large,
  temperament: 'energiegeladen',
  description: 'Testrasse fuer aktive Halter',
  energyLevel: ActivityLevel.veryHigh,
  grooming: 3,
  shedding: 3,
  childFriendliness: 1,
  beginnerFriendliness: 1,
  trainability: 5,
  exerciseNeed: 5,
  lifeExpectancyYears: 12,
  weightKgMin: 30.0,
  weightKgMax: 40.0,
  monthlyCostEur: 100,
  commonHealthIssues: [],
  traits: [],
);

const _giantDog = DogBreed(
  id: 'giant-dog',
  name: 'Riesen-Hund',
  origin: 'Test',
  size: DogSize.giant,
  temperament: 'wachsam',
  description: 'Testrasse fuer Groessen-Edgecases',
  energyLevel: ActivityLevel.moderate,
  grooming: 4,
  shedding: 4,
  childFriendliness: 1,
  beginnerFriendliness: 2,
  trainability: 3,
  exerciseNeed: 4,
  lifeExpectancyYears: 9,
  weightKgMin: 60.0,
  weightKgMax: 80.0,
  monthlyCostEur: 130,
  commonHealthIssues: [],
  traits: [],
);
