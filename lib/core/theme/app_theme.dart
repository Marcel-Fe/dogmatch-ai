import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Seitenwechsel OHNE Animation. Auf der schweren Web-Engine (CanvasKit) ist
/// die animierte Standard-Ueberblendung auf dem iPhone traege ("dauert lang
/// bei zurueck") - ein sofortiger Wechsel fuehlt sich schnell und reaktiv an.
class _InstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const _InstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

const _instantTransitions = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: _InstantPageTransitionsBuilder(),
    TargetPlatform.iOS: _InstantPageTransitionsBuilder(),
    TargetPlatform.macOS: _InstantPageTransitionsBuilder(),
    TargetPlatform.windows: _InstantPageTransitionsBuilder(),
    TargetPlatform.linux: _InstantPageTransitionsBuilder(),
    TargetPlatform.fuchsia: _InstantPageTransitionsBuilder(),
  },
);

/// Setzt die Light- und Dark-[ThemeData] aus den Design-Tokens zusammen.
/// Komponenten-Feinschliff (Karten, Navigationsleiste) folgt in Phase 6;
/// Phase 1 stuetzt sich bewusst auf die Material-3-Defaults des ColorScheme.
class AppTheme {
  AppTheme._();

  static ThemeData light({Color? seed}) => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        textPrimary: AppColors.lightTextPrimary,
        textSecondary: AppColors.lightTextSecondary,
        seed: seed,
      );

  static ThemeData dark({Color? seed}) => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        seed: seed,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color textPrimary,
    required Color textSecondary,
    Color? seed,
  }) {
    // Akzentfarbe: vom Nutzer gewaehltes Dashboard-Design, sonst Standard.
    final accent = seed ?? AppColors.primary;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ).copyWith(
      primary: accent,
      secondary: AppColors.accent,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      pageTransitionsTheme: _instantTransitions,
      textTheme: AppTypography.textTheme(textPrimary, textSecondary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}
