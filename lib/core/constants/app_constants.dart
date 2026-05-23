/// Feste Werte, die an mehreren Stellen der App gebraucht werden.
class AppConstants {
  AppConstants._();

  /// Pfad zu den gebuendelten Beispiel-Rassen.
  static const String breedsAssetPath = 'assets/data/breeds.json';

  /// Freemium-Limits der kostenlosen Stufe.
  static const int freeMatchLimit = 3;
  static const int freeAiMessageLimit = 5;

  /// Anzeigedauer des Splash-Screens.
  static const Duration splashDuration = Duration(milliseconds: 1800);
}
