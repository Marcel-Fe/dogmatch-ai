import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web-Sprach-Eingabe via Web Speech API (SpeechRecognition).
/// Funktioniert in Chrome/Edge/Safari, nicht in Firefox.
class SpeechInputService {
  SpeechInputService();

  web.SpeechRecognition? _recognition;

  /// Pruefen, ob der Browser die API anbietet. SpeechRecognition existiert
  /// nur in Chromium/Webkit-Browsern.
  bool get isAvailable {
    try {
      web.SpeechRecognition();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Startet eine einmalige Erkennung. Liefert den Transcript-Text
  /// oder null, wenn nichts erkannt oder ein Fehler auftrat.
  Future<String?> listenOnce({String lang = 'de-DE'}) async {
    stop();
    final web.SpeechRecognition rec;
    try {
      rec = web.SpeechRecognition();
    } catch (_) {
      return null;
    }
    rec
      ..lang = lang
      ..continuous = false
      ..interimResults = false
      ..maxAlternatives = 1;

    _recognition = rec;
    final completer = Completer<String?>();

    rec.onresult = ((web.Event event) {
      try {
        final ev = event as web.SpeechRecognitionEvent;
        final results = ev.results;
        if (results.length == 0) {
          if (!completer.isCompleted) completer.complete(null);
          return;
        }
        final first = results.item(0);
        if (first.length == 0) {
          if (!completer.isCompleted) completer.complete(null);
          return;
        }
        final alt = first.item(0);
        if (!completer.isCompleted) completer.complete(alt.transcript);
      } catch (_) {
        if (!completer.isCompleted) completer.complete(null);
      }
    }).toJS;

    rec.onerror = ((web.Event _) {
      if (!completer.isCompleted) completer.complete(null);
    }).toJS;

    rec.onend = ((web.Event _) {
      if (!completer.isCompleted) completer.complete(null);
    }).toJS;

    try {
      rec.start();
    } catch (_) {
      if (!completer.isCompleted) completer.complete(null);
    }
    return completer.future;
  }

  void stop() {
    try {
      _recognition?.stop();
    } catch (_) {
      // ignorieren
    }
    _recognition = null;
  }
}
