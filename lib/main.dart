import 'dart:async';

import 'package:dogmatch_ai/app/app.dart';
import 'package:dogmatch_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Globaler Fehler-Schutz: ein Fehler in einem einzelnen Widget soll nie die
  // ganze App in einen leeren/weissen Bildschirm kippen lassen, sondern eine
  // lesbare Meldung zeigen (auch ausserhalb des MaterialApp-Kontexts, daher
  // mit eigener Directionality).
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: const Color(0xFF7C6BF0),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Text(
          'Hier ist kurz etwas schiefgelaufen.\n'
          'Bitte die Seite neu laden.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
        ),
      ),
    );
  };

  // runZonedGuarded faengt auch Fehler ausserhalb des Widget-Baums ab, ohne
  // die App zu beenden.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // WICHTIG: Nichts vor runApp darf die App blockieren. Auf dem iPhone
    // (Standalone-PWA) koennen diese Schritte langsam sein oder fehlschlagen -
    // mit Timeout + try/catch startet die App in JEDEM Fall.
    try {
      await initializeDateFormatting('de')
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Datums-Lokalisierung nicht verfuegbar - App startet trotzdem.
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 6));
    } catch (_) {
      // Firebase nicht erreichbar - App laeuft im lokalen Modus weiter.
    }

    runApp(const ProviderScope(child: DogMatchApp()));
  }, (error, stack) {
    // ignore: avoid_print
    print('[DogMatch] Unbehandelter Fehler: $error');
  });
}
