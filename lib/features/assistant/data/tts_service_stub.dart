/// Stub fuer Plattformen ohne Web-Sprachausgabe. Auf Mobile kommt in
/// Phase 5 ein natives Plugin (z. B. flutter_tts) zum Einsatz.
class TtsService {
  const TtsService();

  bool get isAvailable => false;

  void speak(String text, {String lang = 'de-DE'}) {
    // bewusst leer - Stub
  }

  void stop() {}
}
