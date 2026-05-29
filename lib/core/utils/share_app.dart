// Teilt den App-Link. Web nutzt navigator.share, mit Fallback auf
// Zwischenablage. Auf nicht-Web-Plattformen aktuell No-op.
export 'share_app_stub.dart'
    if (dart.library.js_interop) 'share_app_web.dart';
