import 'dart:convert';

import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:http/http.dart' as http;

/// Erzeugt aus einem Text-Prompt ein Bild ueber den Cloudflare-Worker
/// (Gemini-Bildmodell). Der Gemini-Key bleibt serverseitig - er landet nie
/// im Web-Bundle. Antwort ist eine data-URL (base64), die direkt in einer
/// Sprechblase angezeigt werden kann (Image.memory).
class ImageGenService {
  ImageGenService({required this.proxyUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String proxyUrl;
  final http.Client _client;

  Future<Result<String>> generate(String prompt) async {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      return const FailureResult(UnexpectedFailure('Kein Bild-Text.'));
    }

    http.Response res;
    try {
      res = await _client
          .post(
            Uri.parse(proxyUrl),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'bildModus': true, 'prompt': trimmed}),
          )
          // Bild-Erzeugung dauert laenger als Text.
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      return FailureResult(NetworkFailure('Netzwerkfehler: $e'));
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final err = jsonDecode(res.body) as Map<String, dynamic>;
        return FailureResult(
          NetworkFailure('Bild-Fehler: ${err['error'] ?? res.statusCode}'),
        );
      } catch (_) {
        return FailureResult(
          NetworkFailure('Bild-Fehler: HTTP ${res.statusCode}'),
        );
      }
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return const FailureResult(
        UnexpectedFailure('Antwort konnte nicht gelesen werden.'),
      );
    }
    final image = (data['image'] as String?)?.trim();
    if (image == null || image.isEmpty) {
      return const FailureResult(
        NetworkFailure('Es wurde kein Bild geliefert.'),
      );
    }
    return Success(image);
  }
}
