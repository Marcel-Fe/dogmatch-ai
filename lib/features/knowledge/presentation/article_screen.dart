import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/knowledge/data/articles_data.dart';
import 'package:dogmatch_ai/features/knowledge/domain/article.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final article = ArticlesData.all.firstWhere(
      (a) => a.id == articleId,
      orElse: () => const Article(
        id: 'unknown',
        title: 'Artikel nicht gefunden',
        category: 'Unbekannt',
        summary: '',
        content: 'Dieser Artikel existiert nicht (mehr).',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(article.category)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              '${article.category} · ${article.readMinutes} Min',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(article.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            article.summary,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const Divider(height: AppSpacing.xl * 2),
          for (final block in _splitContent(article.content)) ...[
            _renderBlock(theme, block),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  List<String> _splitContent(String content) {
    return content
        .split(RegExp(r'\n\s*\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Widget _renderBlock(ThemeData theme, String block) {
    // Allcaps-Zeile ohne Punkt am Anfang -> Ueberschrift
    final firstLine = block.split('\n').first;
    final isHeading = firstLine == firstLine.toUpperCase() &&
        firstLine.length < 80 &&
        !firstLine.endsWith('.');
    if (isHeading && block.split('\n').length == 1) {
      return Text(
        block,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      );
    }
    // Aufzaehlung
    if (block.split('\n').every((l) => l.startsWith('- ') ||
        RegExp(r'^\d+\.\s').hasMatch(l))) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in block.split('\n'))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line, style: theme.textTheme.bodyMedium),
            ),
        ],
      );
    }
    // Normaler Absatz
    return Text(block, style: theme.textTheme.bodyMedium);
  }
}
