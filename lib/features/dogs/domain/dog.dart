import 'package:equatable/equatable.dart';

/// Versicherungs-Daten des eigenen Hundes (vom Nutzer hinterlegt).
class DogInsurance extends Equatable {
  const DogInsurance({
    this.provider,
    this.policyNumber,
    this.tariff,
    this.monthlyEur,
  });

  final String? provider; // Anbieter, z. B. "Agila"
  final String? policyNumber; // Versicherungsnummer
  final String? tariff; // Tarif, z. B. "OP-Schutz"
  final double? monthlyEur; // Monatsbeitrag

  bool get isEmpty =>
      (provider == null || provider!.trim().isEmpty) &&
      (policyNumber == null || policyNumber!.trim().isEmpty) &&
      (tariff == null || tariff!.trim().isEmpty) &&
      monthlyEur == null;

  factory DogInsurance.fromJson(Map<String, dynamic> json) => DogInsurance(
        provider: json['provider'] as String?,
        policyNumber: json['policyNumber'] as String?,
        tariff: json['tariff'] as String?,
        monthlyEur: (json['monthlyEur'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'policyNumber': policyNumber,
        'tariff': tariff,
        'monthlyEur': monthlyEur,
      };

  @override
  List<Object?> get props => [provider, policyNumber, tariff, monthlyEur];
}

/// Ein einzelner Kosten-Eintrag im Hund-Ordner (z. B. Futter, Tierarzt).
class CostEntry extends Equatable {
  const CostEntry({
    required this.id,
    required this.label,
    required this.amountEur,
    required this.date,
  });

  final String id;
  final String label;
  final double amountEur;
  final DateTime date;

  factory CostEntry.fromJson(Map<String, dynamic> json) => CostEntry(
        id: json['id'] as String,
        label: json['label'] as String,
        amountEur: (json['amountEur'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'amountEur': amountEur,
        'date': date.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, label, amountEur, date];
}

/// Ein Hund des Nutzers. Lokal gespeichert; in Phase 5 (Firebase) wird
/// [photoBase64] in Storage ausgelagert.
class Dog extends Equatable {
  const Dog({
    required this.id,
    required this.name,
    this.breed,
    this.birthday,
    this.weightKg,
    this.photoBase64,
    this.notes,
    this.insurance,
    this.costs = const [],
  });

  /// Stabile UUID-aehnliche Id; wird beim Anlegen vergeben.
  final String id;
  final String name;
  final String? breed;
  final DateTime? birthday;
  final double? weightKg;

  /// Foto als Base64-String (data:image/...;base64,...). Bewusst inline
  /// gespeichert, damit Phase A komplett offline funktioniert. Bei >2MB
  /// lehnt das Repository das Bild ab.
  final String? photoBase64;

  final String? notes;

  /// Vom Nutzer hinterlegte Versicherung (#2).
  final DogInsurance? insurance;

  /// Kosten-Eintraege des Hundes (#13).
  final List<CostEntry> costs;

  /// Summe aller hinterlegten Kosten in EUR.
  double get totalCostsEur =>
      costs.fold(0.0, (sum, c) => sum + c.amountEur);

  /// Alter in Jahren, oder null wenn kein Geburtsdatum hinterlegt ist.
  int? get ageYears {
    if (birthday == null) return null;
    final now = DateTime.now();
    var age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age -= 1;
    }
    return age < 0 ? 0 : age;
  }

  Dog copyWith({
    String? id,
    String? name,
    String? breed,
    DateTime? birthday,
    double? weightKg,
    String? photoBase64,
    String? notes,
    DogInsurance? insurance,
    List<CostEntry>? costs,
    bool clearBreed = false,
    bool clearBirthday = false,
    bool clearWeight = false,
    bool clearPhoto = false,
    bool clearNotes = false,
    bool clearInsurance = false,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: clearBreed ? null : (breed ?? this.breed),
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      weightKg: clearWeight ? null : (weightKg ?? this.weightKg),
      photoBase64: clearPhoto ? null : (photoBase64 ?? this.photoBase64),
      notes: clearNotes ? null : (notes ?? this.notes),
      insurance: clearInsurance ? null : (insurance ?? this.insurance),
      costs: costs ?? this.costs,
    );
  }

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.tryParse(json['birthday'] as String),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      photoBase64: json['photoBase64'] as String?,
      notes: json['notes'] as String?,
      insurance: json['insurance'] is Map
          ? DogInsurance.fromJson(
              (json['insurance'] as Map).cast<String, dynamic>())
          : null,
      costs: (json['costs'] as List?)
              ?.map((e) =>
                  CostEntry.fromJson((e as Map).cast<String, dynamic>()))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'birthday': birthday?.toIso8601String(),
      'weightKg': weightKg,
      'photoBase64': photoBase64,
      'notes': notes,
      'insurance': insurance?.toJson(),
      'costs': costs.map((c) => c.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        breed,
        birthday,
        weightKg,
        photoBase64,
        notes,
        insurance,
        costs,
      ];
}
