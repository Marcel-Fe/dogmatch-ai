/// Liefert einen stuendlich wechselnden Wissens-Spruch zu Hunden.
/// Reine Daten + Funktion, kein State. Tests verlassen sich auf
/// determinitisches Verhalten: gleiche Stunde -> gleicher Spruch.
class HourlyQuote {
  HourlyQuote._();

  /// 24 Sprueche - einer pro Stunde des Tages. Inhaltlich Mischung aus
  /// Fakten, Verhaltens-Tipps und kurzen Weisheiten.
  static const List<String> quotes = [
    'Hunde traeumen aehnlich wie wir - im REM-Schlaf zucken Pfoten und Schnauze.',
    'Ein Hund kann ueber 100.000-mal besser riechen als ein Mensch.',
    'Belohnung wirkt staerker als Strafe - Hunde lernen am besten in 3-5 Min Sequenzen.',
    'Das Wedeln nach rechts deutet auf Freude, nach links eher auf Unsicherheit.',
    'Schoko, Trauben, Zwiebeln und Xylit sind fuer Hunde giftig - immer ausser Reichweite.',
    'Hunde brauchen Pausen: 17-20 Stunden Ruhe am Tag sind normal und gesund.',
    'Augenkontakt mit deinem Hund setzt bei beiden Oxytocin frei - das Bindungshormon.',
    'Sozialisierung in den Wochen 3-16 praegt das Wesen ein Leben lang.',
    'Ein gesunder Hund laeuft mit aufrechter, lockerer Rute und entspannter Schnauze.',
    'Trockenfutter braucht frisches Wasser daneben - sonst belastet es die Nieren.',
    'Welpenstubenrein wird ein Hund mit konsequentem Lob nach dem Geschaeft draussen.',
    'Hunde verstehen ueber 150 Woerter - manche Rassen sogar 200+.',
    'Das Bauch zeigen heisst Vertrauen - aber nur, wenn der Koerper sonst entspannt ist.',
    'Heisser Asphalt > 50 Grad C verbrennt Pfoten - 5-Sekunden-Handflaechen-Test machen.',
    'Lange Spaziergaenge ersetzen kein mentales Training - 10 Min Nasenarbeit ermueden mehr als 1h Joggen.',
    'Bellen ist Kommunikation - finde die Ursache (Langeweile, Angst, Schutz) statt sie nur zu unterdruecken.',
    'Hunde brauchen Routine - feste Fuetterungs- und Spaziergeh-Zeiten reduzieren Stress.',
    'Zerren, Knurren, abgewandter Blick - klare Signale: "Lass mich in Ruhe".',
    'Ein muede gespielter Hund ist ein zufriedener Hund - aber Spielzeug allein reicht nie.',
    'Zecken nach jedem Spaziergang absuchen - besonders Ohren, Halsband-Bereich und zwischen Zehen.',
    'Welpen sollten erst nach ihrem 1. Geburtstag laenger laufen - Wachstumsfugen sind noch offen.',
    'Loben im richtigen Moment heisst innerhalb von 1-2 Sekunden - sonst lernt er das Falsche.',
    'Krallenpflege regelmaessig: klicken sie beim Gehen, sind sie zu lang.',
    'Ein muede gespielter Hund hat ruhige Augen, langsame Atmung und sucht von selbst seinen Platz.',
  ];

  /// Liefert den Spruch fuer die aktuelle Stunde [0..23].
  static String forNow([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    return quotes[hour % quotes.length];
  }
}
