import 'package:equatable/equatable.dart';

/// Versicherungs-Hinweise pro Rasse - Richtwerte, KEINE Anbieter-Empfehlung.
/// Beträge in EUR pro Monat. Spannen weil tatsächliche Tarife stark
/// von Wohnort, Alter und Vorerkrankungen abhaengen.
class BreedInsurance extends Equatable {
  const BreedInsurance({
    this.liabilityMonthlyMin = 5,
    this.liabilityMonthlyMax = 12,
    this.healthMonthlyMin = 25,
    this.healthMonthlyMax = 60,
    this.opMonthlyMin = 10,
    this.opMonthlyMax = 25,
    this.listenhundSurcharge = false,
    this.notes,
  });

  /// Haftpflicht-Versicherung (in DE in vielen Bundeslaendern Pflicht).
  final int liabilityMonthlyMin;
  final int liabilityMonthlyMax;

  /// Kranken-Vollversicherung (deckt Behandlungen inkl. chronische Therapie).
  final int healthMonthlyMin;
  final int healthMonthlyMax;

  /// OP-Schutz allein (deckt nur Operationen + Nachbehandlung, guenstiger).
  final int opMonthlyMin;
  final int opMonthlyMax;

  /// True wenn die Rasse in einigen DE-Bundeslaendern als Listenhund gilt -
  /// dann Aufschlag bei Haftpflicht (oft 2-3x normaler Preis).
  final bool listenhundSurcharge;

  /// Zusatz-Hinweis fuer den Nutzer, z. B. "OP-Schutz besonders sinnvoll
  /// wegen Huefdysplasie-Risiko".
  final String? notes;

  factory BreedInsurance.fromJson(Map<String, dynamic> json) {
    return BreedInsurance(
      liabilityMonthlyMin: (json['liabilityMonthlyMin'] as num?)?.toInt() ?? 5,
      liabilityMonthlyMax: (json['liabilityMonthlyMax'] as num?)?.toInt() ?? 12,
      healthMonthlyMin: (json['healthMonthlyMin'] as num?)?.toInt() ?? 25,
      healthMonthlyMax: (json['healthMonthlyMax'] as num?)?.toInt() ?? 60,
      opMonthlyMin: (json['opMonthlyMin'] as num?)?.toInt() ?? 10,
      opMonthlyMax: (json['opMonthlyMax'] as num?)?.toInt() ?? 25,
      listenhundSurcharge: json['listenhundSurcharge'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'liabilityMonthlyMin': liabilityMonthlyMin,
        'liabilityMonthlyMax': liabilityMonthlyMax,
        'healthMonthlyMin': healthMonthlyMin,
        'healthMonthlyMax': healthMonthlyMax,
        'opMonthlyMin': opMonthlyMin,
        'opMonthlyMax': opMonthlyMax,
        'listenhundSurcharge': listenhundSurcharge,
        'notes': notes,
      };

  @override
  List<Object?> get props => [
        liabilityMonthlyMin,
        liabilityMonthlyMax,
        healthMonthlyMin,
        healthMonthlyMax,
        opMonthlyMin,
        opMonthlyMax,
        listenhundSurcharge,
        notes,
      ];
}
