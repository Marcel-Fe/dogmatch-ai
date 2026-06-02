import 'package:dogmatch_ai/features/knowledge/domain/article.dart';

/// Lokaler Pool an Wissensartikeln. Inhalt ist gepflegt von Hand,
/// orientiert an gaengigen Halter-Themen. Spaeter optional aus Firestore.
class ArticlesData {
  ArticlesData._();

  static const List<Article> all = [
    Article(
      id: 'welpen-sozialisierung',
      title: 'Welpen-Sozialisierung in den ersten 16 Wochen',
      category: 'Welpen',
      summary:
          'Die wichtigste Lernphase im Leben deines Hundes. Was du wann '
          'tun solltest - und was du vermeiden musst.',
      readMinutes: 5,
      content: '''
Die Wochen 3 bis 16 bestimmen, wie sicher und entspannt dein Hund spaeter durchs Leben geht. In dieser sensiblen Phase lernt sein Gehirn schnell und unverzerrt - Begegnungen aus dieser Zeit praegen ein Leben lang.

WAS DU AKTIV TUN SOLLTEST

1. Verschiedene Menschen kennenlernen: Kinder, Senioren, Menschen mit Hut, Brille, Bart, im Rollstuhl. Jeden Tag eine kleine neue Begegnung.
2. Untergrunde variieren: Gras, Sand, Pflaster, Holzboden, Gitter, Kies. Jeder neue Belag baut Selbstvertrauen auf.
3. Gerausche einfuehren: Staubsauger, Autohupe, Zugfahrt, Feuerwerk (vorsichtig + leise). Mit positiven Erfahrungen verknuepfen (Leckerli, Spielen).
4. Andere Hunde treffen: gut sozialisierte erwachsene Hunde, Welpenspielgruppen. Wichtig: Qualitaet vor Quantitaet - 2 gute Begegnungen schlagen 10 hektische.
5. Auto, Bus, Bahn: Kurze positive Fahrten. Niemals nur zum Tierarzt fahren.

WAS DU UNBEDINGT VERMEIDEN MUSST

- Ueberforderung: zu lange oder zu intensive Erfahrungen. Welpen brauchen 17-20 Stunden Schlaf am Tag.
- Erzwingen: wenn der Welpe Angst zeigt, niemals naeher hinschieben. Stattdessen abstand und positiv verknuepfen.
- Sich isolieren: viele Halter sind aus Angst vor Krankheiten zu vorsichtig. Verpasste Sozialisierung ist riskanter als die meisten Krankheiten.
- Schimpfen bei Unsicherheit: wenn er bellt oder weglaeuft, ist das Information, kein Fehlverhalten.

CHECKLISTE FUER DIE 16 WOCHEN

- 50+ verschiedene Menschen
- 30+ andere Hunde
- 10+ verschiedene Umgebungen (Stadt, Wald, Wasser)
- 5+ Fahrten in unterschiedlichen Verkehrsmitteln
- Tierarztbesuch ohne Behandlung (nur Schnuppern + Leckerli)

WAS WENN ICH ZU SPAET DRAN BIN?

Auch nach 16 Wochen ist Lernen moeglich, dauert nur laenger und braucht mehr Geduld. Eine gute Hundeschule + erfahrener Trainer helfen.
''',
    ),
    Article(
      id: 'trennungsangst',
      title: 'Trennungsangst erkennen und behandeln',
      category: 'Verhalten',
      summary:
          'Heulen, Pinkeln, Zerstoeren - wenn dein Hund nicht alleine '
          'bleiben kann. So baust du es Schritt fuer Schritt auf.',
      readMinutes: 6,
      content: '''
Trennungsangst gehoert zu den haeufigsten Problemen in der Hundehaltung. Oft entsteht sie, weil Welpen zu schnell zu lange alleine waren - oder weil der Mensch dem Hund beigebracht hat, dass jedes Abschied dramatisch ist.

SO ERKENNST DU TRENNUNGSANGST

- Heulen, Bellen oder Winseln direkt nach dem Verlassen
- Zerstoerung an Tueren, Fenstern oder Sofa
- Urinieren / Koten obwohl stubenrein
- Speicheln, Hecheln, Erbrechen
- Bei Heimkehr extrem ueberdreht

Unterscheide: Manche Hunde sind langweilig - das ist keine Trennungsangst. Trennungsangst zeigt sich in den ersten 5-15 Minuten nach Verlassen.

DER 4-WOCHEN-AUFBAU

Woche 1: Mini-Trennungen drinnen.
- Tuer kurz schliessen (10 Sekunden), oeffnen, ruhig bleiben.
- 10-15x am Tag, Dauer schrittweise auf 1 Minute steigern.
- Keine grossen Abschiede oder Wiedersehen. Hund bleibt zurueck, du gehst, du kommst zurueck - alltaeglich.

Woche 2: Wohnung verlassen.
- Tatsaechlich rausgehen, Schluessel, Schuhe, Tuer schliessen.
- Erst 30 Sekunden, dann 1, 2, 5 Minuten - in deinem Rhythmus.
- Bei Bellen: NICHT zurueckgehen (das verstaerkt). Warten bis er kurz still ist, dann reingehen.

Woche 3: 15-30 Minuten.
- Erst spazieren (muede ist gut), dann fuettern, dann gehen.
- Kong oder Schnueffelteppich als Beschaeftigung.

Woche 4: 1-2 Stunden.
- Schrittweise zu deinem Alltagsbedarf aufbauen.
- Maximal 4-6 Stunden ist auch fuer einen erwachsenen Hund Faustregel.

KLEINE TRICKS

- Vor dem Gehen koerperliche + geistige Auslastung (1 Stunde Spaziergang + Nasenarbeit).
- Radio oder ruhige Musik in normaler Lautstaerke.
- Kein dramatisches "Bis spaeter, Schatz!" - einfach rausgehen.
- Bei Heimkehr 5 Minuten ignorieren - dann erst begruessen.

WANN PROFI HOLEN

Wenn nach 4 Wochen Aufbau keine Besserung kommt oder dein Hund sich selbst verletzt: zertifizierter Verhaltensberater + ggf. Tierarzt. Bei manchen Hunden hilft kurzfristige medikamentoese Unterstuetzung als Bruecke.
''',
    ),
    Article(
      id: 'ernaehrung-grundlagen',
      title: 'Was, wie viel und wie oft? Hundeernaehrung verstehen',
      category: 'Ernaehrung',
      summary:
          'Trockenfutter, Nassfutter, Barfen, Selbstgekochtes - was passt '
          'zu deinem Hund? Plus: typische Fehler.',
      readMinutes: 7,
      content: '''
Es gibt nicht DIE eine richtige Ernaehrung. Was zaehlt: ausgewogen, alters- und groessengerecht, in passender Menge.

DIE 4 GROSSEN FUTTERARTEN

Trockenfutter
- Vorteil: lange haltbar, guenstig, einfach zu portionieren, Zahn-Abrieb
- Nachteil: niedrige Feuchtigkeit, oft hohe Kohlenhydrat-Anteile
- Tipp: immer frisches Wasser daneben, hochwertige Marken haben >25% Fleisch

Nassfutter
- Vorteil: hoher Wasseranteil, geschmacklich attraktiver, gut bei Senioren mit Zahnproblemen
- Nachteil: teurer, weniger haltbar (geoeffnet 2-3 Tage), keine Zahnpflege

BARF (Biologisch artgerechte Rohfuetterung)
- Vorteil: maximal natuerlich, voll kontrollierbar, viele Hunde glaenzen damit
- Nachteil: Zeitintensiv, Hygienerisiko (Salmonellen, fuer Kinder/Immungeschwaechte ungeeignet), erfordert Wissen oder Tierarzt-Beratung fuer Ausgewogenheit

Selbstgekochtes
- Vorteil: bekanntes Zutaten, gut bei Allergien
- Nachteil: braucht Rezept mit Mineralstoff-Ergaenzung, sonst Maengel

WIE VIEL?

Faustregel Trockenfutter: 2-3% des Koerpergewichts pro Tag (z. B. 20 kg Hund = 400-600 g).
Genauer: Packung beachten + Gewichtskontrolle. Ein gesunder Hund hat eine sichtbare Taille und du kannst die Rippen unter leichter Fettschicht fuehlen.

WIE OFT?

Welpen (bis 6 Mon): 3-4x am Tag
Junghund (6-12 Mon): 2-3x am Tag
Erwachsen: 1-2x am Tag (bevorzugt 2x, schont den Magen)
Senior: 2-3x kleinere Portionen

TYPISCHE FEHLER

- Tisch-Reste regelmaessig: macht waehlerisch + ist oft zu fett
- Knochen vom Tisch: gekochte Knochen splittern und sind gefaehrlich
- Schnelles Schlingen: Anti-Schling-Napf benutzen, sonst Magendrehung-Risiko
- Sofort nach Sport fuettern: 1h Pause vor + nach intensiver Bewegung

GIFTIG FUER HUNDE - NIE GEBEN

Schokolade, Trauben/Rosinen, Zwiebeln/Knoblauch, Xylit (Suessstoff), Avocado, Macadamia-Nuesse, rohes Schweinefleisch, Alkohol, Kaffee.
''',
    ),
    Article(
      id: 'leinen-training',
      title: 'Locker an der Leine gehen - in 3 Wochen',
      category: 'Training',
      summary:
          'Ziehen, sich winden, jeden Geruch markieren - so trainierst du '
          'einen entspannten Spaziergang.',
      readMinutes: 5,
      content: '''
Ziehen an der Leine ist nicht angeboren - es ist gelernt. Jeder Schritt, den der Hund mit gespannter Leine vorwaerts kommt, belohnt das Ziehen.

DAS GRUNDPRINZIP

"Gespannte Leine = Stop." Konsequent. Jedes Mal.

WOCHE 1: STOP-AND-GO

- Sobald die Leine spannt: stehen bleiben.
- Warten bis der Hund Rueckwaerts schaut oder die Leine entspannt.
- Sofort loben + weitergehen.
- Tipp: ruhige Strecke (Garten, leere Strasse), wenige Reize.

WOCHE 2: REIZE EINFUEHREN

- Strecken mit anderen Hunden / Menschen, aber Abstand wahren.
- Wenn dein Hund auf Reiz fixiert: zurueck-gehen, Abstand schaffen, von vorne anfangen.
- Belohne JEDE freiwillige Aufmerksamkeit zu dir (Blickkontakt = Klickerlaut + Leckerli).

WOCHE 3: VARIANTEN

- Tempowechsel: schnell-langsam-stop. Hund lernt auf dich zu achten.
- Richtungswechsel ohne Ansage: ploetzlich umdrehen. Hund muss aufpassen.
- Erste Spaziergaenge in normalen Umgebungen.

HILFSMITTEL

- Brustgeschirr statt Halsband (besser fuer Hals/Wirbel)
- 2-3m Fuehrleine, kein Flexi-Leine im Training (vermittelt falsche Signale)
- Hochwertige Leckerli die der Hund WIRKLICH gut findet

TYPISCHE FEHLER

- Sich ziehen lassen "weil es schneller geht" - alles ist umsonst
- Schimpfen bei Ziehen - macht Spaziergaenge negativ
- Inkonsistenz - 1x klappt es, 10x nicht: der Hund lernt nichts klares

WANN ZUM TRAINER

Wenn dein Hund extrem stark zieht (>30 kg, ungestuem), oder du dich nicht durchsetzen kannst: 2-3 Stunden bei einem positiven Trainer sparen Wochen.
''',
    ),
    Article(
      id: 'erste-hilfe',
      title: 'Erste Hilfe beim Hund - die wichtigsten Notfaelle',
      category: 'Gesundheit',
      summary:
          'Was tun bei Vergiftung, Hitzeschlag, Bewusstlosigkeit? '
          'Schritt-fuer-Schritt-Anleitungen.',
      readMinutes: 6,
      content: '''
Vorbereitet sein rettet Leben. Bewahre die Notfallnummer deines Tierarztes UND einer 24h-Tierklinik im Telefon auf.

VITALWERTE EINES GESUNDEN HUNDES

- Atemfrequenz: 10-30/min in Ruhe
- Pulsfrequenz: 70-130/min (kleinere Rassen schneller)
- Koerpertemperatur: 38-39 Grad C
- Schleimhaeute (Zahnfleisch): rosa, glaenzend

NOTFALL 1: VERGIFTUNG

Anzeichen: Speicheln, Erbrechen, Durchfall, Krampfanfaelle, Schwaeche.

Tu das:
1. Sofort Tierarzt anrufen. Verpackung der vermuteten Substanz mitnehmen.
2. NICHT Erbrechen erzwingen (kann mehr Schaden machen).
3. Keine Milch geben.
4. Aktivkohle nur auf tieraerztliche Anweisung.

Hotline-Tipp: Giftnotruf-Zentralen sind hundefreundlich.

NOTFALL 2: HITZESCHLAG

Anzeichen: starkes Hecheln, Speicheln, Wackeln, dunkelrote Schleimhaeute, ueber 40 Grad C.

Tu das:
1. Schatten / kuehler Raum.
2. Pfoten und Bauch mit LAUWARMEM (nicht kaltem!) Wasser kuehlen. Eiswasser kann Schock ausloesen.
3. Wasser zum Trinken anbieten, nicht zwingen.
4. Sofort Tierarzt - auch wenn er sich erholt, Folgeschaeden moeglich.

NOTFALL 3: MAGENDREHUNG

Anzeichen: aufgeblaehter Bauch, vergebliches Wuergen, Speicheln, Schwaeche.

Tu das:
1. SOFORT in die naechste Klinik. Magendrehung toetet binnen 1-2h.
2. Nicht versuchen zu fuettern oder zu traenken.

Risiko-Rassen: grosse, tiefbruestige Rassen (Schaeferhund, Dogge, Bernhardiner).
Vorbeugung: kleinere Portionen 2x/Tag, 1h Ruhe vor + nach Mahlzeit.

NOTFALL 4: BLUTUNG

Tu das:
1. Druckverband mit sauberem Tuch.
2. Wunde nicht ausspuelen (Keime nach innen).
3. Tierarzt bei Wunden tiefer als 5mm oder anhaltender Blutung.

NOTFALL 5: BEWUSSTLOSIGKEIT

Tu das:
1. Atmen pruefen (Brust hebt sich?).
2. Pulse pruefen (Innenseite Oberschenkel).
3. Stabile Seitenlage, Zunge nach vorne.
4. Sofort Klinik.

ERSTE-HILFE-KOFFER ZUHAUSE

- Sterile Mullbinden
- Selbstklebende Verbandsbinde
- Wundspray (z. B. Bepanthen)
- Zeckenzange
- Digitales Fieberthermometer
- Einmalhandschuhe
- Maulkorb (auch vertraute Hunde beissen im Schmerz)
- Notfallnummern
''',
    ),
    Article(
      id: 'sommer-hitze',
      title: 'Sommer und Hitze - so schuetzt du deinen Hund',
      category: 'Gesundheit',
      summary:
          'Asphalt, Auto, Sonne, Aktivitaet - wo lauern Gefahren und '
          'wie reagierst du richtig?',
      readMinutes: 4,
      content: '''
Hunde regulieren ueber Hecheln und Pfoten. Bei Hitze ueber 25 Grad kommen viele schnell an ihre Grenzen, besonders Brachyzephale (Mops, Bulldogge, Boxer), schwarzfellige und Senioren.

DIE 5-SEKUNDEN-REGEL FUER ASPHALT

Lege den Handruecken 5 Sekunden auf den Asphalt. Halts du es nicht aus, ist es zu heiss fuer Pfoten. Verbrennungen sind innerhalb von 1 Minute moeglich.
- Spaziergaenge in Morgen-/Abendstunden
- Gras oder Wald statt Strasse waehlen
- Bei Bedarf Pfotenwachs auftragen

NIEMALS IM AUTO LASSEN

Bei 25 Grad aussen sind nach 10 Minuten 35 Grad im Auto, nach 30 Minuten 45-50 Grad. Spalt im Fenster reicht NIE.

Wenn du einen Hund im Auto siehst:
1. Notruf 110 / 112
2. Falls Hund Hitzeschlag-Anzeichen: Glas einschlagen ist gerechtfertigt (Zeugen + Doku machen).

ANZEICHEN HITZESTRESS

- Schnelles Hecheln mit langer Zunge
- Glasiger Blick
- Speicheln
- Wackeln

SOFORT-MASSNAHMEN

1. Schatten / kuehler Raum
2. Lauwarmes Wasser ueber Pfoten + Bauch (nicht Kopf, nicht eiskalt)
3. Wasser anbieten
4. Bei Verschlechterung Tierarzt

ERFRISCHUNGS-IDEEN

- Kong mit gefrorenem Joghurt
- Eiswuerfel mit Lieblings-Leckerli
- Planschbecken im Garten
- Kuehlmatte im Lieblingsbereich

GROSSE RUECKSICHT BEI BRACHYZEPHALEN

Mops, Franzoesische und Englische Bulldogge, Boxer, Pekinese: ihre verkuerzte Schnauze schraenkt die Kuehlung stark ein. Schon 22 Grad koennen kritisch werden. Mittags-Spaziergaenge ganz weglassen.
''',
    ),
    Article(
      id: 'welpenkauf',
      title: 'Welpe kaufen - so erkennst du einen serioesen Zuechter',
      category: 'Anschaffung',
      summary:
          'Vermehrer und Welpenfabriken zu erkennen ist Ueberlebenswichtig. '
          'Diese 10 Punkte trennen seriose Zucht von Massenproduktion.',
      readMinutes: 6,
      content: '''
Ein guter Start ins Hundeleben kostet etwa 1500-2500 EUR und ist die wichtigste Investition fuer 10-15 gesunde Jahre.

DIE 10 PUNKTE EINES SERIOESEN ZUECHTERS

1. Mitgliedschaft im VDH (Deutschland), SKG (Schweiz), oder OEKV (Oesterreich) - keine 100% Garantie, aber gute Basis.

2. Du darfst die Mutter sehen. Wenn nicht: WEGFAHREN.

3. Welpen leben in der Familie, nicht im Zwinger.

4. Welpen sind erst ab 8 Wochen (besser 9-10) abgabebereit.

5. Maximal 2 Wuerfe pro Huendin pro Jahr, nicht aus erster Hitze, nicht ueber 8 Jahre.

6. Gesundheits-Untersuchungen der Eltern liegen vor (HD, ED, Augen, je nach Rasse).

7. EU-Heimtierausweis mit Chip und Erstimpfung wird mitgegeben.

8. Welpe geht mit Kaufvertrag, Futterprobe, Decken (vertrauter Geruch).

9. Du wirst BEFRAGT - guter Zuechter prueft, ob das Zuhause passt.

10. Lebenslanger Kontakt angeboten - bei Fragen oder Notlage.

WARNSIGNALE - SOFORT WEG

- Verkauf am Strassenrand, Parkplatz, "Treffpunkt"
- Welpe unter 8 Wochen
- Keine Papiere oder "kommen nach"
- Mutter nicht zu sehen
- Mehrere verschiedene Rassen im Angebot
- Druck, schnell zu entscheiden
- Online-Kauf ohne Besichtigung
- Auffallend guenstig (unter 800 EUR fuer Rassehund)

ALTERNATIVE: TIERSCHUTZ

Ein erwachsener Hund aus dem Tierheim hat oft schon Erfahrung. Wesensbeschreibung von Pflegepersonal lesen, mehrere Probebesuche machen. Beachte: Hunde aus dem Auslandstierschutz brauchen oft mehr Zeit und manchmal professionelle Hilfe.

ERSTGESPRAECH-FRAGEN AN DICH

Ein guter Zuechter fragt dich:
- Wer ist tagsueber zuhause?
- Hattest du schon mal einen Hund?
- Garten / Wohnung?
- Wieviel Aktivitaet bietest du?
- Familienzusammensetzung?

Wenn er DICH nicht prueft - bist du fuer ihn nur Kunde, nicht Verantwortung.
''',
    ),
    Article(
      id: 'krallenpflege',
      title: 'Krallen kuerzen - wann, wie, ohne Stress',
      category: 'Pflege',
      summary:
          'Klicken beim Gehen heisst zu lang. So machst du es selbst, '
          'ohne Hund-und-Mensch-Trauma.',
      readMinutes: 4,
      content: '''
Lange Krallen tun weh, veraendern die Pfotenhaltung und koennen ins Pfotenfleisch einwachsen. Faustregel: klickt es beim Gehen auf hartem Boden, sind sie zu lang.

WIE OFT?

Alle 3-6 Wochen, abhaengig von Bodenbeschaffenheit (Asphalt schleift ab, Wiese nicht).

WERKZEUG

- Krallenschere: gut fuer kleine Hunde
- Krallenzange (Guillotine): schneller bei groesseren
- Krallenschleifer (Dremel): am praezisesten, gewoehnen erforderlich

DIE LEBEN-LINIE

In jeder Kralle laeuft ein Blutgefaess (das "Leben"). Bei hellen Krallen siehst du es rosa schimmern. Bei dunklen Krallen NIE radikal kuerzen - sondern in kleinen Schritten.

REGEL: nie tiefer als 2 mm vor dem rosa Bereich.

SCHRITT FUER SCHRITT

1. Wartet auf einen ruhigen Moment (nach Spaziergang).
2. Setze deinen Hund seitlich, halte die Pfote fest aber sanft.
3. Eine Kralle - belohnen - eine Kralle - belohnen. Keine Eile.
4. Nach jeder Pfote eine groessere Pause + Lob.

BEI ANGST

Wenn dein Hund sich wehrt: nicht festhalten, sondern aufbauen.
- Tag 1: Pfote anfassen, Leckerli.
- Tag 2: Werkzeug zeigen + Leckerli.
- Tag 3: Werkzeug ans Pfote halten + Leckerli (NICHT schneiden).
- Tag 4-7: erste Kralle, dann Leckerli, hoeren auf.
- So bist du nach 2 Wochen entspannt durch.

UPS - BLUT GETROFFEN

- Mit Watte druecken, 1-2 Minuten halten.
- Maizena oder spezielles Blutstillpulver in die Wunde druecken.
- Ist nicht schoen, aber meist harmlos. Wenn Blutung > 5 Min: Tierarzt.

WANN BESSER ZUM PROFI

- Sehr dunkle Krallen + Unsicherheit
- Sehr lange Krallen mit weit vorgewachsenem Leben (langsam zurueckziehen ueber Wochen)
- Bei Welpen die ersten Male - Tierarzt zeigt es einmal richtig
''',
    ),
    Article(
      id: 'beissvorfall',
      title: 'Beissvorfall - was Halter und Opfer wissen muessen',
      category: 'Recht',
      summary:
          'Wenn dein Hund jemanden beisst - sofortige Massnahmen, rechtliche '
          'Folgen und Praevention.',
      readMinutes: 5,
      content: '''
Hoffentlich passiert es nie. Aber wer vorbereitet ist, reagiert besser.

UNMITTELBAR NACH DEM VORFALL

1. Hund sichern - Maulkorb, Boxe, anderes Zimmer.
2. Erste Hilfe fuer das Opfer, Wunde reinigen, kuehlen.
3. Ärztliche Versorgung anbieten - jede Wunde sollte vom Arzt gesehen werden (Infektionsgefahr).
4. Personalien austauschen wie bei einem Verkehrsunfall.
5. Polizei rufen, wenn das Opfer das wuenscht oder die Verletzung ernst ist.

RECHTLICHE FOLGEN IN DACH

Deutschland
- Halter haftet verschuldensunabhaengig (Paragraph 833 BGB).
- Hundehalterhaftpflicht ist in vielen Bundeslaendern Pflicht - haengt vom Wohnort + Rasse ab.
- Anzeige beim Veterinaeramt, oft Wesenstest noetig.

Schweiz
- Meldung an Kantonstierarzt verpflichtend.
- Hundehaftpflicht in mehreren Kantonen Pflicht.

Oesterreich
- Anzeige bei der Behoerde.
- In Wien Hundefuehrerschein und Haftpflicht Pflicht.

WAS DICH ERWARTET

- Wesenstest mit zertifiziertem Sachverstaendigen.
- Eventuell Maulkorb-/Leinenpflicht.
- Bei wiederholten oder schweren Vorfaellen: Beschlagnahme moeglich.

VERSICHERUNG - WAS DECKT SIE?

Hundehaftpflicht uebernimmt:
- Heilbehandlung Opfer
- Schmerzensgeld
- Folgekosten (Verdienstausfall, Therapie)
- Sachschaeden (zerrissene Kleidung)

Wichtig: bei vorsaetzlichem Verhalten oder fehlender Aufsicht kann sie verweigern. Polizeibekannte Wesenstest-Auflagen einhalten.

WAS DU JETZT TUN MUSST FUER DIE ZUKUNFT

1. Zertifizierter Trainer / Verhaltensberater einbeziehen.
2. Tierarzt prueft auf Schmerz/Krankheit als Ursache.
3. Konsequente Sicherheits-Routine: Maulkorb in Risikosituationen, NIE freilaufend ohne sicheren Rueckruf.
4. Mit Familie/Bekannten Verhaltensregeln klar machen.

WARUM HUNDE BEISSEN

In Reihenfolge der Haeufigkeit:
1. Schmerz (Tierarzt!)
2. Angst (Sozialisierung mangelhaft, schlechte Erfahrung)
3. Schutz (Ressource, Familie, Territorium)
4. Frust
5. Spielen entgleist
6. Krankheit (Gehirn, Hormon)

Beissen "aus dem nichts" ist fast immer das Ergebnis uebersehener Signale (Knurren, Erstarren, abgewandter Blick). Aus diesem Grund: nie das Knurren wegtrainieren - es ist die letzte Warnung.
''',
    ),
    Article(
      id: 'senior-hund',
      title: 'Mit dem Senior-Hund leben - Pflege und Lebensqualitaet',
      category: 'Senior',
      summary:
          'Schmerzen erkennen, Bewegung anpassen, Demenz vorbeugen - was '
          'deinem Hund im Alter wirklich hilft.',
      readMinutes: 5,
      content: '''
Ab wann ist ein Hund Senior? Bei grossen Rassen ab 6-7 Jahren, bei kleinen ab 9-10. Dann beginnt eine neue Lebensphase mit eigenen Herausforderungen.

VERAENDERUNGEN BEI SENIOREN

- Weniger Energie, mehr Schlaf (bis 18-20h/Tag)
- Gelenkprobleme, steifere Bewegungen
- Hoer- und Sehverlust
- Beginnende Demenz (CDS) bei manchen
- Gewichtszunahme oder -verlust
- Andere Ernaehrungsbedarfe

10 KONKRETE MASSNAHMEN

1. Tierarzt-Check 2x/Jahr (Blutbild, Urin, Zaehne).
2. Senior-Futter mit weniger Kalorien, mehr Gelenkschutz (Glucosamin, Chondroitin).
3. Bewegung anpassen: lieber 2-3x kuerzere Spaziergaenge als ein langer.
4. Schwimmen / Hydrotherapie schont Gelenke + traegt das Gewicht.
5. Orthopaedisches Hundebett zum Liegen.
6. Rutschfeste Teppiche auf glatten Boeden.
7. Treppe vermeiden, ggf. Rampe ans Sofa.
8. Krallenpflege haeufiger - weniger Abrieb durch geringere Bewegung.
9. Geistige Auslastung beibehalten: Suchspiele, leichte Trickdog-Uebungen.
10. Soziale Kontakte halten - alte Hunde brauchen weiter andere Hunde + Menschen.

SCHMERZ ERKENNEN

Hunde sind Meister im Verbergen. Anzeichen:
- Veraenderter Gang, "Schonhaltung"
- Verkuerzte Spaziergaenge auf eigenen Wunsch
- Aenderung im Verhalten (gereizt, zurueckziehend)
- Probleme mit Treppen oder Aufstehen
- Schwer atmend in Ruhe

Bei JEDER Veraenderung: Tierarzt. Schmerzmittel sind heute gut vertraeglich und veraendern Lebensqualitaet enorm.

DEMENZ (CCD - CANINE COGNITIVE DYSFUNCTION)

Anzeichen:
- Verwirrung, im Zimmer "verlaufen"
- Veraenderung Schlaf-Wach-Rhythmus
- Stubenreinheits-Verlust
- Weniger Reaktion auf Namen
- Untypische Aengstlichkeit

Hilft:
- Routine einhalten (gleiche Zeiten Fuetterung + Spaziergang)
- Geistige Beschaeftigung
- Spezial-Futter mit Antioxidantien, B-Vitaminen
- Bei starkem Verlauf: tieraerztliche Therapie

DIE LETZTE PHASE

Schwere Entscheidung Einschlaefern: orientiere dich an Lebensqualitaet. Frag dich: Kann er noch fressen, sich bewegen, freuen? Hat er mehr gute als schlechte Tage?

Ein guter Tierarzt unterstuetzt diese Entscheidung mit dir, ohne Druck in beide Richtungen.
''',
    ),
    Article(
      id: 'erste-hilfe',
      title: 'Erste Hilfe beim Hund - die wichtigsten Notfaelle',
      category: 'Gesundheit',
      summary:
          'Was du bei Hitzschlag, Vergiftung, Verletzung oder Atemnot sofort '
          'tun musst - bevor der Tierarzt erreicht ist.',
      readMinutes: 6,
      content: '''
Im Notfall zaehlt jede Minute. Diese Schritte ersetzen keinen Tierarzt, koennen aber Leben retten, bis du dort bist. Speichere dir JETZT die Nummer deines Tierarztes und der naechsten Tierklinik ein.

HITZSCHLAG (Sommer, heisses Auto)
- Symptome: starkes Hecheln, taumeln, dunkelrote Zunge, Erbrechen.
- Sofort: in den Schatten, langsam mit lauwarmem (nicht eiskaltem!) Wasser kuehlen - Pfoten und Bauch zuerst. Wasser anbieten. Direkt zum Tierarzt.

VERGIFTUNG (Schokolade, Xylit, Rattengift, Schnecken-Korn)
- NICHT selbst Erbrechen ausloesen ohne Ruecksprache.
- Verpackung/Reste mitnehmen, Tierarzt anrufen, Giftnotruf nennen.

STARKE BLUTUNG
- Druckverband mit sauberem Tuch, fest aber nicht abschnueren. Pfote/Wunde hochhalten. Sofort Klinik.

ATEMNOT / ERSTICKEN
- Maul vorsichtig oeffnen, sichtbaren Fremdkoerper entfernen. Kleinen Hund kopfueber halten und zwischen Schulterblaetter klopfen.

NOTFALL-APOTHEKE FUER ZUHAUSE
- Sterile Kompressen, selbsthaftende Bandage, Zeckenzange, digitales Fieberthermometer (normal: 37,5-39 Grad), Einmalhandschuhe, Tierarzt-Telefonnummer.
''',
    ),
    Article(
      id: 'zahnpflege',
      title: 'Zahnpflege - Zahnstein und Mundgeruch vermeiden',
      category: 'Pflege',
      summary:
          'Ueber 80% der Hunde ueber 3 Jahre haben Zahnprobleme. So haeltst '
          'du die Zaehne deines Hundes gesund.',
      readMinutes: 4,
      content: '''
Zahnstein ist nicht nur ein kosmetisches Problem - Bakterien koennen Herz, Leber und Nieren schaedigen. Vorbeugen ist viel guenstiger als eine Zahnsanierung in Narkose.

SO PFLEGST DU DIE ZAEHNE
1. Zaehneputzen: 2-3x pro Woche mit Hunde-Zahnpasta (niemals Menschen-Zahnpasta - giftig). Langsam herantasten, mit Lob verknuepfen.
2. Kauartikel: getrocknete Rinderkopfhaut, Geweih, spezielle Dental-Sticks. Reduzieren Belag mechanisch.
3. Richtiges Futter: Trockenfutter belastet die Zaehne weniger als reines Nassfutter.

WARNZEICHEN ZUM TIERARZT
- Starker Mundgeruch, braun-gelber Belag, Zahnfleischbluten, einseitiges Kauen, Futterverweigerung.

Ein jaehrlicher Maulcheck beim Tierarzt gehoert zur Routine dazu.
''',
    ),
    Article(
      id: 'ernaehrung-grundlagen',
      title: 'Hundeernaehrung - Trocken, Nass oder BARF?',
      category: 'Ernaehrung',
      summary:
          'Die wichtigsten Fakten zur Fuetterung: Wie viel, wie oft, und '
          'welche Methode zu euch passt.',
      readMinutes: 5,
      content: '''
Es gibt nicht DIE eine richtige Fuetterung - aber ein paar klare Grundregeln.

DIE DREI METHODEN
- Trockenfutter: praktisch, lange haltbar, zahnfreundlicher. Auf hohen Fleischanteil + wenig Getreide achten.
- Nassfutter: schmackhaft, hoher Wassergehalt (gut fuer die Nieren), aber teurer und kuerzer haltbar.
- BARF (Rohfuetterung): natuerlich, aber nur mit Plan - falsch gebarft drohen Mangelerscheinungen. Beratung noetig.

WIE VIEL?
Die Packungsangabe ist ein Startwert. Richtig ist die Menge, bei der dein Hund schlank bleibt: Rippen fuehlbar, aber nicht sichtbar. Bei Uebergewicht 10% reduzieren.

WIE OFT?
- Welpen: 3-4x taeglich.
- Erwachsene: 2x taeglich (besser als 1x - schont den Magen).

ABSOLUT TABU (giftig)
Schokolade, Weintrauben/Rosinen, Zwiebeln/Knoblauch, Xylit (Suessstoff), Avocado, Alkohol, roher Teig.
''',
    ),
    Article(
      id: 'reise-mit-hund',
      title: 'Mit dem Hund im Auto und auf Reisen',
      category: 'Alltag',
      summary:
          'Sicher unterwegs: Anschnallen, Pausen, Reiseuebelkeit und was bei '
          'Auslandsreisen Pflicht ist.',
      readMinutes: 5,
      content: '''
Hunde muessen im Auto gesichert sein - rechtlich gelten sie als Ladung. Ungesichert drohen Bussgeld und im Unfall Lebensgefahr fuer alle.

SICHER IM AUTO
- Transportbox (sicherste Variante, quer zur Fahrtrichtung) oder Sicherheitsgurt-Geschirr.
- Niemals im Kofferraum ohne Trenngitter lose.
- Nie allein im warmen Auto lassen - schon 22 Grad aussen werden innen lebensgefaehrlich.

REISEUEBELKEIT
- Junge Hunde sind oft betroffen. Leichter Magen vor Fahrt, kurze Gewoehnungsfahrten, frische Luft. Bei starker Uebelkeit Mittel vom Tierarzt.

AUSLANDSREISEN (EU)
- Pflicht: EU-Heimtierausweis, Mikrochip, gueltige Tollwutimpfung (mind. 21 Tage alt).
- Manche Laender: Bandwurmbehandlung (z.B. UK, Irland, Malta, Norwegen, Finnland).
- Vorab Einreiseregeln des Ziellandes pruefen - sie aendern sich.
''',
    ),
    Article(
      id: 'koerpersprache',
      title: 'Koerpersprache des Hundes richtig lesen',
      category: 'Verhalten',
      summary:
          'Was dein Hund dir mit Rute, Ohren und Koerperhaltung sagt - und '
          'wie du Stress fruehzeitig erkennst.',
      readMinutes: 5,
      content: '''
Hunde kommunizieren fast ausschliesslich ueber Koerpersprache. Wer sie liest, vermeidet Konflikte und versteht seinen Hund besser.

BESCHWICHTIGUNGSSIGNALE (Stress / "bitte ruhig bleiben")
- Gaehnen ohne Muedigkeit, Lecken ueber die Nase, Kopf wegdrehen, Pfote heben, langsames Bewegen, sich kratzen.
Diese Signale heissen: dem Hund ist die Situation unangenehm. Gib ihm Raum.

RUTE
- Hoch + steif: Anspannung/Aufmerksamkeit (nicht zwingend Freude!).
- Locker wedelnd auf mittlerer Hoehe: entspannt freundlich.
- Eingeklemmt: Angst/Unsicherheit.
- Wedeln nach rechts = eher positiv, nach links = eher unsicher.

WARNSIGNALE (ernst nehmen!)
Erstarren, fixieren, Zaehne zeigen, Knurren. Das ist KEINE Boesartigkeit, sondern eine Bitte um Abstand. Niemals bestrafen - sonst verlernt der Hund die Vorwarnung und schnappt ohne Ankuendigung.

ENTSPANNTER HUND
Weiche Augen, leicht geoeffnetes Maul, lockere Koerperhaltung, gleichmaessige Atmung.
''',
    ),
  ];
}
