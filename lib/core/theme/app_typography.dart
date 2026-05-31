import 'package:flutter/material.dart';

/// Erzeugt das Text-Theme. Schrift: Plus Jakarta Sans - lokal gebundelt
/// (kein Laufzeit-Download), modern und gut lesbar.
class AppTypography {
  AppTypography._();

  /// Name der in der pubspec.yaml deklarierten, gebundelten Schrift.
  static const String fontFamily = 'PlusJakartaSans';

  /// Baut ein [TextTheme] mit [primary] als Haupt-Textfarbe und [secondary]
  /// fuer untergeordneten Text (z.B. Beschreibungen).
  static TextTheme textTheme(Color primary, Color secondary) {
    final base = Typography.material2021().englishLike.apply(
          fontFamily: fontFamily,
          bodyColor: primary,
          displayColor: primary,
        );

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
