import 'package:equatable/equatable.dart';

/// Ein Artikel im Wissensbereich (Pflege, Ernaehrung, Training, Gesundheit).
class Article extends Equatable {
  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    this.imageUrl,
    this.readMinutes = 3,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final String content;
  final String? imageUrl;

  /// Geschaetzte Lesedauer in Minuten.
  final int readMinutes;

  @override
  List<Object?> get props => [id];
}
