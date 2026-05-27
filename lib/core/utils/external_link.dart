import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Oeffnet eine externe URL. Web-only via window.open - auf nicht-Web
/// Plattformen aktuell ein No-op, da kein url_launcher installiert ist
/// und das Hauptdeployment Web ist.
void openExternalLink(String url) {
  if (!kIsWeb) return;
  if (url.isEmpty) return;
  web.window.open(url, '_blank');
}
