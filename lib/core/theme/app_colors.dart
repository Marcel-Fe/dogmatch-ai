import 'package:flutter/material.dart';

/// Zentrale Farb-Tokens. Keine Farbe wird direkt in Widgets geschrieben -
/// immer ueber diese Klasse, damit das Design an einer Stelle steuerbar bleibt.
class AppColors {
  AppColors._();

  // Markenfarben
  static const Color primary = Color(0xFF7C6BF0); // sanftes Lila
  static const Color primaryDark = Color(0xFF5B4BD6);
  static const Color primarySoft = Color(0xFFEDEBFD); // helle Lila-Flaeche
  static const Color accent = Color(0xFF5B8DEF); // leichtes Blau

  // Statusfarben
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color error = Color(0xFFFF453A);

  // Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7FB);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6E6E87);
  static const Color lightBorder = Color(0xFFE9E9F2);

  // Dark Theme
  static const Color darkBackground = Color(0xFF131119);
  static const Color darkSurface = Color(0xFF1E1B27);
  static const Color darkTextPrimary = Color(0xFFF4F3F8);
  static const Color darkTextSecondary = Color(0xFFA0A0B8);
  static const Color darkBorder = Color(0xFF2E2A3B);
}
