import 'package:dogmatch_ai/features/tips/domain/dog_tip.dart';

/// Kuratierte Tipp-Sammlung. Bewusst hardcoded statt JSON, damit der
/// Build keine zusaetzlichen Assets braucht und der Inhalt mit dem Code
/// reviewbar bleibt.
class TipsCatalog {
  TipsCatalog._();

  static const List<DogTip> all = [
    // ---- Alltag ----
    DogTip(
      id: 'd1',
      category: TipCategory.daily,
      title: 'Feste Routinen geben Halt',
      body: 'Hunde sind Gewohnheitstiere. Gleiche Spaziergeh- und '
          'Fuetterungs-Zeiten reduzieren Stress und Trennungsangst. '
          'Schon 15-20 Minuten Verschiebung koennen sensible Hunde irritieren.',
    ),
    DogTip(
      id: 'd2',
      category: TipCategory.daily,
      title: 'Nasenarbeit ermuedet schneller als Rennen',
      body: '10 Minuten Schnueffel-Spiel = 60 Minuten Joggen, was die '
          'mentale Auslastung angeht. Leckerli in Decken verstecken oder '
          'eine Schnueffel-Wiese im Garten reicht schon.',
    ),
    DogTip(
      id: 'd3',
      category: TipCategory.daily,
      title: 'Ruhepausen sind kein Faulsein',
      body: 'Gesunde Hunde schlafen 17-20 Stunden pro Tag. Wenn dein Hund '
          'in der Wohnung aktiv "abhaengt", ist das gesund. Erzwinge keine '
          'Bespassung - du wuerdest ihn sonst nervlich ueberlasten.',
    ),
    DogTip(
      id: 'd4',
      category: TipCategory.daily,
      title: 'Trinkschale immer frisch',
      body: 'Wasser mindestens einmal pro Tag wechseln. Im Sommer 2-3 mal. '
          'Steinzeug- oder Edelstahl-Naepfe sind keimfreier als Plastik.',
    ),

    // ---- Gesundheit ----
    DogTip(
      id: 'h1',
      category: TipCategory.health,
      title: 'Zahnstein vorbeugen, nicht behandeln',
      body: 'Taegliches Kauen (Kauknochen, getrocknete Rindersehnen) '
          'reduziert Zahnstein massiv. Hunde, die nur Weichfutter kriegen, '
          'brauchen oft schon mit 4-5 Jahren eine Zahnreinigung in Narkose.',
    ),
    DogTip(
      id: 'h2',
      category: TipCategory.health,
      title: 'Krallenpflege - der Klick-Test',
      body: 'Wenn du Krallen-Klicken beim Gehen auf Hartboden hoerst, sind '
          'sie zu lang. Zu lange Krallen drehen die Pfotenstellung und '
          'schaedigen die Gelenke langfristig.',
    ),
    DogTip(
      id: 'h3',
      category: TipCategory.health,
      title: 'Zecken nach jedem Spaziergang',
      body: 'Besonders an Ohren, Halsband-Bereich, Achseln und zwischen '
          'den Zehen. Zecken-Zange greift direkt an der Haut, langsam '
          'gerade rausziehen - nicht drehen.',
    ),
    DogTip(
      id: 'h4',
      category: TipCategory.health,
      title: 'Erbrechen + Durchfall > 24h = Tierarzt',
      body: 'Einmaliges Erbrechen ist meist harmlos. Mehrfach + Apathie + '
          'kein Trinken = sofort Tierarzt, besonders bei Welpen und '
          'aelteren Hunden (Dehydrierung).',
    ),
    DogTip(
      id: 'h5',
      category: TipCategory.health,
      title: 'Impfungen nicht "wegen Alter" weglassen',
      body: 'Auch alte Hunde brauchen Tollwut + Staupe-Auffrischung. Frag '
          'deinen Tierarzt nach Titer-Bestimmung, falls du seltener impfen '
          'willst - die Antwort liegt im Blut.',
    ),

    // ---- Ernaehrung ----
    DogTip(
      id: 'n1',
      category: TipCategory.nutrition,
      title: 'Schoko, Trauben, Zwiebeln = LEBENSGEFAHR',
      body: 'Schon kleine Mengen koennen toedlich sein. Xylit (Birkenzucker '
          'in Kaugummi), Macadamia-Nuesse und Avocado ebenfalls vermeiden. '
          'Notfall-Nummer Tiergiftnotruf ans Telefon haengen.',
    ),
    DogTip(
      id: 'n2',
      category: TipCategory.nutrition,
      title: 'Knochen nur ROH geben',
      body: 'Gekochte Knochen splittern und koennen den Darm verletzen. '
          'Rohe markhaltige Knochen passend zur Hundgroesse - immer unter '
          'Aufsicht.',
    ),
    DogTip(
      id: 'n3',
      category: TipCategory.nutrition,
      title: 'Naturjoghurt bei empfindlichem Magen',
      body: 'Probiotika aus Naturjoghurt (ohne Zucker) helfen bei leichter '
          'Verdauungsstoerung. 1 Teeloeffel pro 10 kg Koerpergewicht. Bei '
          'akuter Krankheit nicht selbst doktorn.',
    ),
    DogTip(
      id: 'n4',
      category: TipCategory.nutrition,
      title: 'Gewicht: Rippen tasten, nicht sehen',
      body: 'Du sollst die Rippen mit leichtem Druck spueren koennen, aber '
          'sie nicht sehen. Wenn du sie deutlich siehst, ist der Hund zu '
          'duenn; wenn du sie nur mit starkem Druck findest, zu dick.',
    ),

    // ---- Verhalten ----
    DogTip(
      id: 'b1',
      category: TipCategory.behavior,
      title: 'Bellen hat IMMER einen Grund',
      body: 'Langeweile, Angst, Schutz, Spielaufforderung oder Schmerz. '
          'Den Grund finden statt nur "Aus" zu schreien - sonst loest du '
          'das Symptom, nicht die Ursache.',
    ),
    DogTip(
      id: 'b2',
      category: TipCategory.behavior,
      title: 'Bauch zeigen = Vertrauen',
      body: 'Bei entspanntem Koerper. Wenn der Hund hingegen steif liegt, '
          'die Augen aufreisst und die Lefzen zurueckzieht - das ist '
          'Beschwichtigung, kein "kraul mich".',
    ),
    DogTip(
      id: 'b3',
      category: TipCategory.behavior,
      title: 'Abgewandter Blick = "Lass mich"',
      body: 'Wenn dein Hund den Kopf wegdreht, ist das ein hoefliches '
          'Stopp-Signal. Akzeptiere es. Erzwingst du Kontakt, lernt er, '
          'dass nur deutliches Knurren wirklich gehoert wird.',
    ),
    DogTip(
      id: 'b4',
      category: TipCategory.behavior,
      title: 'Anspringen ignorieren, nicht knien',
      body: 'Wende dich kommentarlos ab. Wenn alle Pfoten am Boden sind: '
          'ruhig loben. Kein Schubsen - das ist fuer den Hund Aufmerksamkeit '
          'und verstaerkt das Verhalten.',
    ),

    // ---- Pflege ----
    DogTip(
      id: 'c1',
      category: TipCategory.care,
      title: 'Buersten - lang vs. kurz',
      body: 'Langhaarige Rassen mindestens 2-3 Mal pro Woche, kurzhaarige '
          'einmal pro Woche reicht. Im Fellwechsel taeglich - sonst gibt '
          'es im Wohnzimmer Teppiche aus Haaren.',
    ),
    DogTip(
      id: 'c2',
      category: TipCategory.care,
      title: 'Ohren regelmaessig checken',
      body: 'Riech-Test: muffiger oder hefiger Geruch deutet auf Infektion '
          'hin. Nicht mit Wattestaebchen tief ins Ohr - nur sichtbaren '
          'Bereich mit weichem Tuch reinigen.',
    ),
    DogTip(
      id: 'c3',
      category: TipCategory.care,
      title: 'Baden nur bei Bedarf',
      body: 'Maximal 1x pro Monat, sonst leidet die Schutzschicht der '
          'Haut. Hunde-Shampoo (pH-neutral fuer Hund), kein Menschen-'
          'Produkt verwenden.',
    ),
    DogTip(
      id: 'c4',
      category: TipCategory.care,
      title: 'Pfoten nach jedem Gang abwischen',
      body: 'Im Winter wegen Streusalz, sonst wegen Bakterien. Kontrolliere '
          'die Pfotenballen auf Risse - Pfotenbalsam (z.B. mit Sheabutter) '
          'beugt vor.',
    ),

    // ---- Sommer ----
    DogTip(
      id: 's1',
      category: TipCategory.summer,
      title: 'Asphalt-Pfotentest',
      body: '5 Sekunden Handflaeche auf dem Boden: schmerzt es dir, '
          'verbrennt es die Pfoten. Bei ueber 25 Grad C lieber Schatten-'
          'wege und morgens / spaet abends spazieren.',
    ),
    DogTip(
      id: 's2',
      category: TipCategory.summer,
      title: 'NIEMALS im Auto lassen',
      body: 'Auch nicht "nur 5 Minuten" mit Fenster auf Spalt. Bei '
          '25 Grad C draussen sind es im Auto nach 10 Minuten 45 Grad C - '
          'lebensgefaehrlich fuer Hunde.',
    ),
    DogTip(
      id: 's3',
      category: TipCategory.summer,
      title: 'Wasserstellen unterwegs',
      body: 'Faltbarer Napf + Wasserflasche immer dabei. Hunde duerfen '
          'nicht aus Pfuetzen trinken (Bakterien, Leptospirose) und nicht '
          'eiskalt - Magen-Verstimmung droht.',
    ),
    DogTip(
      id: 's4',
      category: TipCategory.summer,
      title: 'Schwimmen + Salzwasser',
      body: 'Nach dem Baden im Meer mit Suesswasser abspuelen. Salz reizt '
          'Haut und kann zu Magenbeschwerden fuehren, wenn beim Schuetteln '
          'Wasser geschluckt wird.',
    ),

    // ---- Winter ----
    DogTip(
      id: 'w1',
      category: TipCategory.winter,
      title: 'Streusalz schadet Pfoten',
      body: 'Nach jedem Winter-Spaziergang Pfoten mit lauwarmem Wasser '
          'abspuelen. Pfotenwachs (z.B. Musher\'s Secret) als Schutz '
          'vor dem Gang auftragen.',
    ),
    DogTip(
      id: 'w2',
      category: TipCategory.winter,
      title: 'Mantel bei Mini-Hunden + Senioren',
      body: 'Kleine Rassen, Senioren und kranke Hunde frieren schnell. '
          'Wenn er zittert oder die Rute einklemmt: rein. Bei dichtem '
          'Fell (Husky, Bernhardiner) sind Mantel und Hund unnoetig.',
    ),
    DogTip(
      id: 'w3',
      category: TipCategory.winter,
      title: 'Frostschutzmittel ist GIFTIG',
      body: 'Schmeckt suess, ist toedlich. Verschuettete Garagen-Reste '
          'sofort wegwischen. Im Auto-Bereich Ueberwachung.',
    ),

    // ---- Sicherheit ----
    DogTip(
      id: 'sa1',
      category: TipCategory.safety,
      title: 'Chip-Daten aktuell halten',
      body: 'Umzug oder neue Handynummer? Sofort bei TASSO / Animaldata / '
          'IFTA aktualisieren. Sonst hilft auch der beste Chip nicht, '
          'wenn der Hund verloren geht.',
    ),
    DogTip(
      id: 'sa2',
      category: TipCategory.safety,
      title: 'Notfall-Nummer in der Brieftasche',
      body: 'Tierarzt-Notdienst + Tiergiftnotruf + Adresse der naechsten '
          'Tierklinik. Im Panik-Moment willst du nicht erst googeln.',
    ),
    DogTip(
      id: 'sa3',
      category: TipCategory.safety,
      title: 'Halsband mit Telefonnummer',
      body: 'Markenanhaenger mit deiner Mobilnummer + "Chipnr. registriert". '
          'Wer den Hund findet, ruft sofort an, statt in den Tierheim-'
          'Pfad zu rutschen.',
    ),
    DogTip(
      id: 'sa4',
      category: TipCategory.safety,
      title: 'Schleppleine waehrend des Rueckruf-Trainings',
      body: '10-15 m als Sicherung. Lass sie NIE haengen wenn der Hund '
          'rennt - Verfangungs-Gefahr. Trainings-Werkzeug, kein Dauer-'
          'Ersatz fuer Leine.',
    ),

    // ---- Sozialisierung ----
    DogTip(
      id: 'so1',
      category: TipCategory.socialization,
      title: 'Welpen: alles vor der 16. Lebenswoche',
      body: 'Was er in dieser Zeit kennenlernt (Kinder, Autos, Treppen, '
          'andere Tiere), bleibt entspannt. Was er erst spaeter sieht, '
          'kann ein Leben lang Stress machen.',
    ),
    DogTip(
      id: 'so2',
      category: TipCategory.socialization,
      title: 'Hundebegegnungen ohne Direkt-Frontal',
      body: 'Bogen laufen statt direkt aufeinander zu. Direkter Blickkontakt '
          'aus naechster Naehe = bei Hunden Provokation. Mit etwas Distanz '
          'ist alles ruhig.',
    ),
    DogTip(
      id: 'so3',
      category: TipCategory.socialization,
      title: 'Kinder lernen Hunde-Sprache',
      body: 'Erklaere Kindern: Bauch streicheln, nicht ueber den Kopf '
          'fassen, niemals waehrend er frisst stoeren. So bleiben beide '
          'Seiten sicher.',
    ),
    DogTip(
      id: 'so4',
      category: TipCategory.socialization,
      title: 'Gleichgesinnte Hunde-Freunde suchen',
      body: 'Ein ruhiger Senior-Hund ist die beste Schule fuer junge '
          'Wilde. Hundeplaetze ohne Filter koennen das Gegenteil bringen.',
    ),
  ];

  static List<DogTip> byCategory(TipCategory? cat) {
    if (cat == null) return all;
    return all.where((t) => t.category == cat).toList(growable: false);
  }
}
