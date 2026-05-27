import 'package:dogmatch_ai/features/symptom_check/domain/symptom.dart';

/// Statischer Symptom-Katalog. Bewusst breit, aber laienverstaendlich.
class SymptomCatalog {
  SymptomCatalog._();

  static const List<Symptom> all = [
    // Verdauung
    Symptom(id: 'diarrhea', label: 'Durchfall', category: SymptomCategory.digestion),
    Symptom(id: 'bloody-stool', label: 'Blut im Kot', category: SymptomCategory.digestion),
    Symptom(id: 'vomit', label: 'Erbrechen', category: SymptomCategory.digestion),
    Symptom(id: 'frequent-vomit', label: 'Mehrfach am Tag Erbrechen', category: SymptomCategory.digestion),
    Symptom(id: 'bloat', label: 'Aufgeblaehter Bauch', category: SymptomCategory.digestion),
    Symptom(id: 'no-poop', label: 'Kein Kotabsatz mehr', category: SymptomCategory.digestion),

    // Appetit
    Symptom(id: 'no-appetite', label: 'Frisst nicht', category: SymptomCategory.appetite),
    Symptom(id: 'no-drink', label: 'Trinkt nicht', category: SymptomCategory.appetite),
    Symptom(id: 'much-drink', label: 'Trinkt viel mehr als sonst', category: SymptomCategory.appetite),

    // Energie & Verhalten
    Symptom(id: 'apathy', label: 'Apathisch, will nicht aufstehen', category: SymptomCategory.energy),
    Symptom(id: 'restless', label: 'Unruhig, jault', category: SymptomCategory.energy),
    Symptom(id: 'aggression', label: 'Ploetzlich aggressiv', category: SymptomCategory.energy),
    Symptom(id: 'shaking', label: 'Zittert', category: SymptomCategory.energy),
    Symptom(id: 'collapse', label: 'Zusammengebrochen / bewusstlos', category: SymptomCategory.energy),
    Symptom(id: 'fever', label: 'Heisse Ohren / sichtbar Fieber', category: SymptomCategory.energy),

    // Haut & Fell
    Symptom(id: 'itching', label: 'Kratzt sich viel', category: SymptomCategory.skin),
    Symptom(id: 'bald-spots', label: 'Kahle Stellen im Fell', category: SymptomCategory.skin),
    Symptom(id: 'red-skin', label: 'Gerotete oder entzuendete Haut', category: SymptomCategory.skin),
    Symptom(id: 'open-wound', label: 'Offene Wunde', category: SymptomCategory.skin),
    Symptom(id: 'tick', label: 'Zecke gefunden', category: SymptomCategory.skin),

    // Atmung
    Symptom(id: 'cough', label: 'Husten', category: SymptomCategory.breathing),
    Symptom(id: 'choking-cough', label: 'Wuergehusten / als wuerde Hund ersticken', category: SymptomCategory.breathing),
    Symptom(id: 'breath-fast', label: 'Hechelt extrem stark', category: SymptomCategory.breathing),
    Symptom(id: 'blue-tongue', label: 'Blaeuliche Zunge / Maul', category: SymptomCategory.breathing),

    // Bewegung
    Symptom(id: 'limping', label: 'Lahmt', category: SymptomCategory.movement),
    Symptom(id: 'wont-walk', label: 'Will nicht laufen', category: SymptomCategory.movement),
    Symptom(id: 'pain-touch', label: 'Schreit auf bei Beruehrung', category: SymptomCategory.movement),
    Symptom(id: 'wobbly', label: 'Geht torkelnd / unsicher', category: SymptomCategory.movement),

    // Sonstiges
    Symptom(id: 'ate-poison', label: 'Hat Schokolade / Trauben / Onion gefressen', category: SymptomCategory.other),
    Symptom(id: 'ate-foreign', label: 'Fremdkoerper gefressen (Knochen, Plastik)', category: SymptomCategory.other),
    Symptom(id: 'red-eye', label: 'Auge gerotet / traent', category: SymptomCategory.other),
    Symptom(id: 'ear-shake', label: 'Schuettelt staendig den Kopf', category: SymptomCategory.other),
  ];
}
