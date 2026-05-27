import 'package:dogmatch_ai/features/symptom_check/domain/symptom.dart';

/// Regelbasierte Symptom-Auswertung. Bewusst konservativ: lieber einmal
/// zu oft "Tierarzt aufsuchen" als ein Notfall uebersehen.
///
/// WICHTIG: Das ersetzt keine echte Tierarzt-Diagnose. Die UI weist
/// darauf hin.
class SymptomEngine {
  SymptomEngine._();

  /// Liefert eine sortierte Liste moeglicher Verdachts-Diagnosen.
  /// Reihenfolge: Notfall zuerst, dann nach Plausibilitaet.
  static List<Diagnosis> analyze(Set<String> selectedSymptomIds) {
    final s = selectedSymptomIds;
    final out = <Diagnosis>[];

    // --- Notfaelle (Urgency.emergency) ---
    if (s.contains('collapse') || s.contains('blue-tongue')) {
      out.add(const Diagnosis(
        title: 'Lebensbedrohlicher Zustand',
        urgency: Urgency.emergency,
        description: 'Bewusstlosigkeit oder blaue Schleimhaeute weisen auf '
            'akuten Sauerstoff- oder Kreislauf-Notfall hin.',
        recommendation: 'SOFORT in die Tierklinik fahren - nicht warten, '
            'nicht selbst herumdoktern. Notdienst-Nummer parat halten.',
      ));
    }
    if (s.contains('bloat') &&
        (s.contains('restless') ||
            s.contains('frequent-vomit') ||
            s.contains('apathy'))) {
      out.add(const Diagnosis(
        title: 'Verdacht auf Magendrehung',
        urgency: Urgency.emergency,
        description: 'Aufgeblaehter Bauch + Unruhe/Erbrechen ist bei mittelgrossen '
            'und grossen Rassen ein Tierarzt-Notfall.',
        recommendation: 'Sofort Tierklinik anrufen und hinfahren - die '
            'Minuten entscheiden.',
      ));
    }
    if (s.contains('ate-poison')) {
      out.add(const Diagnosis(
        title: 'Verdacht auf Vergiftung',
        urgency: Urgency.emergency,
        description: 'Schokolade, Weintrauben/Rosinen und Zwiebeln/Knoblauch '
            'sind fuer Hunde toxisch - Schwere haengt von Menge und Groesse ab.',
        recommendation: 'Tierklinik anrufen, Menge + Zeitpunkt mitteilen. '
            'KEIN Erbrechen selbst ausloesen ohne Anweisung.',
      ));
    }
    if (s.contains('ate-foreign') && (s.contains('frequent-vomit') || s.contains('no-poop'))) {
      out.add(const Diagnosis(
        title: 'Verdacht auf Darmverschluss',
        urgency: Urgency.emergency,
        description: 'Fremdkoerper plus haeufiges Erbrechen oder ausbleibender '
            'Kot deutet auf Verstopfung im Darm hin.',
        recommendation: 'Sofort zum Tierarzt - Roentgenbild noetig.',
      ));
    }

    // --- Heute zum Tierarzt (Urgency.urgent) ---
    if (s.contains('choking-cough')) {
      out.add(const Diagnosis(
        title: 'Verdacht auf Zwingerhusten / Atemwegs-Infekt',
        urgency: Urgency.urgent,
        description: 'Trockener Wuergehusten ist typisch fuer eine Infektion '
            'der oberen Atemwege - ansteckend fuer andere Hunde.',
        recommendation: 'Heute zum Tierarzt. Andere Hunde meiden bis zur Diagnose.',
      ));
    }
    if (s.contains('bloody-stool') ||
        (s.contains('vomit') && s.contains('apathy'))) {
      out.add(const Diagnosis(
        title: 'Akute Magen-Darm-Erkrankung',
        urgency: Urgency.urgent,
        description: 'Blut im Kot oder Erbrechen + Apathie kann auf eine '
            'Infektion (z.B. Parvovirose) oder Vergiftung hinweisen.',
        recommendation: 'Heute Tierarzt anrufen. Wasser anbieten, kein Futter '
            'bis zur Untersuchung.',
      ));
    }
    if (s.contains('much-drink') &&
        (s.contains('no-appetite') || s.contains('apathy'))) {
      out.add(const Diagnosis(
        title: 'Moegliche Stoffwechsel-Erkrankung',
        urgency: Urgency.urgent,
        description: 'Starker Durst + Energieverlust kann Diabetes, Niere oder '
            'Gebaermutter-Probleme bedeuten.',
        recommendation: 'In den naechsten 24h Bluttest + Urin-Kontrolle.',
      ));
    }
    if (s.contains('open-wound')) {
      out.add(const Diagnosis(
        title: 'Offene Verletzung',
        urgency: Urgency.urgent,
        description: 'Wunden infizieren sich schnell - Reinigung + ggf. '
            'Antibiotika noetig.',
        recommendation: 'Wunde vorsichtig mit lauwarmem Wasser saeubern, '
            'heute zum Tierarzt.',
      ));
    }
    if (s.contains('fever')) {
      out.add(const Diagnosis(
        title: 'Fieber',
        urgency: Urgency.urgent,
        description: 'Heisse Ohren und Apathie deuten auf Fieber - '
            'normal sind 38-39 Grad, alles ueber 39,5 ist erhoeht.',
        recommendation: 'Wenn moeglich Temperatur rektal messen, dann zum '
            'Tierarzt.',
      ));
    }

    // --- In 1-2 Tagen zum Tierarzt (Urgency.visit) ---
    if (s.contains('limping') || s.contains('wont-walk') || s.contains('pain-touch')) {
      out.add(const Diagnosis(
        title: 'Bewegungs-Problem',
        urgency: Urgency.visit,
        description: 'Lahmheit oder Schmerz bei Beruehrung kann von Pfoten-'
            'Verletzung bis Gelenk-Problem alles sein.',
        recommendation: 'Pfoten + Beine vorsichtig abtasten. Wenn nach 12-24h '
            'keine Besserung: Tierarzt.',
      ));
    }
    if (s.contains('itching') ||
        s.contains('bald-spots') ||
        s.contains('red-skin')) {
      out.add(const Diagnosis(
        title: 'Haut-/Allergie-Verdacht',
        urgency: Urgency.visit,
        description: 'Anhaltendes Kratzen, kahle Stellen oder gerotete Haut '
            'sprechen fuer Parasiten (Floehe/Milben) oder eine Allergie.',
        recommendation: 'Fell + Haut systematisch absuchen, Tierarzt '
            'in den naechsten Tagen.',
      ));
    }
    if (s.contains('red-eye')) {
      out.add(const Diagnosis(
        title: 'Augen-Entzuendung',
        urgency: Urgency.visit,
        description: 'Geroetete oder traenende Augen sind oft Konjunktivitis '
            'oder Fremdkoerper.',
        recommendation: 'Auge nicht reiben lassen. Tierarzt in 1-2 Tagen, '
            'bei starker Truebung sofort.',
      ));
    }
    if (s.contains('ear-shake')) {
      out.add(const Diagnosis(
        title: 'Ohren-Entzuendung-Verdacht',
        urgency: Urgency.visit,
        description: 'Staendiges Kopfschuetteln deutet auf Otitis '
            '(Ohrentzuendung) oder Milben hin.',
        recommendation: 'Ohren auf braunen Schmodder + Geruch pruefen. '
            'Tierarzt einplanen.',
      ));
    }
    if (s.contains('tick')) {
      out.add(const Diagnosis(
        title: 'Zecken-Befall',
        urgency: Urgency.visit,
        description: 'Zecken koennen Borreliose oder Anaplasmose uebertragen.',
        recommendation: 'Zecke mit Zecken-Karte/Pinzette ziehen, Stelle '
            'beobachten. Bei Rotung oder Mattigkeit: Tierarzt.',
      ));
    }

    // --- Beobachten (Urgency.routine) ---
    if (s.contains('diarrhea') && out.isEmpty) {
      out.add(const Diagnosis(
        title: 'Leichter Magen-Darm-Reizung',
        urgency: Urgency.routine,
        description: 'Einzelner Durchfall ohne weitere Symptome ist oft '
            'eine voruebergehende Futter-Reaktion.',
        recommendation: 'Schonkost (gekochtes Huhn + Reis), viel Wasser. '
            'Wenn nach 24h keine Besserung: Tierarzt.',
      ));
    }
    if (s.contains('vomit') && out.isEmpty) {
      out.add(const Diagnosis(
        title: 'Einmaliges Erbrechen',
        urgency: Urgency.routine,
        description: 'Einmaliges Erbrechen ohne andere Symptome ist oft '
            'harmlos (zu schnell gefressen, Gras).',
        recommendation: '12h Futterkarenz, dann Schonkost. Bei Wiederholung: '
            'Tierarzt.',
      ));
    }
    if (s.contains('cough') && out.isEmpty) {
      out.add(const Diagnosis(
        title: 'Leichter Husten',
        urgency: Urgency.routine,
        description: 'Gelegentliches Husten ohne weitere Symptome kann '
            'Reizung der Atemwege sein.',
        recommendation: 'Beobachten. Wenn laenger als 2 Tage oder Wuergen: Tierarzt.',
      ));
    }

    // Fallback wenn keine Regel gegriffen hat
    if (out.isEmpty && s.isNotEmpty) {
      out.add(const Diagnosis(
        title: 'Unspezifischer Befund',
        urgency: Urgency.visit,
        description: 'Die gewaehlten Symptome lassen keine eindeutige Zuordnung zu.',
        recommendation: 'Bei Unsicherheit lieber den Tierarzt anrufen - '
            'eine kurze telefonische Einschaetzung kostet nichts.',
      ));
    }

    // Notfaelle nach vorne sortieren.
    out.sort((a, b) => b.urgency.index.compareTo(a.urgency.index));
    return out;
  }
}
