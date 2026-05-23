import 'package:dogmatch_ai/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope ist die Wurzel des Riverpod-State-Managements.
  runApp(const ProviderScope(child: DogMatchApp()));
}
