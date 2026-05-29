import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

@JS()
external JSObject get navigator;

/// Teilt den App-Link via Web Share API. Wenn der Browser das nicht
/// unterstuetzt: Fallback zur Zwischenablage. Liefert true wenn etwas
/// (geteilt oder kopiert) passiert ist.
Future<bool> shareApp({
  String title = 'DogMatch AI',
  String text = 'Schau dir DogMatch AI an!',
  String url = 'https://marcel-fe.github.io/dogmatch-ai/',
}) async {
  try {
    final hasShare = navigator.hasProperty('share'.toJS).toDart;
    if (hasShare) {
      final data = JSObject();
      data['title'] = title.toJS;
      data['text'] = text.toJS;
      data['url'] = url.toJS;
      final promise = navigator.callMethod('share'.toJS, data) as JSPromise;
      await promise.toDart;
      return true;
    }
  } catch (_) {
    // AbortError vom User oder ungueltige Daten - faellt durch zum Copy.
  }
  return copyToClipboard(url);
}

Future<bool> copyToClipboard(String text) async {
  try {
    final clipboard = web.window.navigator.clipboard;
    await clipboard.writeText(text).toDart;
    return true;
  } catch (_) {
    return false;
  }
}
