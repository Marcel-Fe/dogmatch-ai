import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web-Implementierung: oeffnet einen versteckten HTML-File-Input,
/// liest die ausgewaehlte Datei via FileReader als data-URL und liefert
/// den Base64-Inhalt zurueck. Kein Plugin, kein Windows-Devmode noetig.
///
/// Wichtig: Das Bild wird IMMER ueber [_downscaleDataUrl] verkleinert
/// (max. Kante [maxEdge] px, JPEG). Das behebt den Android-Bug, bei dem
/// grosse Handy-Fotos nicht im Profil gespeichert werden konnten, und
/// haelt die Base64-Groesse fuer lokale Speicherung + KI-Analyse klein.
Future<String?> pickImageAsDataUrl({
  int maxBytes = 2 * 1024 * 1024,
  int maxEdge = 1024,
}) async {
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
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final result = reader.result;
      final rawDataUrl = result?.dartify() as String?;
      if (rawDataUrl == null) {
        completer.complete(null);
        return;
      }
      // Grosse Fotos automatisch herunterskalieren statt abzulehnen.
      _downscaleDataUrl(rawDataUrl, maxEdge).then((scaled) {
        completer.complete(scaled ?? rawDataUrl);
      }).catchError((_) {
        // Falls das Skalieren scheitert (z.B. exotisches Format): Original
        // nur dann nehmen, wenn es das Limit nicht sprengt.
        completer.complete(file.size <= maxBytes ? rawDataUrl : null);
        return null;
      });
    }).toJS;
    reader.onerror = ((web.Event _) {
      completer.completeError('Datei konnte nicht gelesen werden.');
    }).toJS;
    reader.readAsDataURL(file);
  }).toJS;

  input.click();
  return completer.future;
}

/// Laedt eine data-URL in ein Image, zeichnet es proportional verkleinert
/// (laengste Kante = [maxEdge]) auf ein Canvas und gibt eine JPEG-data-URL
/// zurueck. Liefert null, wenn das Bild nicht geladen werden kann.
Future<String?> _downscaleDataUrl(String dataUrl, int maxEdge) {
  final completer = Completer<String?>();
  final img = web.HTMLImageElement();

  img.onload = ((web.Event _) {
    final w = img.naturalWidth;
    final h = img.naturalHeight;
    if (w == 0 || h == 0) {
      completer.complete(null);
      return;
    }
    // Schon klein genug -> Original behalten (kein Qualitaetsverlust).
    if (w <= maxEdge && h <= maxEdge) {
      completer.complete(dataUrl);
      return;
    }
    final scale = w > h ? maxEdge / w : maxEdge / h;
    final tw = (w * scale).round();
    final th = (h * scale).round();

    final canvas = (web.document.createElement('canvas') as web.HTMLCanvasElement)
      ..width = tw
      ..height = th;
    final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D?;
    if (ctx == null) {
      completer.complete(null);
      return;
    }
    ctx.drawImage(img, 0, 0, tw.toDouble(), th.toDouble());
    completer.complete(canvas.toDataURL('image/jpeg', 0.82.toJS));
  }).toJS;

  img.onerror = ((web.Event _) {
    completer.complete(null);
  }).toJS;

  img.src = dataUrl;
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
