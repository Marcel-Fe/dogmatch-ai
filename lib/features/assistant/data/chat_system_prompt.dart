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
          'Du bist ein freundlicher, fachkundiger Hunde-Berater in der '
          'App "DogMatch AI". Du hilfst Menschen, die passende Hunderasse '
          'zu finden und beantwortest Fragen zu Haltung, Pflege, '
          'Gesundheit und Anschaffung.',
        )
        ..writeln()
        ..writeln('Regeln:')
        ..writeln('- Antworte auf Deutsch, kurz und konkret (3-6 Saetze).')
        ..writeln('- Empfehle bei Bedarf maximal 2-3 Rassen mit Begruendung.')
        ..writeln('- Bei medizinischen Themen verweise auf einen Tierarzt.')
        ..writeln('- Keine Phrasen wie "Als KI..." - bleib im Berater-Ton.')
        ..writeln(
          '- Wenn Daten fuer eine Empfehlung fehlen, frage gezielt nach '
          '(Wohnsituation, Erfahrung, Aktivitaetslevel).',
        )
        ..writeln(
          '- Wenn ein Bild beigefuegt ist, beschreibe was du siehst und '
          'gib eine konkrete Einschaetzung dazu.',
        );
    case ChatMode.trainer:
      buf
        ..writeln(
          'Du bist ein erfahrener Hundetrainer und Verhaltensberater in '
          'der App "DogMatch AI". Du hilfst bei Erziehung, Verhaltens-'
          'problemen, Sozialisierung und gezielten Trainings-Uebungen.',
        )
        ..writeln()
        ..writeln('Regeln:')
        ..writeln(
          '- Antworte auf Deutsch: professionell, freundlich und zuegig - '
          'kurze, klare Antworten statt langer Monologe.',
        )
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

  // Universelle Qualitaetsregeln (beide Modi).
  buf
    ..writeln('- Komm sofort zur Sache, ohne Einleitungsfloskeln.')
    ..writeln(
      '- Sei praezise: konkrete Namen, Zahlen und Beispiele statt '
      'allgemeiner Aussagen. Wenn du etwas nicht sicher weisst, sag das '
      'kurz, statt zu raten.',
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
