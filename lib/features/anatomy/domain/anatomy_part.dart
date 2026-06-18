import 'package:flutter/material.dart';

/// Grobe Koerperregion - dient nur der Gruppierung in der Liste.
enum AnatomyRegion {
  head('Kopf'),
  front('Vorderkoerper'),
  body('Rumpf'),
  hind('Hinterkoerper');

  const AnatomyRegion(this.label);
  final String label;
}

/// Ein Anatomie-Begriff: der Fachbegriff (so wie ihn der Tierarzt sagt),
/// wo das am Hund liegt und was beim Tierarzt damit gemeint ist.
///
/// [number] ist die Ziffer im Schaubild, [pos] die normierte Position
/// (x,y in 0..1) des Markers auf dem seitlichen Hunde-Foto (Hund schaut
/// nach links).
class AnatomyPart {
  const AnatomyPart({
    required this.number,
    required this.name,
    required this.region,
    required this.where,
    required this.vetNote,
    required this.pos,
  });

  final int number;
  final String name;
  final AnatomyRegion region;
  final String where;
  final String vetNote;
  final Offset pos;
}

/// Statischer Katalog der wichtigsten Begriffe, die beim Tierarzt fallen.
/// Bewusst alltagsnah erklaert - kein Lehrbuch, sondern "was ist gemeint".
/// Die [pos]-Werte sind auf das seitliche Hunde-Foto (assets/anatomy/
/// dog_side.jpg, Labrador im Profil nach links) abgestimmt.
class AnatomyCatalog {
  AnatomyCatalog._();

  static const List<AnatomyPart> all = [
    // --- Kopf ---
    AnatomyPart(
      number: 1,
      name: 'Fang & Lefzen',
      region: AnatomyRegion.head,
      where: 'Die Schnauze mit den haengenden Lippen.',
      vetNote: 'Meint Maul, Lippen und Schnauzenbereich - z.B. bei '
          'Zahnstein, Entzuendungen oder Verletzungen.',
      pos: Offset(0.215, 0.350),
    ),
    AnatomyPart(
      number: 2,
      name: 'Stop',
      region: AnatomyRegion.head,
      where: 'Die Stufe zwischen Stirn und Nasenruecken.',
      vetNote: 'Orientierungspunkt am Kopf - hilft bei der Beschreibung von '
          'Schwellungen oder der Augenpartie.',
      pos: Offset(0.245, 0.210),
    ),
    AnatomyPart(
      number: 3,
      name: 'Behang (Ohren)',
      region: AnatomyRegion.head,
      where: 'Die Ohrmuscheln.',
      vetNote: 'Haeufig gemeint bei Ohrentzuendung, Milben oder Juckreiz - '
          '"Behang" ist das Fachwort fuer die Ohren.',
      pos: Offset(0.105, 0.255),
    ),
    AnatomyPart(
      number: 4,
      name: 'Nasenspiegel',
      region: AnatomyRegion.head,
      where: 'Die feuchte Nasenspitze.',
      vetNote: 'Der Tierarzt achtet auf Farbe und Feuchtigkeit - Hinweise '
          'auf Allgemeinbefinden.',
      pos: Offset(0.180, 0.300),
    ),

    // --- Vorderkoerper ---
    AnatomyPart(
      number: 5,
      name: 'Widerrist',
      region: AnatomyRegion.front,
      where: 'Der hoechste Punkt am Uebergang Hals/Ruecken.',
      vetNote: 'Hier wird die Schulterhoehe gemessen ("Widerristhoehe") und '
          'oft die Spritze gesetzt.',
      pos: Offset(0.375, 0.205),
    ),
    AnatomyPart(
      number: 6,
      name: 'Schulter',
      region: AnatomyRegion.front,
      where: 'Der Bereich zwischen Hals und Vorderbein.',
      vetNote: 'Relevant bei Lahmheit vorne - der Arzt prueft das '
          'Schultergelenk.',
      pos: Offset(0.345, 0.420),
    ),
    AnatomyPart(
      number: 7,
      name: 'Brustkorb',
      region: AnatomyRegion.front,
      where: 'Der vordere, untere Rumpf - umschliesst Herz und Lunge.',
      vetNote: 'Wird beim Abhoeren (Herz/Lunge) abgetastet; auch fuer den '
          'Brustumfang (Geschirr-Groesse) wichtig.',
      pos: Offset(0.290, 0.560),
    ),
    AnatomyPart(
      number: 8,
      name: 'Ellbogen',
      region: AnatomyRegion.front,
      where: 'Das Gelenk oben am Vorderbein, nah am Brustkorb.',
      vetNote: 'Wichtiger Punkt bei Lahmheit und Arthrose - "Ellbogen-'
          'Dysplasie (ED)" betrifft genau dieses Gelenk.',
      pos: Offset(0.355, 0.640),
    ),
    AnatomyPart(
      number: 9,
      name: 'Vorderpfote & Ballen',
      region: AnatomyRegion.front,
      where: 'Die vordere Pfote mit den Ballen.',
      vetNote: 'Der Arzt prueft Krallen, Ballen und Zwischenzehenbereich - '
          'haeufig bei Lahmheit oder Schnittverletzungen.',
      pos: Offset(0.300, 0.930),
    ),

    // --- Rumpf ---
    AnatomyPart(
      number: 10,
      name: 'Ruecken',
      region: AnatomyRegion.body,
      where: 'Die obere Linie vom Widerrist bis zur Kruppe.',
      vetNote: 'Bei Ruecken-/Wirbelsaeulen-Themen (z.B. Bandscheibe) gemeint.',
      pos: Offset(0.545, 0.290),
    ),
    AnatomyPart(
      number: 11,
      name: 'Rippenbogen',
      region: AnatomyRegion.body,
      where: 'Die seitliche Brustwand mit den Rippen.',
      vetNote: 'Ueber die fuehlbaren Rippen beurteilt der Arzt das '
          'Idealgewicht (Body Condition Score).',
      pos: Offset(0.460, 0.520),
    ),
    AnatomyPart(
      number: 12,
      name: 'Flanke & Lende',
      region: AnatomyRegion.body,
      where: 'Die Weichteile zwischen letzter Rippe und Huefte.',
      vetNote: 'Hier liegen Bauchorgane dicht unter der Haut - wird beim '
          'Abtasten des Bauchs untersucht.',
      pos: Offset(0.630, 0.405),
    ),
    AnatomyPart(
      number: 13,
      name: 'Bauch',
      region: AnatomyRegion.body,
      where: 'Die untere Rumpflinie hinter dem Brustkorb.',
      vetNote: 'Wird abgetastet (Magen, Darm, Blase); harter Bauch kann ein '
          'Warnzeichen sein.',
      pos: Offset(0.520, 0.640),
    ),

    // --- Hinterkoerper ---
    AnatomyPart(
      number: 14,
      name: 'Kruppe',
      region: AnatomyRegion.hind,
      where: 'Der abfallende Bereich ueber dem Becken, vor der Rute.',
      vetNote: 'Orientierung fuer Huefte und Becken - z.B. bei '
          'Hueftproblemen.',
      pos: Offset(0.735, 0.305),
    ),
    AnatomyPart(
      number: 15,
      name: 'Rute',
      region: AnatomyRegion.hind,
      where: 'Der Schwanz.',
      vetNote: '"Rute" ist das Fachwort fuer den Schwanz - relevant bei '
          'Verletzungen oder der beliebten "Wasserrute".',
      pos: Offset(0.915, 0.235),
    ),
    AnatomyPart(
      number: 16,
      name: 'Keule (Oberschenkel)',
      region: AnatomyRegion.hind,
      where: 'Die kraeftige Muskelpartie am Hinterbein.',
      vetNote: 'Wird zur Muskelbeurteilung abgetastet; haeufiger Ort fuer '
          'Spritzen in den Muskel.',
      pos: Offset(0.760, 0.520),
    ),
    AnatomyPart(
      number: 17,
      name: 'Knie (Kniescheibe)',
      region: AnatomyRegion.hind,
      where: 'Das Gelenk vorne am Hinterbein, etwa auf Bauchhoehe.',
      vetNote: 'Sehr haeufig: "Patellaluxation" (springende Kniescheibe) und '
          'Kreuzbandriss betreffen dieses Gelenk.',
      pos: Offset(0.680, 0.660),
    ),
    AnatomyPart(
      number: 18,
      name: 'Sprunggelenk',
      region: AnatomyRegion.hind,
      where: 'Das stark abgewinkelte Gelenk tief am Hinterbein - oft mit '
          'dem Knie verwechselt.',
      vetNote: 'Entspricht unserem Fussknoechel. Wichtig bei Lahmheit hinten '
          'und Verletzungen der Achillessehne.',
      pos: Offset(0.825, 0.760),
    ),
    AnatomyPart(
      number: 19,
      name: 'Hinterpfote',
      region: AnatomyRegion.hind,
      where: 'Die hintere Pfote.',
      vetNote: 'Wie vorne: Krallen, Ballen und Zehen werden geprueft.',
      pos: Offset(0.800, 0.930),
    ),
  ];
}
