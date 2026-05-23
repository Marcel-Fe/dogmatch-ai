/// Laender, fuer die DogMatch AI rechtliche und praktische Hunde-Infos
/// kennt. Wird sowohl im Nutzer-Profil als auch in den
/// rassen-spezifischen Laender-Hinweisen verwendet.
enum Country {
  germany('Deutschland', 'DE'),
  switzerland('Schweiz', 'CH'),
  austria('Oesterreich', 'AT');

  const Country(this.label, this.code);

  final String label;
  final String code;

  static Country fromCode(String? code) {
    for (final c in Country.values) {
      if (c.code == code) return c;
    }
    return Country.germany;
  }
}
