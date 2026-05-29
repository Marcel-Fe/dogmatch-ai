/// Pflicht-Informationen fuer Reisen mit Hund in europaeische Laender.
/// Inhalte sind allgemeine Hinweise, KEIN Rechts-Rat - im Zweifel
/// offizielle Botschafts-Webseite checken.
class TravelRule {
  const TravelRule({
    required this.country,
    required this.flag,
    required this.muzzleRule,
    required this.leashRule,
    required this.rabiesRule,
    required this.passportRule,
    required this.listenhundRule,
    this.transitNote,
    this.specialNote,
  });

  final String country;
  final String flag;
  final String muzzleRule;
  final String leashRule;
  final String rabiesRule;
  final String passportRule;
  final String listenhundRule;
  final String? transitNote;
  final String? specialNote;
}

class TravelRules {
  TravelRules._();

  static const List<TravelRule> all = [
    TravelRule(
      country: 'Deutschland',
      flag: '🇩🇪',
      muzzleRule:
          'In oeffentlichen Verkehrsmitteln meist Pflicht. Listenhunde in fast allen Bundeslaendern Maulkorb-Pflicht.',
      leashRule:
          'Leinenpflicht regional verschieden - in Staedten in der Regel Pflicht, in Naturschutzgebieten ueberall.',
      rabiesRule:
          'Tollwut-Impfung im EU-Heimtierausweis, mind. 21 Tage vor Reise.',
      passportRule: 'EU-Heimtierausweis + Chip-Nummer Pflicht.',
      listenhundRule:
          'Listenhund-Verordnungen je Bundesland verschieden - vor Einreise pruefen!',
    ),
    TravelRule(
      country: 'Oesterreich',
      flag: '🇦🇹',
      muzzleRule:
          'Maulkorb-Pflicht in oeffentlichen Verkehrsmitteln, Restaurants, Skigebieten. In Wien zusaetzlich Beisskorb-Schein fuer Listenhunde.',
      leashRule: 'Leinenpflicht in Staedten + Wanderwegen mit Weidevieh.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung, mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Wien hat besonders strenge Regeln - Hundefuehrerschein fuer "Listenhunde" notwendig.',
    ),
    TravelRule(
      country: 'Schweiz',
      flag: '🇨🇭',
      muzzleRule:
          'Maulkorb in oeffentlichen Verkehrsmitteln vorgeschrieben. Listenhunde in einigen Kantonen mit Maulkorb-Pflicht.',
      leashRule:
          'Leinenpflicht in vielen Kantonen Pflicht - besonders Naturschutzgebiete + Wald.',
      rabiesRule:
          'Tollwut-Impfung mind. 21 Tage alt. EU-Heimtierausweis akzeptiert.',
      passportRule:
          'EU-Heimtierausweis + Chip-Nummer. Bei Einreise aus Drittlaendern Tierarzt-Attest.',
      listenhundRule:
          'Stark kantonal geregelt - Tessin, Wallis und Genf besonders streng.',
    ),
    TravelRule(
      country: 'Frankreich',
      flag: '🇫🇷',
      muzzleRule:
          'Categorie 1 + 2 Hunde (Listenhunde) MUSS Maulkorb tragen, in OePNV auch andere Hunde.',
      leashRule: 'Leinenpflicht in Staedten, Parks und am Strand.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule:
          'EU-Heimtierausweis Pflicht. Hunde unter 3 Monaten Einreise verboten.',
      listenhundRule:
          'Kategorie-1-Hunde (z.B. Pitbull-Typ) DARF Frankreich NICHT betreten.',
      specialNote:
          'Auf Korsika ist Hund am Strand zwischen Juni - September meist verboten.',
    ),
    TravelRule(
      country: 'Italien',
      flag: '🇮🇹',
      muzzleRule:
          'Maulkorb + Leine MUSS in oeffentlichen Orten mitgefuehrt werden - auch wenn nicht aktiv getragen.',
      leashRule:
          'Leinenpflicht 1,5 m in Staedten + oeffentlichen Verkehrsmitteln.',
      rabiesRule: 'Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Keine offizielle Rasseliste - aber regionale Maulkorb-Auflagen moeglich.',
      specialNote:
          'Hunde am Strand: regional sehr verschieden - meist nur in eigenen "dog beach"-Bereichen.',
    ),
    TravelRule(
      country: 'Niederlande',
      flag: '🇳🇱',
      muzzleRule: 'Kein generelles Gebot - oeffentl. Verkehr meist ohne.',
      leashRule:
          'Leinenpflicht in Staedten, in Naturschutzgebieten ebenfalls.',
      rabiesRule: 'EU-Standard: 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Hat KEINE generelle Rasseliste - Beissigkeits-Verordnung individuell.',
    ),
    TravelRule(
      country: 'Spanien',
      flag: '🇪🇸',
      muzzleRule:
          'Listenhunde MUSS Maulkorb tragen, dazu Sondergenehmigung + Versicherung mit hoeherer Deckung.',
      leashRule: 'Leinenpflicht 2 m in Staedten + Wanderwegen.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Listenhunde-Auflagen je Region - in Katalonien strenger als in Andalusien.',
      specialNote:
          'Strandsaison: viele Straende untersagen Hunde von Juni - September.',
    ),
    TravelRule(
      country: 'Daenemark',
      flag: '🇩🇰',
      muzzleRule: 'Listenhunde MUSS draussen Maulkorb tragen.',
      leashRule: 'Leinenpflicht ueberall, ausser ausgewiesenen Hundewaeldern.',
      rabiesRule: 'EU-Standard.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'STRENGE Listenhund-Verordnung - 13 Rassen VERBOTEN (Pitbull, Tosa, etc.). Bei Verstoss: Beschlagnahme.',
    ),
    TravelRule(
      country: 'Schweden',
      flag: '🇸🇪',
      muzzleRule: 'Kein generelles Gebot.',
      leashRule:
          'Leinenpflicht 1. Maerz - 20. August (Brutzeit der Wildtiere).',
      rabiesRule:
          'Tollwut-Impfung mind. 21 Tage alt. Bei Einreise per Flug: Anmeldung beim Schwedischen Tieramt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule: 'Keine generelle Rasseliste.',
    ),
    TravelRule(
      country: 'Norwegen',
      flag: '🇳🇴',
      muzzleRule: 'Kein generelles Gebot.',
      leashRule:
          'Leinenpflicht 1. April - 20. August. In National-Parks ganzjaehrig.',
      rabiesRule:
          'Tollwut-Impfung + Bandwurm-Behandlung 24-120 h vor Einreise.',
      passportRule: 'EU-Heimtierausweis + ausgefuelltes Norwegen-Formular.',
      listenhundRule:
          'Strenge Listenhund-Verordnung - mehrere Rassen verboten (Pitbull, Tosa, American Bulldog).',
      transitNote:
          'Bei Einreise per Faehre: vorab beim norwegischen Zoll anmelden.',
    ),
    TravelRule(
      country: 'Vereinigtes Koenigreich',
      flag: '🇬🇧',
      muzzleRule:
          'Pitbull-Typ + 3 weitere Rassen MUESSEN Maulkorb + Leine tragen.',
      leashRule: 'Leinenpflicht in Staedten + Naturschutzgebieten.',
      rabiesRule:
          'Tollwut-Impfung mind. 21 Tage alt + Bandwurm-Behandlung 1-5 Tage vor Einreise.',
      passportRule:
          'EU-Heimtierausweis seit Brexit nicht mehr ausreichend - Animal Health Certificate (AHC) noetig.',
      listenhundRule:
          'Dangerous Dogs Act 1991 verbietet u.a. Pitbull, Japanese Tosa, Dogo Argentino - bei Einreise BESCHLAGNAHME.',
      transitNote:
          'Anmeldung bei DEFRA vor Reise. Fliegen oft nur als Fracht moeglich.',
    ),
  ];
}
