/// Stub fuer Plattformen ohne Web-Sprach-Eingabe.
class SpeechInputService {
  SpeechInputService();

  bool get isAvailable => false;

  Future<String?> listenOnce({String lang = 'de-DE'}) async => null;

  void stop() {}
}
