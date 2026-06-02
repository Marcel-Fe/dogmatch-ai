/// Stub fuer Plattformen ohne Web-Speech-Recognition.
class SttService {
  const SttService();

  bool get isAvailable => false;
  bool get isIosSafari => false;

  Future<String?> listenOnce({
    String lang = 'de-DE',
    void Function(String partial)? onPartial,
  }) async =>
      null;

  void stop() {}
}
