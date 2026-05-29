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

    DogTip(
      id: 'd5',
      category: TipCategory.daily,
      title: 'Schnueffeln lassen statt durchmarschieren',
      body: 'Der Spaziergang ist fuer den Hund kein Sport, sondern Zeitung '
          'lesen. Lass ihn an interessanten Stellen ausgiebig schnueffeln - '
          'das lastet mehr aus als reines Strecke-Machen.',
    ),
    DogTip(
      id: 'd6',
      category: TipCategory.daily,
      title: 'Leinenfuehrigkeit kurz und taeglich ueben',
      body: '5 Minuten konzentriertes Ueben pro Tag bringen mehr als eine '
          'Stunde am Wochenende. Bleib stehen, sobald die Leine straff wird, '
          'und geh erst weiter, wenn sie wieder locker durchhaengt.',
    ),
    DogTip(
      id: 'd7',
      category: TipCategory.daily,
      title: 'Kauen baut Stress ab',
      body: 'Ein laenger anhaltender Kausnack (Kaffeeholz, getrocknete '
          'Sehne) hilft aufgedrehten Hunden beim Runterkommen. Kauen '
          'senkt nachweislich den Puls.',
    ),
    DogTip(
      id: 'd8',
      category: TipCategory.daily,
      title: 'Futter zur Beschaeftigung machen',
      body: 'Statt aus dem Napf: einen Teil der Tagesration in einen '
          'Schnueffelteppich oder ein Schleckmatten-Spiel geben. Das macht '
          'aus dem Fressen 10 Minuten Kopfarbeit.',
    ),
    DogTip(
      id: 'd9',
      category: TipCategory.daily,
      title: 'Abendritual zum Abschalten',
      body: 'Eine ruhige letzte Runde ohne Action, dann Kuscheln oder ein '
          'Kausnack. Toben kurz vor dem Schlafen macht viele Hunde nur '
          'noch aufgedrehter.',
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

    DogTip(
      id: 'h6',
      category: TipCategory.health,
      title: 'Regelmaessig wiegen statt schaetzen',
      body: 'Kleine Hunde auf der Personenwaage (du mit Hund, minus dein '
          'Gewicht), grosse beim Tierarzt. Eine schleichende Gewichtszunahme '
          'faellt sonst erst auf, wenn der Hund schon zu dick ist.',
    ),
    DogTip(
      id: 'h7',
      category: TipCategory.health,
      title: 'Analdruesen im Blick behalten',
      body: 'Rutscht der Hund mit dem Po ueber den Boden (Schlittenfahren) '
          'oder leckt staendig daran, koennen die Analdruesen verstopft '
          'sein. Nicht selbst ausdruecken - das macht der Tierarzt.',
    ),
    DogTip(
      id: 'h8',
      category: TipCategory.health,
      title: 'Augen taeglich kurz anschauen',
      body: 'Klarer, wacher Blick ist gesund. Truebung, starkes Traenen, '
          'gelb-gruener Ausfluss oder Zukneifen sind Warnzeichen. '
          'Augenprobleme koennen schnell schmerzhaft werden.',
    ),
    DogTip(
      id: 'h9',
      category: TipCategory.health,
      title: 'Wurmkur und Floh-Schutz im Rhythmus',
      body: 'Je nach Lebensweise alle 3 Monate entwurmen (oder Kotprobe '
          'untersuchen lassen). Floh- und Zeckenschutz vor allem von '
          'Fruehjahr bis Herbst nicht vergessen.',
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

    DogTip(
      id: 'n5',
      category: TipCategory.nutrition,
      title: 'Futter langsam umstellen',
      body: 'Neues Futter ueber 7 Tage einschleichen: erst 1/4 neu zu 3/4 '
          'alt, dann langsam mehr. Ein abrupter Wechsel fuehrt fast immer '
          'zu Durchfall.',
    ),
    DogTip(
      id: 'n6',
      category: TipCategory.nutrition,
      title: 'Leckerli von der Tagesration abziehen',
      body: 'Trainings-Leckerli zaehlen mit. Wer grosszuegig belohnt, sollte '
          'die Hauptmahlzeit etwas kuerzen - sonst wird aus dem braven Hund '
          'ein dicker Hund.',
    ),
    DogTip(
      id: 'n7',
      category: TipCategory.nutrition,
      title: 'Ruhe nach dem Fressen',
      body: 'Nach der Mahlzeit eine Stunde keine wilden Spiele, besonders '
          'bei grossen Rassen. Toben mit vollem Magen erhoeht das Risiko '
          'einer lebensgefaehrlichen Magendrehung.',
    ),
    DogTip(
      id: 'n8',
      category: TipCategory.nutrition,
      title: 'Tischreste sind keine Belohnung',
      body: 'Gewuerztes, Salziges und Fettiges vom Teller belastet den '
          'Hundemagen. Wer beim Essen bettelt, wurde meist heimlich '
          'gefuettert - bleib konsequent.',
    ),
    DogTip(
      id: 'n9',
      category: TipCategory.nutrition,
      title: 'Gesundes Gemuese als Snack',
      body: 'Karotte, Gurke oder ein Stueck Apfel (ohne Kerngehaeuse) sind '
          'kalorienarme Leckerli. Roh und in mundgerechten Stuecken - so '
          'bleibt das Naschen figurfreundlich.',
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

    DogTip(
      id: 'b5',
      category: TipCategory.behavior,
      title: 'Timing schlaegt Haerte',
      body: 'Lob oder Leckerli muessen innerhalb von 1-2 Sekunden nach dem '
          'richtigen Verhalten kommen. Spaeter weiss der Hund nicht mehr, '
          'wofuer - er lernt dann gar nichts.',
    ),
    DogTip(
      id: 'b6',
      category: TipCategory.behavior,
      title: 'Konsequenz statt Strenge',
      body: 'Wichtiger als laut zu sein ist, dass eine Regel immer gilt. '
          'Wenn der Hund mal aufs Sofa darf und mal nicht, versteht er '
          'das nicht - er testet dann jedes Mal neu.',
    ),
    DogTip(
      id: 'b7',
      category: TipCategory.behavior,
      title: 'Futter-Verteidigung nicht bestrafen',
      body: 'Knurren am Napf ist Kommunikation, kein Angriff. Bestrafst du '
          'es weg, schnappt der Hund irgendwann ohne Vorwarnung. Besser: '
          'Abstand halten und das Teilen positiv ueben.',
    ),
    DogTip(
      id: 'b8',
      category: TipCategory.behavior,
      title: 'Beschwichtigungssignale lesen',
      body: 'Gaehnen, ueber die Nase lecken, Wegschauen oder Pfote heben '
          'zeigen leichten Stress. Wer diese feinen Signale erkennt, kann '
          'eingreifen, bevor der Hund wirklich ueberfordert ist.',
    ),
    DogTip(
      id: 'b9',
      category: TipCategory.behavior,
      title: 'Alleinbleiben in Mini-Schritten',
      body: 'Erst Sekunden, dann Minuten, ganz langsam steigern - und immer '
          'zurueckkommen, bevor der Hund in Panik geraet. Trennungsangst '
          'entsteht durch zu grosse Spruenge am Anfang.',
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

    DogTip(
      id: 'c5',
      category: TipCategory.care,
      title: 'Zaehne mit Hundezahnpasta putzen',
      body: 'Spezielle Hunde-Zahnpasta (niemals Menschen-Zahnpasta - das '
          'enthaltene Fluorid ist giftig) und eine Fingerbuerste. Langsam '
          'gewoehnen, ein paar Mal pro Woche reicht.',
    ),
    DogTip(
      id: 'c6',
      category: TipCategory.care,
      title: 'Augenwinkel sanft saeubern',
      body: 'Verklebte Augenwinkel mit einem feuchten, weichen Tuch von '
          'aussen nach innen abwischen - fuer jedes Auge ein frisches Stueck, '
          'damit keine Keime wandern.',
    ),
    DogTip(
      id: 'c7',
      category: TipCategory.care,
      title: 'Knoten ausbuersten, nicht reissen',
      body: 'Verfilzungen mit den Fingern vorsichtig teilen und von der '
          'Spitze her ausbuersten. Festes Durchziehen tut weh und der Hund '
          'verbindet das Buersten dann mit Schmerz.',
    ),
    DogTip(
      id: 'c8',
      category: TipCategory.care,
      title: 'Pfotenfell zwischen den Ballen kuerzen',
      body: 'Bei langhaarigen Rassen wuchert dort Fell, das verfilzt und '
          'Schnee oder Schmutz sammelt. Mit abgerundeter Schere vorsichtig '
          'stutzen - das verbessert auch den Halt auf glattem Boden.',
    ),
    DogTip(
      id: 'c9',
      category: TipCategory.care,
      title: 'Doppeltes Fell nicht scheren',
      body: 'Hunde mit Unterwolle (z.B. Spitz, Schaeferhund) niemals kahl '
          'scheren - das Fell isoliert gegen Hitze UND Kaelte. Ausbuersten '
          'der losen Unterwolle ist der richtige Weg.',
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

    DogTip(
      id: 's5',
      category: TipCategory.summer,
      title: 'Hitzschlag erkennen und handeln',
      body: 'Hechelt der Hund stark, taumelt, hat dunkelrote Zunge oder '
          'erbricht - sofort in den Schatten, mit lauwarmem (nicht '
          'eiskaltem) Wasser kuehlen und zum Tierarzt. Hitzschlag ist '
          'lebensbedrohlich.',
    ),
    DogTip(
      id: 's6',
      category: TipCategory.summer,
      title: 'Kuehle Rueckzugsorte anbieten',
      body: 'Eine Kuehlmatte, ein schattiger Fliesenboden oder ein feuchtes '
          'Handtuch zum Drauflegen helfen an heissen Tagen. Wichtig: der '
          'Hund muss selbst entscheiden koennen, wann er sich abkuehlt.',
    ),
    DogTip(
      id: 's7',
      category: TipCategory.summer,
      title: 'Gassi in die kuehlen Stunden legen',
      body: 'Frueh morgens und spaet abends ist es fuer Pfoten und Kreislauf '
          'ertraeglich. Die Mittagshitze gehoert der Siesta - lieber drinnen '
          'ein Schnueffelspiel als ein Marsch in der prallen Sonne.',
    ),
    DogTip(
      id: 's8',
      category: TipCategory.summer,
      title: 'Insektenstich im Maul = Notfall',
      body: 'Schnappt der Hund nach Wespen, kann ein Stich im Rachen '
          'zuschwellen und die Atmung blockieren. Bei Schwellung im '
          'Maulbereich sofort zum Tierarzt - nicht abwarten.',
    ),
    DogTip(
      id: 's9',
      category: TipCategory.summer,
      title: 'Grannen nach dem Feld kontrollieren',
      body: 'Im Sommer bohren sich Getreide-Grannen in Pfotenzwischenraeume, '
          'Ohren und Nase. Nach Spaziergaengen durch hohes Gras absuchen - '
          'eine eingewanderte Granne kann boese Entzuendungen machen.',
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

    DogTip(
      id: 'w4',
      category: TipCategory.winter,
      title: 'Schneeklumpen zwischen den Ballen',
      body: 'Bei langhaarigen Pfoten sammeln sich harte Eisklumpen, die '
          'wehtun. Fell zwischen den Ballen kurz halten und nach dem Gang '
          'die Pfoten warm abspuelen und trocknen.',
    ),
    DogTip(
      id: 'w5',
      category: TipCategory.winter,
      title: 'Lieber kurz und oft',
      body: 'Bei strengem Frost mehrere kurze Runden statt einer langen. '
          'Vor allem kurzhaarige Hunde, Welpen und Senioren kuehlen schnell '
          'aus - Bewegung haelt sie warm.',
    ),
    DogTip(
      id: 'w6',
      category: TipCategory.winter,
      title: 'Kein Schnee fressen',
      body: 'Schnee reizt die Magenschleimhaut und kann Streusalz oder '
          'Splitt enthalten. Wenn dein Hund gern schnappt, lenk ihn mit '
          'einem Spiel ab statt ihn fressen zu lassen.',
    ),
    DogTip(
      id: 'w7',
      category: TipCategory.winter,
      title: 'Sichtbar im Dunkeln',
      body: 'In der dunklen Jahreszeit ein Leuchthalsband oder reflektierendes '
          'Geschirr. So sehen Autofahrer den Hund - und du ihn, wenn er '
          'ohne Leine unterwegs ist.',
    ),
    DogTip(
      id: 'w8',
      category: TipCategory.winter,
      title: 'Nach der Runde aufwaermen',
      body: 'Nasse Hunde nach dem Spaziergang trockenrubbeln und einen '
          'warmen, zugfreien Platz anbieten. Ausgekuehlte Hunde sind '
          'anfaelliger fuer Blasenentzuendungen.',
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

    DogTip(
      id: 'sa5',
      category: TipCategory.safety,
      title: 'Geschirr schont den Hals',
      body: 'Hunde, die an der Leine ziehen, sollten ein gut sitzendes '
          'Brustgeschirr tragen. Dauerzug am Halsband kann Kehlkopf und '
          'Halswirbel schaedigen.',
    ),
    DogTip(
      id: 'sa6',
      category: TipCategory.safety,
      title: 'Im Auto immer gesichert',
      body: 'Transportbox, Trenngitter oder ein gepruefter Sicherheitsgurt '
          'fuers Geschirr. Ein ungesicherter Hund wird bei einer Vollbremsung '
          'zum Geschoss - fuer sich und alle Insassen.',
    ),
    DogTip(
      id: 'sa7',
      category: TipCategory.safety,
      title: 'Giftkoeder-Gefahr ernst nehmen',
      body: 'In manchen Gegenden liegen praeparierte Koeder. Bring deinem '
          'Hund ein sicheres "Aus" und "Lass es" bei und beobachte beim '
          'Schnueffeln, was er aufnehmen will.',
    ),
    DogTip(
      id: 'sa8',
      category: TipCategory.safety,
      title: 'Gekippte Fenster sind toedlich',
      body: 'Springt ein Hund in ein gekipptes Fenster, rutscht er nach '
          'unten und klemmt fest - Lebensgefahr. Spezielle Kipp-Schutzgitter '
          'verhindern das.',
    ),
    DogTip(
      id: 'sa9',
      category: TipCategory.safety,
      title: 'Silvester vorbereiten',
      body: 'Frueh ausfuehren, bevor es knallt, Fenster und Rollos zu, ein '
          'sicherer Rueckzugsort und ruhige Begleitung. Bei grosser Angst '
          'rechtzeitig mit dem Tierarzt sprechen.',
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
    DogTip(
      id: 'so5',
      category: TipCategory.socialization,
      title: 'Tierarzt-Besuch positiv ueben',
      body: 'Gewoehne den Hund schon als Welpe ans Angefasstwerden: Pfoten, '
          'Ohren, Maul - immer mit Leckerli verbinden. Dann ist die '
          'Untersuchung spaeter kein Drama.',
    ),
    DogTip(
      id: 'so6',
      category: TipCategory.socialization,
      title: 'Geraeusche und Stadt langsam einfuehren',
      body: 'Verkehr, Menschenmengen, Baustellenlaerm - in kleinen Dosen '
          'und mit Abstand kennenlernen. Ueberforderst du den Hund, '
          'entsteht Angst statt Gelassenheit.',
    ),
    DogTip(
      id: 'so7',
      category: TipCategory.socialization,
      title: 'Maulkorb VOR dem Ernstfall ueben',
      body: 'Ob fuer Bus, Bahn oder Tierarzt - ein Maulkorb gehoert positiv '
          'antrainiert, lange bevor er gebraucht wird. Fuettere durch den '
          'Korb, dann wird er zur guten Sache.',
    ),
    DogTip(
      id: 'so8',
      category: TipCategory.socialization,
      title: 'Katzen und Kleintiere behutsam',
      body: 'Erste Begegnungen mit gesichertem Abstand und Rueckzugsmoeglichkeit '
          'fuer die Katze. Ruhe belohnen, Hetzen sofort unterbinden - '
          'Geduld ueber Wochen zahlt sich aus.',
    ),
    DogTip(
      id: 'so9',
      category: TipCategory.socialization,
      title: 'Qualitaet vor Quantitaet',
      body: 'Wenige gute Erfahrungen sind mehr wert als viele stressige. '
          'Ein ueberfordeter Welpe lernt nicht, dass die Welt sicher ist - '
          'er lernt, dass sie zu viel ist.',
    ),
  ];

  static List<DogTip> byCategory(TipCategory? cat) {
    if (cat == null) return all;
    return all.where((t) => t.category == cat).toList(growable: false);
  }
}
