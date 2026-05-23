import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';

/// Wissensbereich. Artikel zu Pflege, Ernaehrung, Training und Gesundheit.
class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wissensbereich')),
      body: const FeaturePlaceholder(
        icon: Icons.menu_book_outlined,
        title: 'Hundewissen',
        description:
            'Ratgeber zu Pflege, Ernaehrung, Training und Gesundheit '
            'folgen in einer spaeteren Phase.',
      ),
    );
  }
}
