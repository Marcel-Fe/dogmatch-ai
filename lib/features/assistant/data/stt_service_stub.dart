/// Stub fuer Plattformen ohne Web-Speech-Recognition.
class SttService {
  const SttService();

  bool get isAvailable => false;

  Future<String?> listenOnce({String lang = 'de-DE'}) async => null;

  void stop() {}
}
