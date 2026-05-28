import 'package:dogmatch_ai/features/behavior_check/domain/behavior.dart';

class BehaviorCatalog {
  BehaviorCatalog._();

  static const List<Behavior> all = [
    // Bellen
    Behavior(id: 'bark-strangers', label: 'Bellt fremde Menschen an', category: BehaviorCategory.barking),
    Behavior(id: 'bark-dogs', label: 'Bellt andere Hunde an', category: BehaviorCategory.barking),
    Behavior(id: 'bark-alone', label: 'Bellt wenn er allein ist', category: BehaviorCategory.barking),
    Behavior(id: 'bark-doorbell', label: 'Bellt an Tuer / Klingel exzessiv', category: BehaviorCategory.barking),
    Behavior(id: 'whining', label: 'Winselt staendig', category: BehaviorCategory.barking),

    // Leine
    Behavior(id: 'leash-pull', label: 'Zieht stark an der Leine', category: BehaviorCategory.leash),
    Behavior(id: 'leash-aggression', label: 'Geht an der Leine andere Hunde an', category: BehaviorCategory.leash),
    Behavior(id: 'leash-fear', label: 'Hat Angst vor Leine / blockiert', category: BehaviorCategory.leash),
    Behavior(id: 'no-recall', label: 'Hoert nicht auf Rueckruf', category: BehaviorCategory.leash),

    // Angst
    Behavior(id: 'separation-anxiety', label: 'Trennungsangst (zerstoert, kotet, jault)', category: BehaviorCategory.fear),
    Behavior(id: 'fear-noises', label: 'Angst vor lauten Geraeuschen (Gewitter, Silvester)', category: BehaviorCategory.fear),
    Behavior(id: 'fear-people', label: 'Angst vor Menschen', category: BehaviorCategory.fear),
    Behavior(id: 'fear-vet', label: 'Panik beim Tierarzt', category: BehaviorCategory.fear),

    // Aggression
    Behavior(id: 'aggression-people', label: 'Aggressiv gegen Menschen', category: BehaviorCategory.aggression),
    Behavior(id: 'aggression-family', label: 'Knurrt eigene Familienmitglieder an', category: BehaviorCategory.aggression),
    Behavior(id: 'resource-guarding', label: 'Verteidigt Futter / Spielzeug', category: BehaviorCategory.aggression),
    Behavior(id: 'aggression-children', label: 'Aggression gegen Kinder', category: BehaviorCategory.aggression),

    // Sozial
    Behavior(id: 'no-other-dogs', label: 'Vertraegt sich nicht mit anderen Hunden', category: BehaviorCategory.social),
    Behavior(id: 'jumps-up', label: 'Springt Menschen an', category: BehaviorCategory.social),
    Behavior(id: 'mount-humans', label: 'Reitet auf Menschen / Beinen', category: BehaviorCategory.social),

    // Stubenreinheit
    Behavior(id: 'pee-indoors', label: 'Macht in der Wohnung Pipi', category: BehaviorCategory.housetraining),
    Behavior(id: 'poop-indoors', label: 'Setzt Kot in der Wohnung ab', category: BehaviorCategory.housetraining),
    Behavior(id: 'mark-indoors', label: 'Markiert in der Wohnung', category: BehaviorCategory.housetraining),

    // Aktivitaet
    Behavior(id: 'destructive', label: 'Zerstoert Moebel / Gegenstaende', category: BehaviorCategory.activity),
    Behavior(id: 'too-much-energy', label: 'Findet keine Ruhe, dreht auf', category: BehaviorCategory.activity),
    Behavior(id: 'eats-poop', label: 'Frisst eigenen / fremden Kot', category: BehaviorCategory.activity),
    Behavior(id: 'chases-cars', label: 'Jagt Autos / Fahrradfahrer', category: BehaviorCategory.activity),

    // Sonstiges
    Behavior(id: 'sudden-change', label: 'Ploetzliche Wesensveraenderung', category: BehaviorCategory.other),
    Behavior(id: 'sleep-disturbance', label: 'Schlaeft auffallend schlecht', category: BehaviorCategory.other),
  ];
}
