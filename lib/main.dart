import 'package:dogmatch_ai/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lade deutsche Datumsfomate, damit DateFormat.yMMMMd('de') sicher rendert.
  await initializeDateFormatting('de');
  // ProviderScope ist die Wurzel des Riverpod-State-Managements.
  runApp(const ProviderScope(child: DogMatchApp()));
}
