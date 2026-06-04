import 'dart:convert';

import 'package:dogmatch_ai/core/config/env.dart';
import 'package:http/http.dart' as http;

/// Ergebnis eines KI-Beleg-Scans. Alle Felder optional - die KI liefert,
/// was sie sicher erkennt.
class ScannedReceipt {
  const ScannedReceipt({this.label, this.amountEur, this.date});

  final String? label;
  final double? amountEur;
  final DateTime? date;

  bool get hasAnything => label != null || amountEur != null || date != null;
}

/// Liest aus einem Rechnungs-/Beleg-Foto den Betrag, das Datum und einen
/// kurzen Zweck aus - ueber denselben Gemini-Vision-Proxy wie der KI-Berater.
/// Der API-Key bleibt serverseitig im Cloudflare-Worker.
class ReceiptScanService {
  ReceiptScanService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  /// True, wenn ein Vision-faehiger Proxy konfiguriert ist. Nur dann darf
  /// das UI den Scan-Button zeigen.
  static bool get isAvailable => Env.hasGeminiProxy;

  static const String _system =
      'Du bist ein praeziser Beleg-Scanner fuer eine Hunde-App. Du bekommst '
      'das Foto einer Rechnung oder eines Kassenbons (oft Tierarzt, Futter, '
      'Zubehoer, Hundeschule). Extrahiere den GESAMT-Endbetrag in Euro, das '
      'Belegdatum und einen kurzen Zweck (1-3 Woerter, deutsch). Antworte '
      'AUSSCHLIESSLICH mit einem JSON-Objekt in genau dieser Form, ohne '
      'Erklaerung, ohne Markdown: '
      '{"label":"Tierarzt","amount":89.90,"date":"2026-06-04"}. '
      'amount als Zahl mit Punkt. Fehlt ein Wert, lass das Feld weg.';

  /// Schickt das Bild (Data-URL) an den Proxy und parst die Antwort.
  /// Wirft [Exception] bei Netzwerk-/Serverfehler.
  Future<ScannedReceipt> scan(String imageDataUrl) async {
    final proxyUrl = Env.geminiProxyUrl;
    if (proxyUrl.isEmpty) {
      throw Exception('Kein KI-Proxy konfiguriert.');
    }

    final body = jsonEncode({
      'model': 'gemini-2.5-flash',
      'systemInstruction': _system,
      'messages': [
        {'role': 'user', 'text': 'Lies diesen Beleg aus.'},
      ],
      'image': imageDataUrl,
    });

    final res = await _client
        .post(
          Uri.parse(proxyUrl),
          headers: const {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 45));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('KI-Fehler: HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final text = (data['text'] as String?)?.trim() ?? '';
    if (text.isEmpty) {
      throw Exception('Keine Antwort von der KI.');
    }
    return _parse(text);
  }

  /// Robustes Parsen: schneidet evtl. Markdown-Fences weg und liest das erste
  /// JSON-Objekt aus dem Text.
  ScannedReceipt _parse(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw Exception('Beleg konnte nicht gelesen werden.');
    }
    final jsonStr = text.substring(start, end + 1);
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;

    final label = (map['label'] as String?)?.trim();
    final amount = switch (map['amount']) {
      final num n => n.toDouble(),
      final String s => double.tryParse(s.replaceAll(',', '.')),
      _ => null,
    };
    DateTime? date;
    final rawDate = map['date'];
    if (rawDate is String && rawDate.trim().isNotEmpty) {
      date = DateTime.tryParse(rawDate.trim());
    }

    return ScannedReceipt(
      label: (label == null || label.isEmpty) ? null : label,
      amountEur: amount,
      date: date,
    );
  }
}
