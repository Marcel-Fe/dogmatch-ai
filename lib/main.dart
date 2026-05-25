import 'package:dogmatch_ai/app/app.dart';
import 'package:dogmatch_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lade deutsche Datumsfomate, damit DateFormat.yMMMMd('de') sicher rendert.
  await initializeDateFormatting('de');
  // Firebase nur initialisieren, wenn die Plattform Optionen kennt.
  // Mobile-Builds folgen, wenn die Apps in der Firebase Console registriert
  // sind - bis dahin laeuft die App dort weiterhin offline.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase nicht initialisiert: $e - App laeuft offline.');
    }
  }
  runApp(const ProviderScope(child: DogMatchApp()));
}
