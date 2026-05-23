import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Verwaltet, ob die App hell, dunkel oder im Systemmodus laeuft.
/// In Phase 1 nur im Speicher - die Persistenz folgt mit `shared_preferences`.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) => state = mode;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

/// Globaler Provider fuer den Theme-Modus. Widgets lesen ihn mit
/// `ref.watch(themeModeProvider)`.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
