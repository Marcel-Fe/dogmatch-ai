import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

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
  external int get length;
  external _ResultItem item(int index);
}

extension type _ResultItem._(JSObject _) implements JSObject {
  external int get length;
  external bool get isFinal;
  external _Alternative item(int index);
}

extension type _Alternative._(JSObject _) implements JSObject {
  external String get transcript;
}

class SttService {
  SttService();

  _Recognition? _current;
  bool _userStopped = false;

  bool get isAvailable {
    try {
      return _speechRecognitionCtor != null ||
          _webkitSpeechRecognitionCtor != null;
    } catch (_) {
      return false;
    }
  }

  /// True, wenn die App im iOS Safari laeuft - dort gibt es keine
  /// Web-Speech-API. Wird vom UI genutzt, um eine klarere Meldung zu
  /// zeigen ("Apple unterstuetzt das nicht") statt nur "Chrome nutzen".
  bool get isIosSafari {
    try {
      final ua = (web.window.navigator.userAgent).toLowerCase();
      final isIos = ua.contains('iphone') ||
          ua.contains('ipad') ||
          ua.contains('ipod');
      final isSafari = ua.contains('safari') && !ua.contains('crios') &&
          !ua.contains('fxios') && !ua.contains('edgios');
      return isIos && isSafari;
    } catch (_) {
      return false;
    }
  }

  /// Startet eine Sprach-Aufnahme im "ChatGPT-Stil": laeuft weiter, auch
  /// wenn der Nutzer kurz ueberlegt. Stoppt erst, wenn der Nutzer aktiv
  /// [stop] ruft - dann liefert der Future den gesamten gesprochenen Text.
  ///
  /// Wirft StateError, wenn die Web-Speech-API nicht verfuegbar ist.
  Future<String?> listenOnce({String lang = 'de-DE'}) async {
    final ctor = _speechRecognitionCtor ?? _webkitSpeechRecognitionCtor;
    if (ctor == null) {
      throw StateError(
        'SpeechRecognition wird vom Browser nicht unterstuetzt.',
      );
    }

    _userStopped = false;
    // `callAsConstructor` ruft `new ...()` auf. Das alte `newInstance()`
    // war kein existierender API-Name und loeste NoSuchMethodError aus.
    final instance = ctor.callAsConstructor<JSObject>();
    final rec = _Recognition._(instance)
      ..lang = lang
      // continuous: der Browser stoppt nicht nach kurzer Stille.
      ..continuous = true
      // interimResults: wir bekommen schon waehrend des Sprechens
      // Updates - die nutzen wir aber erst beim Final-Buffer-Schreiben.
      ..interimResults = true
      ..maxAlternatives = 1;
    _current = rec;

    final completer = Completer<String?>();
    final finalBuffer = StringBuffer();

    void safeComplete(String? value) {
      if (!completer.isCompleted) completer.complete(value);
    }

    rec.onresult = ((JSObject ev) {
      try {
        final list = _ResultEvent._(ev).results;
        // Wir akkumulieren NUR Final-Ergebnisse - die interim-Texte
        // erscheinen bei jedem onresult-Aufruf erneut, koennten sich
        // also doppeln.
        finalBuffer.clear();
        for (var i = 0; i < list.length; i++) {
          final item = list.item(i);
          if (item.length == 0 || !item.isFinal) continue;
          finalBuffer.write(item.item(0).transcript);
        }
      } catch (_) {
        // Einzelnes onresult-Event hat ein anderes Format - ignorieren,
        // naechstes Event liefert den vollen Stand.
      }
    }).toJS;

    rec.onend = ((JSObject _) {
      if (_userStopped) {
        safeComplete(finalBuffer.toString().trim());
        return;
      }
      // Browser hat aus Inaktivitaet beendet (typisch ~60s Stille).
      // Sofort wieder anwerfen, damit der Nutzer einfach weitersprechen
      // kann - das fuehlt sich an wie kontinuierliches Diktat.
      try {
        rec.start();
      } catch (_) {
        // Kann nicht neugestartet werden (z. B. Permission entzogen).
        // Wir liefern, was wir bisher haben.
        safeComplete(finalBuffer.toString().trim());
      }
    }).toJS;

    rec.onerror = ((JSObject _) {
      // Auf Fehler nicht sofort completen - der Browser ruft danach
      // ohnehin onend; dort entscheiden wir je nach userStopped.
    }).toJS;

    rec.start();
    return completer.future;
  }

  void stop() {
    _userStopped = true;
    try {
      _current?.stop();
    } catch (_) {
      // ignorieren
    }
    _current = null;
  }
}
