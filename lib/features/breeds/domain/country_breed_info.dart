import 'package:equatable/equatable.dart';

/// Rassen-spezifische Hinweise fuer ein einzelnes Land.
///
/// Alle Felder sind optional - fehlt ein Eintrag, wird die jeweilige Zeile
/// in der UI weggelassen. Sind alle Felder leer, zeigt die UI einen
/// "Noch keine Infos"-Hinweis.
class CountryBreedInfo extends Equatable {
  const CountryBreedInfo({
    this.listenhundStatus,
    this.travelNotes,
    this.climateNotes,
  });

  /// Status als Listenhund / Kampfhund. Beispiel:
  /// "Nicht als Listenhund eingestuft" oder
  /// "Listenhund in Bayern (Kategorie 1)".
  final String? listenhundStatus;

  /// Reise- und Einreise-Hinweise. Beispiel:
  /// "Bei Einreise EU-Heimtierausweis + Tollwutimpfung noetig."
  final String? travelNotes;

  /// Klima-Hinweise. Beispiel: "Hitzeempfindlich - im Sommer
  /// Spaziergaenge in die Morgen-/Abendstunden legen."
  final String? climateNotes;

  bool get isEmpty =>
      (listenhundStatus == null || listenhundStatus!.trim().isEmpty) &&
      (travelNotes == null || travelNotes!.trim().isEmpty) &&
      (climateNotes == null || climateNotes!.trim().isEmpty);

  factory CountryBreedInfo.fromJson(Map<String, dynamic> json) {
    return CountryBreedInfo(
      listenhundStatus: json['listenhundStatus'] as String?,
      travelNotes: json['travelNotes'] as String?,
      climateNotes: json['climateNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listenhundStatus': listenhundStatus,
      'travelNotes': travelNotes,
      'climateNotes': climateNotes,
    };
  }

  @override
  List<Object?> get props => [listenhundStatus, travelNotes, climateNotes];
}
