import 'package:dogmatch_ai/features/behavior_check/data/behavior_engine.dart';
import 'package:dogmatch_ai/features/behavior_check/domain/behavior.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BehaviorEngine', () {
    test('Leere Auswahl liefert keine Empfehlung', () {
      final result = BehaviorEngine.analyze({});
      expect(result, isEmpty);
    });

    test('Aggression gegen Kinder triggert hoechste Stufe (vet)', () {
      final result = BehaviorEngine.analyze({'aggression-children'});
      expect(result, isNotEmpty);
      expect(result.first.priority, BehaviorPriority.vet);
    });

    test('Leinen-Ziehen verlinkt auf "heel"-Trainingsplan', () {
      final result = BehaviorEngine.analyze({'leash-pull'});
      expect(result.any((a) => a.trainingPlanId == 'heel'), isTrue);
    });

    test('Kein Rueckruf verlinkt auf "recall"-Trainingsplan', () {
      final result = BehaviorEngine.analyze({'no-recall'});
      expect(result.any((a) => a.trainingPlanId == 'recall'), isTrue);
    });

    test(
        'Notfall-Empfehlung steht vor Trainings-Empfehlung in der Liste',
        () {
      final result = BehaviorEngine.analyze({
        'sudden-change',
        'leash-pull',
      });
      expect(result.first.priority, BehaviorPriority.vet);
    });
  });
}
