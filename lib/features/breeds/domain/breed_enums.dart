// Hunde-bezogene Aufzaehlungen. Jeder Wert traegt ein deutsches Label fuer
// die direkte Anzeige in der UI.

/// Groessenklasse einer Rasse.
enum DogSize {
  toy('Sehr klein'),
  small('Klein'),
  medium('Mittel'),
  large('Gross'),
  giant('Sehr gross');

  const DogSize(this.label);

  final String label;
}

/// Energie- bzw. Aktivitaetsniveau einer Rasse.
enum ActivityLevel {
  low('Niedrig'),
  moderate('Mittel'),
  high('Hoch'),
  veryHigh('Sehr hoch');

  const ActivityLevel(this.label);

  final String label;
}
