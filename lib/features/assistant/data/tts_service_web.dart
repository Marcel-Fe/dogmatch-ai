import 'package:web/web.dart' as web;

/// Web-Sprachausgabe via Web Speech API (SpeechSynthesis). Offline,
/// kostenlos, in modernen Browsern verfuegbar.
class TtsService {
  const TtsService();

  bool get isAvailable {
    try {
      // Greift einmal zu - wirft, falls API fehlt.
      web.window.speechSynthesis;
      return true;
    } catch (_) {
      return false;
    }
  }

  void speak(String text, {String lang = 'de-DE'}) {
    if (text.trim().isEmpty) return;
    final synth = web.window.speechSynthesis;
    // Vorherige Aussage abbrechen, damit es nicht ueberlappt.
    synth.cancel();
    final utterance = web.SpeechSynthesisUtterance(text)
      ..lang = lang
      ..rate = 1.0
      ..pitch = 1.0;
    synth.speak(utterance);
  }

  void stop() {
    try {
      web.window.speechSynthesis.cancel();
    } catch (_) {
      // ignorieren - Browser unterstuetzt evtl. nicht
    }
  }
}
