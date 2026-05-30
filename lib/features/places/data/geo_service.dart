// Standort-Dienst + externe Links. Conditional Import waehlt Web- oder
// Stub-Implementierung.
export 'geo_service_stub.dart'
    if (dart.library.js_interop) 'geo_service_web.dart';
