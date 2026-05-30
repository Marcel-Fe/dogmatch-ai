import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Standort-Position (Breiten-/Laengengrad).
class GeoPosition {
  const GeoPosition(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

/// Web-Standort ueber die Browser-Geolocation-API + Oeffnen externer Links
/// (Telefon, Website).
class GeoService {
  /// Fragt den Browser nach dem aktuellen Standort. Liefert null, wenn der
  /// Nutzer es ablehnt oder die API nicht verfuegbar ist.
  Future<GeoPosition?> getCurrentPosition() async {
    final completer = Completer<GeoPosition?>();
    try {
      web.window.navigator.geolocation.getCurrentPosition(
        (web.GeolocationPosition pos) {
          final c = pos.coords;
          if (!completer.isCompleted) {
            completer.complete(
              GeoPosition(c.latitude.toDouble(), c.longitude.toDouble()),
            );
          }
        }.toJS,
        (web.GeolocationPositionError _) {
          if (!completer.isCompleted) completer.complete(null);
        }.toJS,
      );
    } catch (_) {
      if (!completer.isCompleted) completer.complete(null);
    }
    return completer.future;
  }

  /// Oeffnet einen Telefon- oder Web-Link. tel:-Links navigieren nicht weg,
  /// http-Links oeffnen in einem neuen Tab.
  void openExternal(String url) {
    try {
      if (url.startsWith('tel:')) {
        web.window.location.href = url;
      } else {
        web.window.open(url, '_blank');
      }
    } catch (_) {
      // Browser hat das Oeffnen blockiert - kein harter Fehler.
    }
  }
}
