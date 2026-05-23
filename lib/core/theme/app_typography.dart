import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Erzeugt das Text-Theme. Schrift: Plus Jakarta Sans - modern, gut lesbar.
class AppTypography {
  AppTypography._();

  /// Baut ein [TextTheme] mit [primary] als Haupt-Textfarbe und [secondary]
  /// fuer untergeordneten Text (z.B. Beschreibungen).
  static TextTheme textTheme(Color primary, Color secondary) {
    final base = GoogleFonts.plusJakartaSansTextTheme()
        .apply(bodyColor: primary, displayColor: primary);

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium:
          base.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(color: secondary),
    );
  }
}
