/// Standort-Position (Breiten-/Laengengrad).
class GeoPosition {
  const GeoPosition(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

/// Non-Web-Stub: ohne Browser kein Standort. Liefert null.
class GeoService {
  Future<GeoPosition?> getCurrentPosition() async => null;
  void openExternal(String url) {}
}
