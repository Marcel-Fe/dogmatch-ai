import 'dart:async';
import 'dart:js_interop';

/// Web-Sprach-Eingabe via SpeechRecognition (Chromium-Browser). Stoppt
/// nach einer einzelnen Aussage und liefert das transkribierte Ergebnis.
///
/// SpeechRecognition ist (noch) nicht im typisierten `package:web`. Wir
/// definieren die noetige Oberflaeche selbst per `extension type` ueber
/// js_interop.
@JS('webkitSpeechRecognition')
external JSFunction? get _webkitSpeechRecognitionCtor;

@JS('SpeechRecognition')
external JSFunction? get _speechRecognitionCtor;

extension on JSFunction {
  external JSObject newInstance();
}

extension type _Recognition._(JSObject _) implements JSObject {
  external set lang(String v);
  external set continuous(bool v);
  external set interimResults(bool v);
  external set maxAlternatives(int v);
  external set onresult(JSFunction f);
  external set onend(JSFunction f);
  external set onerror(JSFunction f);
  external void start();
  external void stop();
}

extension type _ResultEvent._(JSObject _) implements JSObject {
  external _ResultList get results;
}

extension type _ResultList._(JSObject _) implements JSObject {
  external _ResultItem item(int index);
}

extension type _ResultItem._(JSObject _) implements JSObject {
  external _Alternative item(int index);
}

extension type _Alternative._(JSObject _) implements JSObject {
  external String get transcript;
}

class SttService {
  SttService();

  _Recognition? _current;

  bool get isAvailable {
    try {
      return _speechRecognitionCtor != null ||
          _webkitSpeechRecognitionCtor != null;
    } catch (_) {
      return false;
    }
  }

  /// Startet eine einzelne Aufnahme. Loest den Future mit dem Transkript
  /// oder null (falls nichts erkannt wurde) auf. Wirft StateError, wenn
  /// die API nicht verfuegbar ist.
  Future<String?> listenOnce({String lang = 'de-DE'}) async {
    final ctor = _speechRecognitionCtor ?? _webkitSpeechRecognitionCtor;
    if (ctor == null) {
      throw StateError(
        'SpeechRecognition wird vom Browser nicht unterstuetzt.',
      );
    }

    final rec = _Recognition._(ctor.newInstance())
      ..lang = lang
      ..continuous = false
      ..interimResults = false
      ..maxAlternatives = 1;
    _current = rec;

    final completer = Completer<String?>();
    void safeComplete(String? value) {
      if (!completer.isCompleted) completer.complete(value);
    }

    rec.onresult = ((JSObject ev) {
      try {
        final result = _ResultEvent._(ev);
        final transcript = result.results.item(0).item(0).transcript;
        safeComplete(transcript.trim());
      } catch (_) {
        safeComplete(null);
      }
    }).toJS;

    rec.onend = ((JSObject _) {
      safeComplete(null);
    }).toJS;

    rec.onerror = ((JSObject _) {
      safeComplete(null);
    }).toJS;

    rec.start();
    return completer.future;
  }

  void stop() {
    try {
      _current?.stop();
    } catch (_) {
      // ignorieren
    }
    _current = null;
  }
}
