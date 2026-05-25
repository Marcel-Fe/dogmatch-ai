// Entry-Point fuer die Sprachausgabe. Conditional Import waehlt
// die Web- oder Stub-Implementierung.
export 'tts_service_stub.dart'
    if (dart.library.js_interop) 'tts_service_web.dart';
