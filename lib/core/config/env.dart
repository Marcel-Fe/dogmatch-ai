/// Globale App-Konfiguration. In Phase 1 laeuft die App rein offline.
class Env {
  Env._();

  /// Schalter fuer die spaetere Backend-Phase. Solange `false`, nutzt die App
  /// nur lokale und gebuendelte Daten - kein Firebase, keine Konten.
  static const bool useFirebase = false;

  static const String appName = 'DogMatch AI';

  /// Gemini-API-Key fuer den KI-Berater. Wird ueber
  /// `--dart-define=GEMINI_API_KEY=...` an den Build uebergeben - NIEMALS
  /// hier hardcoden! Leer = App nutzt den lokalen Mock-Berater.
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Wahr, wenn ein Gemini-Key gesetzt ist und der echte Berater aktiv sein
  /// soll. Sonst Fallback auf den Mock-Berater.
  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;
}
