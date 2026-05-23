/// Liefert den Hunde-Tipp des heutigen Tages. Stabil ueber den ganzen Tag
/// (alle Zugriffe am selben Tag liefern denselben Tipp), rotiert am
/// naechsten Tag.
class DailyTip {
  DailyTip._();

  static const List<String> _tips = [
    'Lerne die Koerpersprache deines Hundes - leichtes Schwanzwedeln heisst nicht immer Freude.',
    'Welpen brauchen in den ersten Monaten 18 bis 20 Stunden Schlaf pro Tag.',
    'Frischwasser taeglich nachfuellen - Hunde brauchen etwa das Doppelte ihrer Trockenfuttermenge an Wasser.',
    'Schokolade, Zwiebeln und Trauben sind fuer Hunde giftig - selbst kleine Mengen koennen gefaehrlich sein.',
    'Konstante Routinen geben Hunden Sicherheit. Feste Zeiten fuer Fuetterung und Spaziergaenge helfen enorm.',
    'Drei kurze Spaziergaenge sind oft besser als ein langer - das schont Gelenke und entlastet den Kopf.',
    'Positive Verstaerkung wirkt besser als Schimpfen: Lob und Leckerli erzeugen schneller gewuenschtes Verhalten.',
    'Krallen regelmaessig kontrollieren - zu lange Krallen koennen schmerzhafte Fehlhaltungen verursachen.',
    'Sozialisierung im Welpenalter ist entscheidend: viele Menschen, Hunde und Reize fruehzeitig kennenlernen.',
    'Achte auf das Gewicht: du solltest die Rippen leicht ertasten, aber nicht sehen koennen.',
    'Zahnpflege wird oft vergessen - regelmaessiges Putzen oder Zahn-Snacks beugen Zahnstein vor.',
    'Bei Hitze: Spaziergaenge auf frueh oder spaet verlegen, heisser Asphalt verbrennt Pfoten.',
    'Geistige Auslastung wie Schnueffelspiele ist oft anstrengender als reines Laufen.',
    'Stresssignale wie Gaehnen, Lippenlecken oder Wegdrehen zeigen Ueberforderung - dann Pause einlegen.',
    'Erholung ist genauso wichtig wie Bewegung - eine ruhige Schlafstelle ohne Stoerung ist Pflicht.',
  ];

  /// Liefert den Tipp fuer [now] (Default: jetzt). Optionaler Parameter
  /// erleichtert Unit-Tests mit festen Datumswerten.
  static String forToday([DateTime? now]) {
    final today = now ?? DateTime.now();
    final yearStart = DateTime(today.year);
    final dayOfYear = today.difference(yearStart).inDays;
    return _tips[dayOfYear % _tips.length];
  }
}
