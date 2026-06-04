/// Ein Antrags-/Formular-Typ rund um den Hund (z. B. Hundesteuer anmelden).
class DogForm {
  const DogForm({
    required this.title,
    required this.purpose,
    required this.fillHelp,
    required this.url,
  });

  final String title;

  /// Wofuer braucht man das? (kurz)
  final String purpose;

  /// Ausfuellhilfe: welche Angaben/Unterlagen man bereithalten sollte.
  final List<String> fillHelp;

  /// Offizielle Anlauf-/Antragsseite.
  final String url;
}

/// Antraege pro Bundesland. Die Hundesteuer ist kommunal - der Link fuehrt
/// daher auf das jeweilige Landesportal / die uebliche Anlaufstelle, von wo
/// aus die zustaendige Gemeinde gefunden wird.
class BundeslandForms {
  const BundeslandForms({required this.name, required this.forms});
  final String name;
  final List<DogForm> forms;
}

class FormCatalog {
  FormCatalog._();

  // Bundesweit gleiche Ausfuellhilfen - wiederverwendet pro Bundesland.
  static const _steuerHelp = [
    'Personalausweis / Meldeadresse',
    'Anschaffungs- bzw. Zuzugsdatum des Hundes',
    'Rasse, Wurftag, Geschlecht, Chip-Nummer',
    'Bei mehreren Hunden: Angaben zu jedem Hund (oft hoeherer Satz)',
    'Ggf. Nachweis ueber Hundehaftpflicht',
  ];
  static const _sachkundeHelp = [
    'Personalausweis',
    'Ggf. Nachweis Theorie- + Praxisteil (je nach Land/Rasse)',
    'Hund mit gueltiger Tollwutimpfung + Chip',
    'Hundehaftpflicht-Police',
  ];
  static const _listeHelp = [
    'Fuehrungszeugnis (oft verlangt)',
    'Sachkundenachweis / Hundefuehrerschein',
    'Hundehaftpflicht mit ausreichender Deckung',
    'Wesenstest des Hundes (je nach Land/Rasse)',
    'Chip-Nummer + Tollwutimpfung',
  ];

  static const List<BundeslandForms> all = [
    BundeslandForms(name: 'Baden-Wuerttemberg', forms: [
      DogForm(
        title: 'Hundesteuer anmelden',
        purpose: 'Pflicht - bei der Wohnsitz-Gemeinde.',
        fillHelp: _steuerHelp,
        url: 'https://www.service-bw.de',
      ),
      DogForm(
        title: 'Sachkunde / Listenhund-Erlaubnis',
        purpose: 'Fuer Kampfhunde-Verordnung BW.',
        fillHelp: _listeHelp,
        url: 'https://www.service-bw.de',
      ),
    ]),
    BundeslandForms(name: 'Bayern', forms: [
      DogForm(
        title: 'Hundesteuer anmelden',
        purpose: 'Pflicht - bei der Gemeinde/Stadt.',
        fillHelp: _steuerHelp,
        url: 'https://www.freistaat.bayern',
      ),
      DogForm(
        title: 'Negativzeugnis Kampfhund',
        purpose: 'Wesenstest, um Listenhund-Auflagen zu entfallen.',
        fillHelp: _listeHelp,
        url: 'https://www.freistaat.bayern',
      ),
    ]),
    BundeslandForms(name: 'Berlin', forms: [
      DogForm(
        title: 'Hundesteuer anmelden',
        purpose: 'Pflicht - beim Finanzamt Berlin (zentral).',
        fillHelp: _steuerHelp,
        url: 'https://www.berlin.de/sen/finanzen/steuern/',
      ),
      DogForm(
        title: 'Hundefuehrerschein (Sachkunde)',
        purpose: 'In Berlin grundsaetzlich Pflicht (Hundegesetz).',
        fillHelp: _sachkundeHelp,
        url: 'https://www.berlin.de/sen/inneres/buerger-und-staat/',
      ),
    ]),
    BundeslandForms(name: 'Brandenburg', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://service.brandenburg.de'),
      DogForm(title: 'Erlaubnis gefaehrlicher Hund', purpose: 'Nach Hundehalterverordnung BB.', fillHelp: _listeHelp, url: 'https://service.brandenburg.de'),
    ]),
    BundeslandForms(name: 'Bremen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - Stadtgemeinde Bremen/Bremerhaven.', fillHelp: _steuerHelp, url: 'https://www.service.bremen.de'),
      DogForm(title: 'Sachkundenachweis', purpose: 'Je nach Hund nach BremHundeG.', fillHelp: _sachkundeHelp, url: 'https://www.service.bremen.de'),
    ]),
    BundeslandForms(name: 'Hamburg', forms: [
      DogForm(title: 'Hundesteuer / Hunderegister', purpose: 'Anmeldung + verpflichtendes Hunderegister.', fillHelp: _steuerHelp, url: 'https://www.hamburg.de/suche?query=Hundesteuer'),
      DogForm(title: 'Hundefuehrerschein', purpose: 'Pflicht in Hamburg (Sachkunde).', fillHelp: _sachkundeHelp, url: 'https://www.hamburg.de/suche?query=Hundef%C3%BChrerschein'),
    ]),
    BundeslandForms(name: 'Hessen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Kommune.', fillHelp: _steuerHelp, url: 'https://service.hessen.de'),
      DogForm(title: 'Erlaubnis gefaehrlicher Hund', purpose: 'Nach HundeVO Hessen.', fillHelp: _listeHelp, url: 'https://service.hessen.de'),
    ]),
    BundeslandForms(name: 'Mecklenburg-Vorpommern', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.mv-serviceportal.de'),
      DogForm(title: 'Sachkunde / Erlaubnis', purpose: 'Nach HundehVO M-V.', fillHelp: _listeHelp, url: 'https://www.mv-serviceportal.de'),
    ]),
    BundeslandForms(name: 'Niedersachsen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.service.niedersachsen.de'),
      DogForm(title: 'Sachkundenachweis (Pflicht)', purpose: 'In NDS fuer alle Hundehalter (Theorie + Praxis) + Hunderegister.', fillHelp: _sachkundeHelp, url: 'https://www.ml.niedersachsen.de'),
    ]),
    BundeslandForms(name: 'Nordrhein-Westfalen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Stadt/Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.service.nrw'),
      DogForm(title: 'Sachkunde / Erlaubnis (LHundG)', purpose: 'Sachkunde ab bestimmter Groesse/Gewicht; Erlaubnis fuer gefaehrliche Hunde.', fillHelp: _listeHelp, url: 'https://www.service.nrw'),
    ]),
    BundeslandForms(name: 'Rheinland-Pfalz', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Verbandsgemeinde.', fillHelp: _steuerHelp, url: 'https://www.rlp.de'),
      DogForm(title: 'Erlaubnis gefaehrlicher Hund', purpose: 'Nach LHundG RLP.', fillHelp: _listeHelp, url: 'https://www.rlp.de'),
    ]),
    BundeslandForms(name: 'Saarland', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.saarland.de'),
      DogForm(title: 'Sachkunde / Erlaubnis', purpose: 'Nach Hundegesetz Saarland.', fillHelp: _listeHelp, url: 'https://www.saarland.de'),
    ]),
    BundeslandForms(name: 'Sachsen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://amt24.sachsen.de'),
      DogForm(title: 'Erlaubnis gefaehrlicher Hund', purpose: 'Nach SaechsGefHundG.', fillHelp: _listeHelp, url: 'https://amt24.sachsen.de'),
    ]),
    BundeslandForms(name: 'Sachsen-Anhalt', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.sachsen-anhalt.de'),
      DogForm(title: 'Sachkundenachweis', purpose: 'Nach HundeG LSA.', fillHelp: _sachkundeHelp, url: 'https://www.sachsen-anhalt.de'),
    ]),
    BundeslandForms(name: 'Schleswig-Holstein', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://serviceportal.schleswig-holstein.de'),
      DogForm(title: 'Sachkunde / Erlaubnis', purpose: 'Nach HundeG SH.', fillHelp: _listeHelp, url: 'https://serviceportal.schleswig-holstein.de'),
    ]),
    BundeslandForms(name: 'Thueringen', forms: [
      DogForm(title: 'Hundesteuer anmelden', purpose: 'Pflicht - bei der Gemeinde.', fillHelp: _steuerHelp, url: 'https://www.thueringen.de'),
      DogForm(title: 'Erlaubnis gefaehrlicher Hund', purpose: 'Nach ThuerGefTierVO.', fillHelp: _listeHelp, url: 'https://www.thueringen.de'),
    ]),
  ];
}
