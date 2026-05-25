import 'package:equatable/equatable.dart';

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
    bool clearBreed = false,
    bool clearBirthday = false,
    bool clearWeight = false,
    bool clearPhoto = false,
    bool clearNotes = false,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: clearBreed ? null : (breed ?? this.breed),
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      weightKg: clearWeight ? null : (weightKg ?? this.weightKg),
      photoBase64: clearPhoto ? null : (photoBase64 ?? this.photoBase64),
      notes: clearNotes ? null : (notes ?? this.notes),
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
      ];
}
