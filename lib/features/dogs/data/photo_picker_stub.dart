/// Stub fuer nicht-Web-Plattformen. Wird in Phase 5 (Mobile/Android) durch
/// eine native image_picker-Implementierung ersetzt.
Future<String?> pickImageAsDataUrl({
  int maxBytes = 2 * 1024 * 1024,
  int maxEdge = 1024,
}) async {
  throw UnsupportedError(
    'Foto-Auswahl ist auf dieser Plattform noch nicht unterstuetzt.',
  );
}

Future<DocumentPickResult?> pickDocument({int maxBytes = 2 * 1024 * 1024}) {
  throw UnsupportedError(
    'Dokument-Auswahl ist auf dieser Plattform noch nicht unterstuetzt.',
  );
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

/// Oeffnet eine data-URL/URL in einem neuen Tab (Web). Auf Mobile derzeit
/// ungenutzt - in Phase 5 wird hier `url_launcher` eingehaengt.
void openDataUrl(String url) {
  throw UnsupportedError('Oeffnen ist auf dieser Plattform nicht unterstuetzt.');
}
