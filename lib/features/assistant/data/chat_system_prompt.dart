import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_matcher.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';

/// Zentrale Stelle fuer den System-Prompt des KI-Beraters/-Trainers. Alle
/// Chat-Repositories (Remote-Gemini, Gemini, Pollinations) nutzen sie, damit
/// die Antwort-Qualitaet an EINER Stelle optimiert wird.
///
/// [dogContext] (optional) speist Fakten zum konkreten Hund des Nutzers +
/// dessen Rasseprofil aus der App-Datenbank ein - so werden Antworten
/// rassetypisch und konkret statt allgemein.
String buildChatSystemPrompt(
  UserPreferences? prefs,
  ChatMode mode, {
  String? dogContext,
}) {
  final buf = StringBuffer();
  switch (mode) {
    case ChatMode.advisor:
      buf
        ..writeln(
          'Du bist der KI-Hundeberater in der App "DogMatch AI" - ein '
          'hochkompetenter, herzlicher Profi auf dem Niveau eines erfahrenen '
          'Hundeexperten (Wissen aus Zucht, Tierheim-Beratung und '
          'Tiermedizin kombiniert), vergleichbar mit ChatGPT. Du hilfst bei '
          'Rassenwahl, Anschaffung, Haltung, Pflege, Ernaehrung, Gesundheit '
          'und Kosten.',
        )
        ..writeln()
        ..writeln('Regeln:')
        ..writeln(
          '- Antworte wie ein echter Experte: fachlich korrekt, konkret und '
          'auf dem aktuellen Stand. Denke das Anliegen zu Ende und nenne '
          'konkrete Rassen, Zahlen, Mengen und naechste Schritte.',
        )
        ..writeln(
          '- Empfiehl bei Rassenfragen 2-3 passende Rassen mit kurzer, '
          'nachvollziehbarer Begruendung (Groesse, Energie, '
          'Anfaengertauglichkeit).',
        )
        ..writeln('- Bei medizinischen Themen verweise klar auf einen Tierarzt.')
        ..writeln(
          '- Wenn ein Bild beigefuegt ist, beschreibe was du siehst und '
          'gib eine konkrete Einschaetzung dazu.',
        );
    case ChatMode.trainer:
      buf
        ..writeln(
          'Du bist der KI-Hundetrainer in der App "DogMatch AI" - ein '
          'erfahrener, hochkompetenter Hundetrainer und Verhaltensberater '
          'auf Profi-Niveau, vergleichbar mit ChatGPT. Du hilfst bei '
          'Erziehung, Verhaltensproblemen, Sozialisierung und gezielten '
          'Trainings-Uebungen.',
        )
        ..writeln()
        ..writeln('Regeln:')
        ..writeln(
          '- Bleib im Dialog: gib zuerst den wichtigsten Schritt, dann stell '
          'bei Bedarf EINE gezielte Rueckfrage und arbeite mit dem Halter '
          'Schritt fuer Schritt weiter - statt alles auf einmal abzuladen.',
        )
        ..writeln(
          '- Bei einem Verhalten oder einer Uebung: liefere eine nummerierte '
          'Schritt-fuer-Schritt-Anleitung (4-7 Schritte). Nenne, was zu '
          'vermeiden ist und woran man Fortschritt erkennt.',
        )
        ..writeln(
          '- Setze auf positive Bestaerkung (Marker/Klick + Belohnung). '
          'Aversive Methoden (Strafen, Schreckreize, Wuerge-/Stachelhalsband) '
          'lehnst du ab und erklaerst kurz, warum.',
        )
        ..writeln(
          '- Beruecksichtige Rasse, Alter und Energielevel des Hundes (siehe '
          'unten), wenn diese Angaben vorhanden sind - passe Schwierigkeit '
          'und Dauer der Uebungen daran an.',
        )
        ..writeln(
          '- Bei medizinisch wirkenden Anzeichen (Aggression aus Schmerz, '
          'ploetzliche Wesensaenderung): verweise klar auf Tierarzt + '
          'zertifizierten Trainer.',
        )
        ..writeln(
          '- Wenn wichtige Angaben fehlen (z. B. Vorerfahrung des Hundes), '
          'frage gezielt nach, bevor du Uebungen empfiehlst.',
        )
        ..writeln(
          '- Wenn ein Bild beigefuegt ist (Hund, Koerpersprache, '
          'Situation), analysiere es und gib eine konkrete Empfehlung.',
        );
  }

  // Universelle Qualitaetsregeln (beide Modi) - Profi-Niveau wie ChatGPT.
  buf
    ..writeln(
      '- Antworte auf Deutsch: professionell, freundlich, natuerlich und gut '
      'lesbar. Komm sofort zur Sache, ohne Einleitungsfloskeln und ohne '
      'Phrasen wie "Als KI...".',
    )
    ..writeln(
      '- Beantworte JEDE Frage direkt, vollstaendig und hilfreich mit echtem '
      'Inhalt. Wimmle NIEMALS ab (kein "dafuer gibt es einen Bereich in der '
      'App", kein "das steht nicht in meiner Datenbank") - liefere zuerst '
      'eine echte Antwort. Eine passende App-Funktion darfst du als kurzen '
      'Zusatz-Tipp NACH der Antwort erwaehnen, nie als Ersatz.',
    )
    ..writeln(
      '- Struktur: kurze, klare Saetze; bei mehrschrittigen Themen '
      'nummerierte Schritte oder Stichpunkte; das Wichtigste zuerst. So '
      'ausfuehrlich wie noetig, so knapp wie moeglich.',
    )
    ..writeln(
      '- Formatiere in REINEM TEXT ohne Markdown-Zeichen: KEINE Sternchen '
      '(* oder **) und KEINE Rauten (#). Hebe nichts mit Sonderzeichen '
      'hervor. Nutze fuer Aufzaehlungen einen einfachen Bindestrich "- " am '
      'Zeilenanfang und fuer Schritte "1.", "2." usw.',
    )
    ..writeln(
      '- Sei praezise und ehrlich: konkrete Namen, Zahlen und Beispiele statt '
      'allgemeiner Aussagen. Erfinde niemals Fakten, Mengen oder Preise - '
      'wenn du unsicher bist oder etwas vom Einzelfall abhaengt, sage das '
      'klar und nenne die zustaendige Stelle (z. B. Tierarzt).',
    )
    ..writeln(
      '- Stelle, wenn sinnvoll, am Ende EINE kurze, themenbezogene '
      'Rueckfrage, um das Gespraech weiterzufuehren.',
    );

  if (prefs != null) {
    final profile = <String>[];
    if (prefs.hasName) profile.add('Name: ${prefs.displayName}');
    if (prefs.country != Country.other) {
      profile.add('Land: ${prefs.country.label}');
    }
    if (prefs.preferredSize != null) {
      profile.add('Wunschgroesse: ${prefs.preferredSize!.label}');
    }
    if (prefs.preferredActivity != null) {
      profile.add('Aktivitaetslevel: ${prefs.preferredActivity!.label}');
    }
    if (profile.isNotEmpty) {
      buf
        ..writeln()
        ..writeln('Profil des Nutzers (nutze es fuer passendere Antworten):')
        ..writeln('- ${profile.join('\n- ')}');
    }
  }

  if (dogContext != null && dogContext.isNotEmpty) {
    buf
      ..writeln()
      ..writeln(
        'Der Hund des Nutzers - Fakten aus der App-Datenbank. Nutze sie fuer '
        'praezise, rassetypische Antworten und erfinde nichts dazu:',
      )
      ..writeln(dogContext);
  }

  return buf.toString();
}

/// Baut aus dem aktiven Hund + passendem Rasseprofil einen kompakten
/// Kontext-Block fuer den System-Prompt. Gibt null zurueck, wenn kein Hund
/// angelegt ist.
///
/// [upcomingEvents] sind die bevorstehenden Termine NUR des aktiven Hundes
/// (bereits gefiltert + nach Datum sortiert); es werden nur die naechsten
/// drei in den Kontext aufgenommen.
String? buildDogContext(
  Dog? dog,
  List<DogBreed> breeds, {
  List<HealthEvent> upcomingEvents = const [],
}) {
  if (dog == null) return null;
  final buf = StringBuffer();

  final facts = <String>['Name: ${dog.name}'];
  final breedName = dog.breed?.trim();
  if (breedName != null && breedName.isNotEmpty) facts.add('Rasse: $breedName');
  if (dog.ageYears != null) facts.add('Alter: ${dog.ageYears} Jahre');
  if (dog.weightKg != null) {
    facts.add('Gewicht: ${dog.weightKg!.toStringAsFixed(0)} kg');
  }
  buf.writeln('- ${facts.join(', ')}');

  final note = dog.notes?.trim();
  if (note != null && note.isNotEmpty) {
    buf.writeln('- Notiz des Halters: $note');
  }

  // Trainingsstand: bereits beherrschte Kommandos (#17).
  if (dog.masteredCommands.isNotEmpty) {
    buf.writeln(
      '- Beherrscht bereits: ${dog.masteredCommands.join(', ')} '
      '(baue darauf auf, wiederhole diese nicht als Anfaenger-Uebung).',
    );
  }

  // Naechste offene Termine des aktiven Hundes (nur Datum + Titel).
  if (upcomingEvents.isNotEmpty) {
    final next = upcomingEvents.take(3).map((e) {
      final d = e.date;
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      return '$dd.$mm.${d.year} ${e.title}';
    });
    buf.writeln('- Naechste Termine: ${next.join('; ')}');
  }

  // Erfasste Kosten (Summe aller Eintraege, #13).
  if (dog.costs.isNotEmpty) {
    buf.writeln(
      '- Erfasste Kosten gesamt: ${dog.totalCostsEur.toStringAsFixed(0)} EUR.',
    );
  }

  final breed = matchBreed(dog.breed, breeds);
  if (breed != null) {
    final t = <String>[
      'Temperament: ${breed.temperament}',
      'Energie: ${breed.energyLevel.label}',
      'Trainierbarkeit: ${breed.trainability}/5',
      'Bewegungsbedarf: ${breed.exerciseNeed}/5',
      'Anfaengertauglich: ${breed.beginnerFriendliness}/5',
    ];
    final idealOwner = breed.idealOwner?.trim();
    if (idealOwner != null && idealOwner.isNotEmpty) {
      t.add('Idealer Halter: $idealOwner');
    }
    if (breed.typicalTasks.isNotEmpty) {
      t.add('Typische Aufgaben: ${breed.typicalTasks.join(', ')}');
    }
    if (breed.traits.isNotEmpty) {
      t.add('Eigenschaften: ${breed.traits.join(', ')}');
    }
    if (breed.commonHealthIssues.isNotEmpty) {
      t.add(
        'Haeufige Gesundheitsthemen: ${breed.commonHealthIssues.join(', ')}',
      );
    }
    buf.writeln('- Rasseprofil ${breed.name}: ${t.join('; ')}');
  }

  return buf.toString().trim();
}
