import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';

/// Artikel-Detailansicht im Wissensbereich.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: FeaturePlaceholder(
        icon: Icons.article_outlined,
        title: 'Artikel: $articleId',
        description: 'Der Artikelinhalt wird in einer spaeteren Phase gebaut.',
      ),
    );
  }
}
