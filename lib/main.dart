import 'package:dogmatch_ai/app/app.dart';
import 'package:dogmatch_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de');
  // ignore: avoid_print
  print('[DogMatch] main() gestartet - vor Firebase.initializeApp');
  try {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: avoid_print
    print('[DogMatch] Firebase OK: name=${app.name} projectId=${app.options.projectId}');
  } catch (e, st) {
    // ignore: avoid_print
    print('[DogMatch] Firebase nicht initialisiert: $e');
    // ignore: avoid_print
    print('[DogMatch] StackTrace: $st');
  }
  runApp(const ProviderScope(child: DogMatchApp()));
}
