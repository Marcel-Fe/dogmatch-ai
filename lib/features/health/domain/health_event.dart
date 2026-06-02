import 'package:equatable/equatable.dart';

/// Typ eines Gesundheits-/Pflegetermins.
enum HealthEventType {
  vaccination('Impfung'),
  deworming('Entwurmung'),
  vetVisit('Tierarzt'),
  fleaTick('Floh-/Zecken-Schutz'),
  grooming('Pflege/Fellpflege'),
  training('Training'),
  other('Sonstiges');

  const HealthEventType(this.label);

  final String label;

  static HealthEventType fromName(String? name) {
    for (final t in HealthEventType.values) {
      if (t.name == name) return t;
    }
    return HealthEventType.other;
  }
}

/// Ein einzelner Termin im Hunde-Kalender.
class HealthEvent extends Equatable {
  const HealthEvent({
    required this.id,
    required this.dogId,
    required this.type,
    required this.date,
    required this.title,
    this.notes,
    this.done = false,
    this.documentName,
    this.documentDataUrl,
  });

  final String id;

  /// Verweis auf den Hund. Bleibt erhalten, auch wenn der Hund geloescht
  /// wurde - die UI filtert dann diese "verwaisten" Termine separat.
  final String dogId;

  final HealthEventType type;
  final DateTime date;
  final String title;
  final String? notes;
  final bool done;

  /// Optionaler Datei-Anhang (#18): Name + data-URL (PDF/Bild), lokal.
  final String? documentName;
  final String? documentDataUrl;

  bool get hasDocument =>
      documentDataUrl != null && documentDataUrl!.isNotEmpty;

  bool get isUpcoming {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return !done && date.isAfter(endOfToday.subtract(const Duration(days: 1)));
  }

  HealthEvent copyWith({
    String? id,
    String? dogId,
    HealthEventType? type,
    DateTime? date,
    String? title,
    String? notes,
    bool? done,
    String? documentName,
    String? documentDataUrl,
    bool clearNotes = false,
    bool clearDocument = false,
  }) {
    return HealthEvent(
      id: id ?? this.id,
      dogId: dogId ?? this.dogId,
      type: type ?? this.type,
      date: date ?? this.date,
      title: title ?? this.title,
      notes: clearNotes ? null : (notes ?? this.notes),
      done: done ?? this.done,
      documentName:
          clearDocument ? null : (documentName ?? this.documentName),
      documentDataUrl:
          clearDocument ? null : (documentDataUrl ?? this.documentDataUrl),
    );
  }

  factory HealthEvent.fromJson(Map<String, dynamic> json) {
    return HealthEvent(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      type: HealthEventType.fromName(json['type'] as String?),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      notes: json['notes'] as String?,
      done: (json['done'] as bool?) ?? false,
      documentName: json['documentName'] as String?,
      documentDataUrl: json['documentDataUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dogId': dogId,
      'type': type.name,
      'date': date.toIso8601String(),
      'title': title,
      'notes': notes,
      'done': done,
      'documentName': documentName,
      'documentDataUrl': documentDataUrl,
    };
  }

  @override
  List<Object?> get props =>
      [id, dogId, type, date, title, notes, done, documentName, documentDataUrl];
}
