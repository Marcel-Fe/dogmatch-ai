// Entry point fuer Foto- und Dokument-Auswahl. Conditional import waehlt
// die Web-Implementierung (HTML-File-Input) bzw. den Mobile-Stub.
export 'photo_picker_stub.dart'
    if (dart.library.js_interop) 'photo_picker_web.dart';
