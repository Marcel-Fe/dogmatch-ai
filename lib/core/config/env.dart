/// Globale App-Konfiguration. In Phase 1 laeuft die App rein offline.
class Env {
  Env._();

  /// Schalter fuer die spaetere Backend-Phase. Solange `false`, nutzt die App
  /// nur lokale und gebuendelte Daten - kein Firebase, keine Konten.
  static const bool useFirebase = false;

  static const String appName = 'DogMatch AI';
}
