import 'package:flutter/material.dart';

/// Zentrale Farb-Tokens. Keine Farbe wird direkt in Widgets geschrieben -
/// immer ueber diese Klasse, damit das Design an einer Stelle steuerbar bleibt.
///
/// Palette angelehnt an "Horizon UI": helle, blau-graue Seitenflaeche mit
/// weissen Karten und weichen Schatten, kraeftiges Indigo als Akzent, navy
/// Text. Dark-Mode in tiefem Navy.
class AppColors {
  AppColors._();

  // Markenfarben (Horizon-Indigo)
  static const Color primary = Color(0xFF4318FF); // Horizon-Brand-Indigo
  static const Color primaryDark = Color(0xFF3311DB);
  static const Color primarySoft = Color(0xFFEAE5FF); // helle Indigo-Flaeche
  static const Color accent = Color(0xFF7551FF); // helles Indigo

  // Statusfarben (Horizon)
  static const Color success = Color(0xFF01B574);
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFEE5D50);

  // Light Theme - Seite blau-grau, Karten weiss
  static const Color lightBackground = Color(0xFFF4F7FE);
  static const Color lightSurface = Color(0xFFFFFFFF); // Kartenfarbe
  static const Color lightTextPrimary = Color(0xFF1B2559); // Navy
  static const Color lightTextSecondary = Color(0xFF707EAE); // gedaempftes Grau
  static const Color lightBorder = Color(0xFFE0E5F2);

  // Dark Theme - tiefes Navy, Karten etwas heller
  static const Color darkBackground = Color(0xFF0B1437);
  static const Color darkSurface = Color(0xFF111C44); // Kartenfarbe
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA3AED0);
  static const Color darkBorder = Color(0xFF1B254B);

  /// Weicher Karten-Schatten im Horizon-Stil (nur Light-Mode sinnvoll).
  /// rgba(112, 144, 176, 0.12).
  static const Color cardShadow = Color(0x1F7090B0);
}
