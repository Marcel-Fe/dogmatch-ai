/// Hundeweisheits-Spruch - jede Stunde rotiert er. Mischung aus
/// Volksweisheiten, Zitaten und konkreten Trainings-Wahrheiten.
class WisdomQuote {
  const WisdomQuote({required this.text, this.author});

  /// Der Spruch selbst.
  final String text;

  /// Optionaler Autor. Null = Volksweisheit / Trainings-Wissen.
  final String? author;
}

/// Liefert einen stuendlich wechselnden Hunde-Spruch.
/// Reine Daten + Funktion, kein State. Tests verlassen sich auf
/// determinitisches Verhalten: gleiche Stunde + gleicher Tag -> gleicher Spruch.
class HourlyQuote {
  HourlyQuote._();

  /// Liste aller Sprueche. 40+ Eintraege, damit pro Tag andere kommen.
  /// Schoene Weisheiten kommen zuerst (werden haeufiger getroffen, wenn
  /// die Stundenzahl in einen anderen Tag rotiert).
  static const List<WisdomQuote> wisdom = [
    WisdomQuote(
      text: 'Bis du jemanden geliebt hast, der Hund war, war ein Teil deiner '
          'Seele noch nicht erwacht.',
      author: 'Anatole France',
    ),
    WisdomQuote(
      text: 'Wer einen Hund hat, hat einen Freund, der nicht fragt, sondern '
          'einfach da ist.',
    ),
    WisdomQuote(
      text: 'Wenn die Augen eines Hundes dich anschauen, sieht eine Seele '
          'dich an.',
    ),
    WisdomQuote(
      text: 'Hunde sind keine ganze Welt - aber sie machen die Welt ganz.',
      author: 'Roger Caras',
    ),
    WisdomQuote(
      text: 'Ein Hund ist die einzige Liebe, die mit dem Schwanz wedeln kann.',
    ),
    WisdomQuote(
      text: 'Ein Hund braucht keine grossen Worte - ein ruhiges Herz neben '
          'ihm genuegt.',
    ),
    WisdomQuote(
      text: 'Der treueste Blick der Welt kommt auf vier Pfoten.',
    ),
    WisdomQuote(
      text: 'Manche Engel haben Fell statt Fluegel.',
    ),
    WisdomQuote(
      text: 'Ein Zuhause ohne Hund ist nur ein Haus.',
    ),
    WisdomQuote(
      text: 'Hunde hinterlassen Pfotenabdruecke auf unseren Herzen.',
    ),
    WisdomQuote(
      text: 'Wer einem Hund in die Augen schaut, vergisst fuer einen Moment '
          'alle Sorgen.',
    ),
    WisdomQuote(
      text: 'Die beste Therapie hat eine kalte Nase und einen warmen Bauch.',
    ),
    WisdomQuote(
      text: 'Ein Hund liebt dich an deinen schlechten Tagen genauso wie an '
          'deinen guten.',
    ),
    WisdomQuote(
      text: 'Gassi gehen ist die schoenste Art, den Kopf frei zu bekommen.',
    ),
    WisdomQuote(
      text: 'Wer mit Hunden lebt, lernt: Vertrauen ist die einzige Sprache, '
          'die wirklich verstanden wird.',
    ),
    WisdomQuote(
      text: 'Glueck ist ein warmer Welpe.',
      author: 'Charles M. Schulz',
    ),
    WisdomQuote(
      text: 'Mein Hund ist mein Spiegel: ist er ruhig, war ich es zuerst.',
    ),

    // Trainings-Weisheiten (konkrete kurze Wahrheiten)
    WisdomQuote(
      text: 'Belohnung in 1-2 Sekunden nach dem Verhalten - sonst lernt dein '
          'Hund das Falsche.',
    ),
    WisdomQuote(
      text: 'Kurze Sequenzen von 3-5 Minuten lernen Hunde besser als eine '
          'lange Stunde Training.',
    ),
    WisdomQuote(
      text: 'Konsistenz schlaegt Strenge: jeder im Haushalt nutzt das gleiche '
          'Signalwort.',
    ),
    WisdomQuote(
      text: '10 Minuten Nasenarbeit ermueden deinen Hund mehr als 1 Stunde '
          'Joggen.',
    ),
    WisdomQuote(
      text: 'Sozialisierung in den Wochen 3-16 praegt das Wesen ein Leben lang.',
    ),
    WisdomQuote(
      text: 'Das Bauch zeigen heisst Vertrauen - aber nur, wenn der Koerper '
          'sonst entspannt ist.',
    ),
    WisdomQuote(
      text: 'Bellen ist Kommunikation - finde die Ursache, statt sie nur zu '
          'unterdruecken.',
    ),
    WisdomQuote(
      text: 'Routine reduziert Stress - feste Fuetterungs- und Spaziergeh-'
          'Zeiten helfen mehr als jedes Spielzeug.',
    ),
    WisdomQuote(
      text: 'Augenkontakt mit deinem Hund setzt bei euch beiden Oxytocin frei - '
          'das Bindungshormon.',
    ),
    WisdomQuote(
      text: 'Das Wedeln nach rechts deutet auf Freude, nach links eher auf '
          'Unsicherheit.',
    ),

    // Fakten - kurze "wusstest du"-Momente
    WisdomQuote(
      text: 'Ein Hund riecht ueber 100.000-mal besser als ein Mensch.',
    ),
    WisdomQuote(
      text: 'Hunde brauchen 17-20 Stunden Ruhe am Tag - das ist normal, kein '
          'Faulsein.',
    ),
    WisdomQuote(
      text: 'Hunde verstehen ueber 150 Woerter - manche Rassen sogar 200+.',
    ),
    WisdomQuote(
      text: 'Hunde traeumen aehnlich wie wir - im REM-Schlaf zucken Pfoten '
          'und Schnauze.',
    ),
    WisdomQuote(
      text: 'Hunde sehen nicht schwarz-weiss - sie sehen blau-gelb wie ein '
          'rot-gruen-blinder Mensch.',
    ),

    // Sicherheits-Wissen
    WisdomQuote(
      text: 'Schoko, Trauben, Zwiebeln und Xylit sind fuer Hunde giftig - '
          'immer ausser Reichweite.',
    ),
    WisdomQuote(
      text: 'Heisser Asphalt > 50 Grad C verbrennt Pfoten - 5-Sekunden-Handflaechen-Test machen.',
    ),
    WisdomQuote(
      text: 'Welpen sollten erst nach ihrem 1. Geburtstag laenger laufen - '
          'Wachstumsfugen sind noch offen.',
    ),
    WisdomQuote(
      text: 'Zecken nach jedem Spaziergang absuchen - besonders Ohren, '
          'Halsband-Bereich und zwischen Zehen.',
    ),
    WisdomQuote(
      text: 'Trockenfutter braucht frisches Wasser daneben - sonst belastet '
          'es die Nieren.',
    ),

    // Beziehung + Stille
    WisdomQuote(
      text: 'Der beste Trainer ist der, der zuhoert - auch wenn der Hund '
          'nichts sagt.',
    ),
    WisdomQuote(
      text: 'Ein Hund liebt nicht trotz deiner Fehler - sondern weil du '
          'jeden Abend wiederkommst.',
    ),
    WisdomQuote(
      text: 'Hunde sind unsere Verbindung zum Hier und Jetzt - sie kennen '
          'keine Vergangenheit, keine Sorgen um morgen.',
    ),
    WisdomQuote(
      text: 'Ein muede gespielter Hund hat ruhige Augen, langsame Atmung und '
          'sucht von selbst seinen Platz.',
    ),
    WisdomQuote(
      text: 'Krallenpflege regelmaessig: klicken sie beim Gehen, sind sie '
          'zu lang.',
    ),
  ];

  /// Index-Berechnung: jede Stunde anders, und ueber Tage rotierend - so
  /// gibt es nicht jeden Tag denselben Spruch zur gleichen Uhrzeit.
  static int _indexFor(DateTime now) {
    final daysSinceEpoch =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/
            (1000 * 60 * 60 * 24);
    final slot = daysSinceEpoch * 24 + now.hour;
    return slot % wisdom.length;
  }

  /// Aktuelle Stunden-Weisheit.
  static WisdomQuote currentWisdom([DateTime? now]) {
    return wisdom[_indexFor(now ?? DateTime.now())];
  }

  /// Rohtext der aktuellen Weisheit - Backwards-Compat fuer alte Aufrufer.
  static String forNow([DateTime? now]) {
    return currentWisdom(now).text;
  }
}
