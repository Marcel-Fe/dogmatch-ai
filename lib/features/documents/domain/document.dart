import 'package:equatable/equatable.dart';

/// Ein digitales Dokument des Nutzers (PDF, Foto, Scan).
/// Inhalt wird als data-URL (Base64) gespeichert - Phase B (Firebase
/// Storage) verschiebt das in Cloud-Storage und ersetzt [dataUrl] durch
/// eine externe URL.
class DogDocument extends Equatable {
  const DogDocument({
    required this.id,
    required this.dogId,
    required this.name,
    required this.mimeType,
    required this.dataUrl,
    required this.sizeBytes,
    required this.addedAt,
  });

  final String id;
  final String dogId;
  final String name;
  final String mimeType;
  final String dataUrl;
  final int sizeBytes;
  final DateTime addedAt;

  bool get isPdf => mimeType == 'application/pdf';
  bool get isImage => mimeType.startsWith('image/');

  factory DogDocument.fromJson(Map<String, dynamic> json) {
    return DogDocument(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      dataUrl: json['dataUrl'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dogId': dogId,
      'name': name,
      'mimeType': mimeType,
      'dataUrl': dataUrl,
      'sizeBytes': sizeBytes,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id];
}
