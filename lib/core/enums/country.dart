/// Laender, fuer die DogMatch AI rechtliche und praktische Hunde-Infos
/// kennt. Wird sowohl im Nutzer-Profil als auch in den rassen-spezifischen
/// Laender-Hinweisen verwendet.
///
/// DACH-Laender (DE / AT / CH) haben aktuell die ausfuehrlichsten Daten in
/// `breeds.json`. Fuer alle weiteren Laender zeigt die UI einen Hinweis
/// "Noch keine landesspezifischen Infos hinterlegt." - das System bleibt
/// trotzdem nutzbar fuer Profil + KI-Prompt.
///
/// Reihenfolge: DACH zuerst, dann grosse europaeische Nachbarn alphabetisch,
/// dann nicht-europaeische Hund-Maerkte.
enum Country {
  // DACH (vollstaendige Hunde-Infos)
  germany('Deutschland', 'DE'),
  austria('Oesterreich', 'AT'),
  switzerland('Schweiz', 'CH'),

  // Westeuropa
  belgium('Belgien', 'BE'),
  france('Frankreich', 'FR'),
  ireland('Irland', 'IE'),
  italy('Italien', 'IT'),
  luxembourg('Luxemburg', 'LU'),
  netherlands('Niederlande', 'NL'),
  portugal('Portugal', 'PT'),
  spain('Spanien', 'ES'),
  unitedKingdom('Vereinigtes Koenigreich', 'GB'),

  // Nordeuropa
  denmark('Daenemark', 'DK'),
  finland('Finnland', 'FI'),
  iceland('Island', 'IS'),
  norway('Norwegen', 'NO'),
  sweden('Schweden', 'SE'),

  // Mittel-/Osteuropa
  czechia('Tschechien', 'CZ'),
  hungary('Ungarn', 'HU'),
  poland('Polen', 'PL'),
  slovakia('Slowakei', 'SK'),
  slovenia('Slowenien', 'SI'),

  // Suedeuropa
  croatia('Kroatien', 'HR'),
  greece('Griechenland', 'GR'),

  // Nicht-Europa
  australia('Australien', 'AU'),
  brazil('Brasilien', 'BR'),
  canada('Kanada', 'CA'),
  newZealand('Neuseeland', 'NZ'),
  unitedStates('Vereinigte Staaten', 'US'),
  other('Anderes Land', 'XX');

  const Country(this.label, this.code);

  final String label;
  final String code;

  static Country fromCode(String? code) {
    for (final c in Country.values) {
      if (c.code == code) return c;
    }
    return Country.germany;
  }
}
