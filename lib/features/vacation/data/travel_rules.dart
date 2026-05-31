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
    TravelRule(
      country: 'Belgien',
      flag: '🇧🇪',
      muzzleRule:
          'Kein generelles Gebot. In oeffentlichen Verkehrsmitteln regional empfohlen.',
      leashRule: 'Leinenpflicht in Staedten + Parks, regional verschieden.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis + Chip Pflicht.',
      listenhundRule:
          'Rasselisten je Region (Flandern/Wallonien/Bruessel) - vorab pruefen.',
    ),
    TravelRule(
      country: 'Irland',
      flag: '🇮🇪',
      muzzleRule:
          'Mehrere "restricted breeds" MUESSEN in der Oeffentlichkeit Maulkorb + Leine tragen (z.B. Rottweiler, Dobermann, Bullterrier).',
      leashRule: 'Leinenpflicht fuer gelistete Rassen, sonst regional.',
      rabiesRule:
          'Tollwut-Impfung mind. 21 Tage alt + Bandwurm-Behandlung 1-5 Tage vor Einreise.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          '11 "restricted breeds" mit Maulkorb-/Leinen- und Fuehrer-Auflagen (ab 16 Jahren).',
      transitNote:
          'Bei Anreise oft ueber Grossbritannien - dortige Regeln zusaetzlich beachten.',
    ),
    TravelRule(
      country: 'Luxemburg',
      flag: '🇱🇺',
      muzzleRule: 'Maulkorb-Pflicht fuer gelistete Hunde in der Oeffentlichkeit.',
      leashRule: 'Leinenpflicht in Staedten + oeffentlichen Verkehrsmitteln.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Gelistete Rassen brauchen Genehmigung, Haftpflicht und Wesenstest.',
    ),
    TravelRule(
      country: 'Portugal',
      flag: '🇵🇹',
      muzzleRule:
          'Gefaehrlich eingestufte Rassen MUESSEN Maulkorb + Leine tragen.',
      leashRule: 'Leinenpflicht in Staedten, am Strand oft Verbot in der Saison.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          '7 gelistete Rassen mit Pflichtversicherung, Maulkorb und Registrierung.',
      specialNote:
          'Viele Straende verbieten Hunde von Juni - September.',
    ),
    TravelRule(
      country: 'Finnland',
      flag: '🇫🇮',
      muzzleRule: 'Kein generelles Gebot.',
      leashRule:
          'Leinenpflicht 1. Maerz - 19. August (Brutzeit), in Staedten ganzjaehrig.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule: 'Keine generelle Rasseliste.',
    ),
    TravelRule(
      country: 'Island',
      flag: '🇮🇸',
      muzzleRule: 'Kein generelles Gebot - aber Hundehaltung stark reguliert.',
      leashRule: 'Leinenpflicht in fast allen Gemeinden.',
      rabiesRule:
          'Island ist tollwutfrei und hat SEHR strenge Einfuhrregeln: lange Vorlauf-Tests + Quarantaene.',
      passportRule:
          'Einfuhrgenehmigung + Quarantaene Pflicht - Monate Vorlauf einplanen.',
      listenhundRule:
          'Mehrere Rassen sind von der Einfuhr ausgeschlossen.',
      specialNote:
          'Tourismus mit eigenem Hund ist praktisch nicht moeglich - nur dauerhafte Einfuhr mit Quarantaene.',
    ),
    TravelRule(
      country: 'Tschechien',
      flag: '🇨🇿',
      muzzleRule:
          'Maulkorb in oeffentlichen Verkehrsmitteln oft Pflicht, regional auch in Staedten.',
      leashRule: 'Leinenpflicht in Staedten + Parks.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule: 'Keine landesweite Rasseliste - kommunale Regeln moeglich.',
    ),
    TravelRule(
      country: 'Ungarn',
      flag: '🇭🇺',
      muzzleRule: 'Maulkorb in oeffentlichen Verkehrsmitteln Pflicht.',
      leashRule: 'Leinenpflicht in Staedten + oeffentlichen Verkehrsmitteln.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Keine generelle Verbotsliste, aber strenge Halter-Pflichten fuer auffaellige Hunde.',
    ),
    TravelRule(
      country: 'Polen',
      flag: '🇵🇱',
      muzzleRule:
          'Maulkorb in oeffentlichen Verkehrsmitteln und fuer gelistete Rassen Pflicht.',
      leashRule: 'Leinenpflicht in Staedten + Parks.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          '11 Rassen brauchen eine Haltegenehmigung der Gemeinde.',
    ),
    TravelRule(
      country: 'Slowakei',
      flag: '🇸🇰',
      muzzleRule:
          'Maulkorb in oeffentlichen Verkehrsmitteln meist Pflicht.',
      leashRule: 'Leinenpflicht in Staedten + Parks.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule: 'Keine landesweite Rasseliste - kommunale Regeln moeglich.',
    ),
    TravelRule(
      country: 'Slowenien',
      flag: '🇸🇮',
      muzzleRule:
          'Maulkorb in oeffentlichen Verkehrsmitteln oft verlangt.',
      leashRule: 'Leinenpflicht in Staedten + Naturschutzgebieten.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Gelistete Rassen brauchen Wesenstest und besondere Halter-Auflagen.',
    ),
    TravelRule(
      country: 'Kroatien',
      flag: '🇭🇷',
      muzzleRule:
          'Maulkorb fuer gefaehrlich eingestufte Hunde, in OePNV oft generell.',
      leashRule: 'Leinenpflicht in Staedten, am Strand teils Verbot in der Saison.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule:
          'Listenhunde (u.a. Pitbull-Typ) mit Maulkorb-, Leinen- und Versicherungspflicht.',
      specialNote:
          'Viele Adria-Straende verbieten Hunde - es gibt aber ausgewiesene Hundestraende.',
    ),
    TravelRule(
      country: 'Griechenland',
      flag: '🇬🇷',
      muzzleRule: 'Kein generelles Gebot - fuer auffaellige Hunde verlangt.',
      leashRule: 'Leinenpflicht in Staedten. Streunerhunde sind verbreitet.',
      rabiesRule: 'EU-Standard: Tollwut-Impfung mind. 21 Tage alt.',
      passportRule: 'EU-Heimtierausweis Pflicht.',
      listenhundRule: 'Keine generelle Rasseliste.',
      specialNote:
          'Hohe Sommerhitze - Reisen mit Hund eher im Fruehjahr/Herbst planen.',
    ),
    TravelRule(
      country: 'Australien',
      flag: '🇦🇺',
      muzzleRule:
          'Maulkorb-Auflagen je Bundesstaat fuer "restricted breeds".',
      leashRule: 'Leinenpflicht in Staedten + Naturschutzgebieten.',
      rabiesRule:
          'Sehr strenge Einfuhr: Import-Permit, Tests und mehrwoechige Quarantaene Pflicht.',
      passportRule:
          'EU-Heimtierausweis reicht NICHT - offizielles Import-Permit + Gesundheitszeugnis noetig.',
      listenhundRule:
          'Mehrere Rassen sind von der Einfuhr ganz ausgeschlossen.',
      specialNote:
          'Urlaubsreise mit eigenem Hund ist kaum praktikabel - monatelanger Vorlauf.',
    ),
    TravelRule(
      country: 'Brasilien',
      flag: '🇧🇷',
      muzzleRule: 'Maulkorb-Auflagen je Stadt fuer grosse/auffaellige Hunde.',
      leashRule: 'Leinenpflicht in Staedten + Parks.',
      rabiesRule:
          'Tollwut-Impfung Pflicht + internationales Gesundheitszeugnis (CVI).',
      passportRule:
          'EU-Heimtierausweis reicht nicht - Veterinaerzeugnis + Vorab-Genehmigung (VIGIAGRO) noetig.',
      listenhundRule: 'Keine landesweite Verbotsliste - kommunale Regeln moeglich.',
    ),
    TravelRule(
      country: 'Kanada',
      flag: '🇨🇦',
      muzzleRule:
          'Maulkorb-Auflagen je Provinz/Stadt (z.B. Ontario fuer Pitbull-Typ).',
      leashRule: 'Leinenpflicht in Staedten + Parks.',
      rabiesRule:
          'Tollwut-Impfnachweis Pflicht (ab 3 Monate). Aus tollwutfreien Laendern Zusatznachweise.',
      passportRule:
          'EU-Heimtierausweis reicht nicht - aktueller Tollwut-Nachweis + Gesundheitszeugnis.',
      listenhundRule:
          'Ontario verbietet Pitbull-Typen; Regeln stark provinz-/stadtabhaengig.',
    ),
    TravelRule(
      country: 'Neuseeland',
      flag: '🇳🇿',
      muzzleRule: 'Maulkorb-Auflagen fuer gelistete Hunde in der Oeffentlichkeit.',
      leashRule: 'Leinenpflicht in Staedten + Naturschutzgebieten.',
      rabiesRule:
          'Sehr strenge Einfuhr: Import-Permit, Tests und Quarantaene noetig.',
      passportRule:
          'EU-Heimtierausweis reicht nicht - offizielles Import-Permit Pflicht.',
      listenhundRule:
          'Mehrere Rassen sind von der Einfuhr ausgeschlossen.',
      specialNote:
          'Urlaubsreise mit eigenem Hund kaum praktikabel - langer Vorlauf.',
    ),
    TravelRule(
      country: 'Vereinigte Staaten',
      flag: '🇺🇸',
      muzzleRule:
          'Maulkorb-/Rasse-Auflagen je Bundesstaat und Stadt sehr unterschiedlich.',
      leashRule: 'Leinenpflicht in Staedten + den meisten Parks.',
      rabiesRule:
          'Tollwut-Impfnachweis Pflicht. Einreiseregeln der CDC je Herkunftsland beachten.',
      passportRule:
          'EU-Heimtierausweis reicht nicht - Tollwut-Zeugnis + ggf. CDC-Formular.',
      listenhundRule:
          'Breed-Specific-Legislation je Stadt/County - manche verbieten Pitbull-Typen.',
      transitNote:
          'Fluglinien haben eigene strenge Vorgaben fuer Hunde in Kabine/Fracht.',
    ),
  ];
}
