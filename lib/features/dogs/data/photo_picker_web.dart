import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web-Implementierung: oeffnet einen versteckten HTML-File-Input,
/// liest die ausgewaehlte Datei via FileReader als data-URL und liefert
/// den Base64-Inhalt zurueck. Kein Plugin, kein Windows-Devmode noetig.
Future<String?> pickImageAsDataUrl({int maxBytes = 2 * 1024 * 1024}) async {
  final input = (web.document.createElement('input') as web.HTMLInputElement)
    ..type = 'file'
    ..accept = 'image/*';
  final completer = Completer<String?>();

  input.onchange = ((web.Event _) {
    final files = input.files;
    if (files == null || files.length == 0) {
      completer.complete(null);
      return;
    }
    final file = files.item(0)!;
    if (file.size > maxBytes) {
      completer.completeError(
        'Bild ist zu gross (max ${maxBytes ~/ 1024} KB).',
      );
      return;
    }
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final result = reader.result;
      if (result == null) {
        completer.complete(null);
      } else {
        completer.complete(result.dartify() as String?);
      }
    }).toJS;
    reader.onerror = ((web.Event _) {
      completer.completeError('Datei konnte nicht gelesen werden.');
    }).toJS;
    reader.readAsDataURL(file);
  }).toJS;

  input.click();
  return completer.future;
}

class DocumentPickResult {
  const DocumentPickResult({
    required this.name,
    required this.mimeType,
    required this.dataUrl,
    required this.sizeBytes,
  });

  final String name;
  final String mimeType;
  final String dataUrl;
  final int sizeBytes;
}

/// Oeffnet eine data-URL/URL in einem neuen Tab.
void openDataUrl(String url) {
  web.window.open(url, '_blank');
}

Future<DocumentPickResult?> pickDocument({
  int maxBytes = 2 * 1024 * 1024,
}) async {
  final input = (web.document.createElement('input') as web.HTMLInputElement)
    ..type = 'file'
    ..accept = 'application/pdf,image/*';
  final completer = Completer<DocumentPickResult?>();

  input.onchange = ((web.Event _) {
    final files = input.files;
    if (files == null || files.length == 0) {
      completer.complete(null);
      return;
    }
    final file = files.item(0)!;
    if (file.size > maxBytes) {
      completer.completeError(
        'Datei ist zu gross (max ${maxBytes ~/ 1024} KB).',
      );
      return;
    }
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final result = reader.result;
      final dataUrl = result?.dartify() as String?;
      if (dataUrl == null) {
        completer.complete(null);
        return;
      }
      completer.complete(
        DocumentPickResult(
          name: file.name,
          mimeType: file.type.isEmpty ? 'application/octet-stream' : file.type,
          dataUrl: dataUrl,
          sizeBytes: file.size,
        ),
      );
    }).toJS;
    reader.onerror = ((web.Event _) {
      completer.completeError('Datei konnte nicht gelesen werden.');
    }).toJS;
    reader.readAsDataURL(file);
  }).toJS;

  input.click();
  return completer.future;
}
