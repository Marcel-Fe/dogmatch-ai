import 'package:flutter/material.dart';

/// Grobe Koerperregion - dient nur der Gruppierung in der Liste.
enum AnatomyRegion {
  head('Kopf & Wirbelsaeule'),
  front('Vorderbein'),
  body('Brustkorb'),
  hind('Becken & Hinterbein');

  const AnatomyRegion(this.label);
  final String label;
}

/// Ein Anatomie-/Knochen-Begriff: der Fachbegriff (so wie ihn der Tierarzt
/// sagt), wo der Knochen liegt und was beim Tierarzt damit gemeint ist.
///
/// [number] ist die Ziffer im Schaubild, [pos] die normierte Position
/// (x,y in 0..1) auf der seitlichen Skelett-Zeichnung (Hund schaut nach links).
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

/// Statischer Katalog der wichtigsten Knochen/Gelenke, die beim Tierarzt
/// fallen. Alltagsnah erklaert - kein Lehrbuch, sondern "was ist gemeint".
/// Die [pos]-Werte sind auf die Skelett-Tafel (assets/anatomy/dog_skeleton.jpg,
/// gemeinfrei, Ellenberger & Baum) abgestimmt.
class AnatomyCatalog {
  AnatomyCatalog._();

  static const List<AnatomyPart> all = [
    // --- Kopf & Wirbelsaeule ---
    AnatomyPart(
      number: 1,
      name: 'Schaedel',
      region: AnatomyRegion.head,
      where: 'Der Kopf-Knochen ganz vorne.',
      vetNote: 'Knoecherne Huelle fuer Gehirn, Augen, Kiefer und Zaehne.',
      pos: Offset(0.085, 0.090),
    ),
    AnatomyPart(
      number: 2,
      name: 'Halswirbel',
      region: AnatomyRegion.head,
      where: 'Die Wirbelkette im Hals (Kopf bis Schulter).',
      vetNote: 'Die sieben Halswirbel tragen den Kopf und sind sehr '
          'beweglich.',
      pos: Offset(0.195, 0.250),
    ),
    AnatomyPart(
      number: 3,
      name: 'Brustwirbel',
      region: AnatomyRegion.head,
      where: 'Die Wirbel oben ueber dem Brustkorb.',
      vetNote: 'An ihnen haengen die Rippen - der Bereich zwischen Widerrist '
          'und Lende.',
      pos: Offset(0.460, 0.180),
    ),
    AnatomyPart(
      number: 4,
      name: 'Lendenwirbel',
      region: AnatomyRegion.head,
      where: 'Die kraeftigen Wirbel im unteren Ruecken.',
      vetNote: 'Zwischen letzter Rippe und Becken - haeufig bei Ruecken-/'
          'Bandscheibenthemen gemeint.',
      pos: Offset(0.620, 0.170),
    ),
    AnatomyPart(
      number: 5,
      name: 'Kreuzbein',
      region: AnatomyRegion.head,
      where: 'Verschmolzene Wirbel ueber dem Becken.',
      vetNote: 'Verbindet die Wirbelsaeule fest mit dem Becken.',
      pos: Offset(0.710, 0.180),
    ),
    AnatomyPart(
      number: 6,
      name: 'Schwanzwirbel',
      region: AnatomyRegion.head,
      where: 'Die kleinen Wirbel im Schwanz (Rute).',
      vetNote: '"Rute" ist das Fachwort fuer den Schwanz - relevant bei '
          'Verletzungen oder der "Wasserrute".',
      pos: Offset(0.870, 0.460),
    ),

    // --- Vorderbein ---
    AnatomyPart(
      number: 7,
      name: 'Schulterblatt',
      region: AnatomyRegion.front,
      where: 'Der flache Knochen ueber dem Brustkorb vorne.',
      vetNote: 'Verbindet das Vorderbein mit dem Rumpf - Hunde haben kein '
          'Schluesselbein.',
      pos: Offset(0.255, 0.300),
    ),
    AnatomyPart(
      number: 8,
      name: 'Schultergelenk',
      region: AnatomyRegion.front,
      where: 'Gelenk zwischen Schulterblatt und Oberarm.',
      vetNote: 'Relevant bei Lahmheit vorne.',
      pos: Offset(0.225, 0.405),
    ),
    AnatomyPart(
      number: 9,
      name: 'Oberarmbein',
      region: AnatomyRegion.front,
      where: 'Der Oberarmknochen zwischen Schulter und Ellbogen.',
      vetNote: 'Der grosse Knochen des oberen Vorderbeins.',
      pos: Offset(0.260, 0.470),
    ),
    AnatomyPart(
      number: 10,
      name: 'Ellbogen',
      region: AnatomyRegion.front,
      where: 'Gelenk zwischen Oberarm und Unterarm.',
      vetNote: 'Ort der "Ellbogen-Dysplasie (ED)" und von Arthrose.',
      pos: Offset(0.300, 0.500),
    ),
    AnatomyPart(
      number: 11,
      name: 'Unterarm (Elle & Speiche)',
      region: AnatomyRegion.front,
      where: 'Die zwei Knochen zwischen Ellbogen und Vorderfuss.',
      vetNote: 'Elle und Speiche - haeufige Stelle fuer Brueche.',
      pos: Offset(0.270, 0.640),
    ),
    AnatomyPart(
      number: 12,
      name: 'Vorderfusswurzel',
      region: AnatomyRegion.front,
      where: 'Das "Handgelenk" ueber der Vorderpfote.',
      vetNote: 'Entspricht unserem Handwurzel-/Handgelenk.',
      pos: Offset(0.270, 0.780),
    ),

    // --- Brustkorb ---
    AnatomyPart(
      number: 13,
      name: 'Rippen',
      region: AnatomyRegion.body,
      where: 'Die Knochenboegen des Brustkorbs.',
      vetNote: 'Schuetzen Herz und Lunge; ueber die fuehlbaren Rippen '
          'beurteilt der Arzt das Idealgewicht.',
      pos: Offset(0.420, 0.460),
    ),

    // --- Becken & Hinterbein ---
    AnatomyPart(
      number: 14,
      name: 'Becken',
      region: AnatomyRegion.hind,
      where: 'Der Hueftknochen ueber dem Hinterbein.',
      vetNote: 'Verbindet Hinterbeine und Wirbelsaeule.',
      pos: Offset(0.740, 0.250),
    ),
    AnatomyPart(
      number: 15,
      name: 'Hueftgelenk',
      region: AnatomyRegion.hind,
      where: 'Kugelgelenk zwischen Becken und Oberschenkel.',
      vetNote: 'Betroffen bei "Hueftdysplasie (HD)".',
      pos: Offset(0.725, 0.320),
    ),
    AnatomyPart(
      number: 16,
      name: 'Oberschenkel (Femur)',
      region: AnatomyRegion.hind,
      where: 'Der kraeftige Knochen zwischen Huefte und Knie.',
      vetNote: 'Der groesste Roehrenknochen des Hundes.',
      pos: Offset(0.720, 0.450),
    ),
    AnatomyPart(
      number: 17,
      name: 'Kniegelenk',
      region: AnatomyRegion.hind,
      where: 'Gelenk mit Kniescheibe, vorne am Hinterbein.',
      vetNote: 'Hier passieren Kreuzbandriss und "Patellaluxation" '
          '(springende Kniescheibe).',
      pos: Offset(0.745, 0.575),
    ),
    AnatomyPart(
      number: 18,
      name: 'Schienbein & Wadenbein',
      region: AnatomyRegion.hind,
      where: 'Die zwei Unterschenkel-Knochen.',
      vetNote: 'Zwischen Knie und Sprunggelenk.',
      pos: Offset(0.765, 0.690),
    ),
    AnatomyPart(
      number: 19,
      name: 'Sprunggelenk',
      region: AnatomyRegion.hind,
      where: 'Das stark gewinkelte Gelenk tief am Hinterbein.',
      vetNote: 'Entspricht unserem Fussknoechel - oft mit dem Knie '
          'verwechselt.',
      pos: Offset(0.740, 0.820),
    ),
    AnatomyPart(
      number: 20,
      name: 'Mittelfussknochen',
      region: AnatomyRegion.hind,
      where: 'Die langen Knochen der Hinterpfote vor den Zehen.',
      vetNote: 'Tragen das Gewicht beim Stehen und Laufen.',
      pos: Offset(0.730, 0.920),
    ),
  ];
}
