import 'package:equatable/equatable.dart';

/// Eine vom Nutzer gemerkte Lieblings-Rasse.
class Favorite extends Equatable {
  const Favorite({required this.breedId, required this.savedAt});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      breedId: json['breedId'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }

  final String breedId;
  final DateTime savedAt;

  Map<String, dynamic> toJson() {
    return {
      'breedId': breedId,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [breedId];
}
