import 'package:dogmatch_ai/features/behavior_check/domain/behavior.dart';

/// Regelbasierte Verhaltens-Auswertung. Liefert Empfehlungen +
/// optionale Verlinkung auf vorhandene Trainings-Plaene (`sit`, `down`,
/// `heel`, `recall`).
///
/// WICHTIG: Ersetzt keinen zertifizierten Trainer / Verhaltensberater.
class BehaviorEngine {
  BehaviorEngine._();

  static List<BehaviorAssessment> analyze(Set<String> selected) {
    final s = selected;
    final out = <BehaviorAssessment>[];

    // --- TIERARZT + TRAINER (vet) ---
    if (s.contains('sudden-change') || s.contains('aggression-family')) {
      out.add(const BehaviorAssessment(
        title: 'Ploetzliche Verhaltensaenderung',
        priority: BehaviorPriority.vet,
        description:
            'Eine ploetzliche Wesensveraenderung oder Aggression gegen die '
            'eigene Familie kann medizinische Ursachen haben (Schmerzen, '
            'Schilddruese, neurologische Probleme).',
        recommendation:
            'Erst Tierarzt-Check (Blutbild, Schmerz-Diagnostik). Erst '
            'wenn medizinisch ausgeschlossen: zertifizierter '
            'Verhaltensberater.',
      ));
    }
    if (s.contains('aggression-children') || s.contains('aggression-people')) {
      out.add(const BehaviorAssessment(
        title: 'Aggression gegen Menschen',
        priority: BehaviorPriority.vet,
        description:
            'Aggression gegen Menschen - besonders Kinder - ist immer '
            'ein Sicherheitsrisiko und darf nicht selbst trainiert werden.',
        recommendation:
            'Hund sofort von Risiko-Situation fern halten (Maulkorb '
            'einueben, Kinder schuetzen). Tierarzt + zertifizierter '
            'Verhaltensberater. Nicht zoegern.',
      ));
    }

    // --- PROFESSIONELLE HILFE (professional) ---
    if (s.contains('separation-anxiety')) {
      out.add(const BehaviorAssessment(
        title: 'Trennungsangst',
        priority: BehaviorPriority.professional,
        description:
            'Trennungsangst ist ein erlerntes Muster und braucht systematisches '
            'Gegen-Konditionieren. Selbstversuche verschlimmern es oft.',
        recommendation:
            'Trainer mit Spezialisierung Trennungsangst suchen. Zwischenzeit: '
            'kein "Schimpfen" wenn etwas zerstoert ist, sondern Allein-Zeit '
            'sekundenweise aufbauen.',
      ));
    }
    if (s.contains('resource-guarding')) {
      out.add(const BehaviorAssessment(
        title: 'Ressourcen-Verteidigung',
        priority: BehaviorPriority.professional,
        description:
            'Knurren bei Futter / Spielzeug ist ein klares Stress-Signal. '
            'NICHT bestrafen - der Hund hat dann gelernt, gleich zuzubeissen.',
        recommendation:
            'Trainer einbeziehen. Zwischenzeit: nie Futter wegnehmen, '
            'Tauschgeschaefte ueben (Leckerli gegen Spielzeug).',
      ));
    }
    if (s.contains('leash-aggression')) {
      out.add(const BehaviorAssessment(
        title: 'Leinen-Aggression',
        priority: BehaviorPriority.professional,
        description:
            'An der Leine entsteht Aggression oft aus Frustration oder Angst, '
            'weil der Hund nicht ausweichen kann.',
        recommendation:
            'Trainer fuer Leinen-Aggression. Zwischenzeit: Begegnungen '
            'managen (Abstand halten, fruehzeitig abbiegen).',
        trainingPlanId: 'heel',
      ));
    }
    if (s.contains('fear-people')) {
      out.add(const BehaviorAssessment(
        title: 'Angst vor Menschen',
        priority: BehaviorPriority.professional,
        description:
            'Angst-aggressives Verhalten gegen Menschen braucht systematische '
            'Desensibilisierung.',
        recommendation:
            'Trainer mit Schwerpunkt Angst-Verhalten. Hund nie zwingen, sich '
            'fremden Menschen anzunaehern.',
      ));
    }

    // --- STRUKTURIERTES TRAINING (focused) ---
    if (s.contains('leash-pull')) {
      out.add(const BehaviorAssessment(
        title: 'Zieht an der Leine',
        priority: BehaviorPriority.focused,
        description:
            'Leinen-Ziehen entsteht, weil der Hund gelernt hat, dass Ziehen '
            'ihn schneller ans Ziel bringt. Klassisches Trainings-Thema.',
        recommendation:
            'Trainingsplan "Bei Fuss" konsequent durcharbeiten. Ohne lockere '
            'Leine wird kein Schritt weiter gegangen.',
        trainingPlanId: 'heel',
      ));
    }
    if (s.contains('no-recall')) {
      out.add(const BehaviorAssessment(
        title: 'Rueckruf funktioniert nicht',
        priority: BehaviorPriority.focused,
        description:
            'Der Rueckruf muss "geladen" werden - der Hund muss lernen, dass '
            'Kommen sich immer lohnt.',
        recommendation:
            'Trainingsplan "Rueckruf" mit Schleppleine + sehr gutem '
            'Leckerli-Jackpot. Niemals fuer schlechte Dinge (Baden, Heim) '
            'rufen.',
        trainingPlanId: 'recall',
      ));
    }
    if (s.contains('bark-strangers') ||
        s.contains('bark-dogs') ||
        s.contains('bark-doorbell')) {
      out.add(const BehaviorAssessment(
        title: 'Exzessives Bellen',
        priority: BehaviorPriority.focused,
        description:
            'Bellen ist Kommunikation - aber wenn es ueberhand nimmt, fehlt '
            'meistens eine Alternative.',
        recommendation:
            'Trainingsplan "Sitz" + "Platz" festigen. Statt Bellen: Hund auf '
            'seinen Platz schicken. Auf Klingel: Decke + Belohnung.',
        trainingPlanId: 'down',
      ));
    }
    if (s.contains('bark-alone')) {
      out.add(const BehaviorAssessment(
        title: 'Bellen beim Alleinsein',
        priority: BehaviorPriority.focused,
        description:
            'Bellen wenn der Hund allein ist, ist ein klassisches Anzeichen '
            'fuer Verlassenheits-Stress.',
        recommendation:
            'Allein-Bleiben in Sekunden-Schritten aufbauen. Wenn nach 4 Wochen '
            'kein Fortschritt: Trainer (siehe auch Trennungsangst).',
      ));
    }
    if (s.contains('fear-noises')) {
      out.add(const BehaviorAssessment(
        title: 'Geraeuschangst',
        priority: BehaviorPriority.focused,
        description:
            'Gewitter, Silvester, laute Knall-Geraeusche sind klassische Trigger.',
        recommendation:
            'Rueckzugsort schaffen (Hoehle/Box mit Decke). Bei Silvester '
            'rechtzeitig mit Tierarzt ueber Beruhigungs-Praeparat sprechen. '
            'Schritt-fuer-Schritt-Desensibilisierung mit Geraeusch-CDs.',
      ));
    }
    if (s.contains('jumps-up')) {
      out.add(const BehaviorAssessment(
        title: 'Springt Menschen an',
        priority: BehaviorPriority.focused,
        description:
            'Hochspringen aus Begruessungs-Freude ist normales Welpenverhalten '
            ', aber stoerend und gefaehrlich fuer Kinder/Aeltere.',
        recommendation:
            '"Sitz" zur Begruessung trainieren - das Sitzen wird belohnt, '
            'Anspringen ignoriert (kein Augenkontakt, abdrehen).',
        trainingPlanId: 'sit',
      ));
    }
    if (s.contains('destructive') || s.contains('too-much-energy')) {
      out.add(const BehaviorAssessment(
        title: 'Energie nicht ausgelastet',
        priority: BehaviorPriority.focused,
        description:
            'Zerstoerung + permanente Unruhe sind oft Symptome fuer fehlende '
            'koerperliche UND geistige Auslastung.',
        recommendation:
            'Pro Tag: 2x 30-45 Minuten Auslauf + 2x 5-10 Minuten Kopfarbeit '
            '(Nasenarbeit, Schnueffelteppich, einfache Trainings-Sessions).',
      ));
    }
    if (s.contains('pee-indoors') ||
        s.contains('poop-indoors') ||
        s.contains('mark-indoors')) {
      out.add(const BehaviorAssessment(
        title: 'Stubenreinheit-Problem',
        priority: BehaviorPriority.focused,
        description:
            'Wenn ein erwachsener Hund ploetzlich unsauber wird - erst '
            'medizinische Ursachen ausschliessen (Blasenentzuendung).',
        recommendation:
            'Bei Welpen: alle 2h rausgehen, nach Schlaf+Fressen sofort. '
            'Erfolg loben. Bei Erwachsenen: Urin-Test beim Tierarzt.',
      ));
    }

    // --- ALLTAGS-TRAINING (routine) ---
    if (s.contains('whining')) {
      out.add(const BehaviorAssessment(
        title: 'Winseln',
        priority: BehaviorPriority.routine,
        description:
            'Manche Hunde winseln aus Aufregung. Wenn dabei keine '
            'Stress-Signale (Hecheln, Augenrollen) zu sehen sind: trainierbar.',
        recommendation:
            'Winseln konsequent ignorieren (kein Augenkontakt, nicht '
            'ansprechen). Loben sobald er ruhig ist - schon 2-3 Sekunden.',
      ));
    }
    if (s.contains('mount-humans')) {
      out.add(const BehaviorAssessment(
        title: 'Reiten / Aufreiten',
        priority: BehaviorPriority.routine,
        description:
            'Aufreiten ist meist Stress-Verhalten, nicht "Dominanz". '
            'Tritt oft bei Ueberreizung auf.',
        recommendation:
            'Hund aus der Situation nehmen, kurze Pause/Ruhe. Wenn dauerhaft: '
            'Auslastungs-Plan ueberpruefen.',
      ));
    }
    if (s.contains('eats-poop')) {
      out.add(const BehaviorAssessment(
        title: 'Koprophagie (frisst Kot)',
        priority: BehaviorPriority.routine,
        description:
            'Kot fressen ist haeufig und meist ungefaehrlich. Bei eigenem Kot '
            'manchmal Folge von Naehrstoff-Mangel.',
        recommendation:
            'Tierarzt-Check (Mineralien, Verdauungsenzyme). Beim Spaziergang '
            'aufpassen, "Lass es"-Kommando ueben.',
      ));
    }
    if (s.contains('chases-cars')) {
      out.add(const BehaviorAssessment(
        title: 'Jagt sich bewegende Objekte',
        priority: BehaviorPriority.focused,
        description:
            'Jagdtrieb auf Autos/Fahrradfahrer ist gefaehrlich und '
            'selbst-bestaerkend.',
        recommendation:
            'Schleppleine ist Pflicht. Rueckruf-Training intensiv. Trainer '
            'wenn Hund sehr fokussiert ist.',
        trainingPlanId: 'recall',
      ));
    }
    if (s.contains('fear-vet')) {
      out.add(const BehaviorAssessment(
        title: 'Angst beim Tierarzt',
        priority: BehaviorPriority.routine,
        description:
            'Viele Hunde haben Angst beim Tierarzt - das ist normal, aber '
            'man kann es entspannter machen.',
        recommendation:
            'Gewoehnungs-Besuche in der Praxis (rein, Leckerli, wieder raus). '
            'Daheim "Untersuchen" ueben - Pfoten, Ohren, Maul.',
      ));
    }
    if (s.contains('no-other-dogs')) {
      out.add(const BehaviorAssessment(
        title: 'Vertraegt sich nicht mit Hunden',
        priority: BehaviorPriority.focused,
        description:
            'Unvertraeglichkeit mit anderen Hunden ist oft Folge schlechter '
            'Sozialisierung oder schlechter Erfahrungen.',
        recommendation:
            'Schrittweise Begegnungen mit ruhigen, gut sozialisierten Hunden '
            '(Trainer-Hund). Abstand managen, nie zwingen.',
      ));
    }
    if (s.contains('sleep-disturbance')) {
      out.add(const BehaviorAssessment(
        title: 'Schlechter Schlaf',
        priority: BehaviorPriority.routine,
        description:
            'Hunde schlafen 14-18h pro Tag. Anhaltend unruhiger Schlaf kann '
            'auf Stress oder Schmerzen hinweisen.',
        recommendation:
            'Ruhe-Phasen tagsueber sichern. Wenn nach 1 Woche keine Besserung: '
            'Tierarzt-Check.',
      ));
    }
    if (s.contains('leash-fear')) {
      out.add(const BehaviorAssessment(
        title: 'Leinen-Angst',
        priority: BehaviorPriority.focused,
        description:
            'Wenn der Hund vor der Leine flieht oder blockiert: oft '
            'Folge negativer Erfahrungen.',
        recommendation:
            'Leine ohne Spaziergang positiv besetzen (Leckerli auf der Leine, '
            'kurz anziehen + Belohnung). Spaziergang erst wenn Leine entspannt.',
      ));
    }

    // Fallback wenn nichts greift
    if (out.isEmpty && s.isNotEmpty) {
      out.add(const BehaviorAssessment(
        title: 'Unspezifischer Befund',
        priority: BehaviorPriority.focused,
        description:
            'Die gewaehlten Verhaltensweisen lassen keine klare Zuordnung zu.',
        recommendation:
            'Sprich mit einem zertifizierten Hundetrainer - eine kurze '
            'Einschaetzung lohnt sich.',
      ));
    }

    // Sortieren: Notfall (vet) zuerst
    out.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return out;
  }
}
