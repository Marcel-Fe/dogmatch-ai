// Entry-Point fuer die Sprach-EINGABE. Conditional Import waehlt
// die Web- oder Stub-Implementierung.
export 'stt_service_stub.dart'
    if (dart.library.js_interop) 'stt_service_web.dart';
