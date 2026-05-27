// Entry-Point fuer die Sprach-Eingabe. Conditional Import waehlt
// die Web- oder Stub-Implementierung.
export 'speech_input_service_stub.dart'
    if (dart.library.js_interop) 'speech_input_service_web.dart';
