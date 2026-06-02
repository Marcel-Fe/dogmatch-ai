import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/treats/data/treat_recipes_catalog.dart';
import 'package:dogmatch_ai/features/treats/domain/treat_recipe.dart';
import 'package:dogmatch_ai/features/treats/presentation/widgets/portion_calculator.dart';
import 'package:flutter/material.dart';

/// Leckerli-Rezepte zum Selbermachen. Kategorie-Filter oben, Rezepte als
/// aufklappbare Karten mit Zutaten und Schritten.
class TreatsScreen extends StatefulWidget {
  const TreatsScreen({super.key});

  @override
  State<TreatsScreen> createState() => _TreatsScreenState();
}

class _TreatsScreenState extends State<TreatsScreen> {
  TreatCategory? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipes = TreatRecipesCatalog.byCategory(_selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Leckerli-Rezepte')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.orange.shade800),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Alle Rezepte sind ohne Zucker, Salz, Schokolade, Xylit, '
                    'Zwiebel und Trauben - diese sind fuer Hunde giftig. '
                    'Leckerli ersetzen kein Futter: hoechstens 10 % der '
                    'Tagesration.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Portionsrechner (#7)
          const PortionCalculator(),
          const SizedBox(height: AppSpacing.md),

          // Kategorie-Filter
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Alle'),
                selected: _selected == null,
                onSelected: (_) => setState(() => _selected = null),
              ),
              for (final c in TreatCategory.values)
                ChoiceChip(
                  label: Text(c.label),
                  selected: _selected == c,
                  onSelected: (_) => setState(() => _selected = c),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          for (final r in recipes)
            _RecipeCard(recipe: r, theme: theme),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe, required this.theme});

  final TreatRecipe recipe;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _banner(),
            Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            shape: const Border(),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: recipe.category.color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(recipe.category.icon, color: recipe.category.color),
            ),
            title: Text(
              recipe.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(recipe.subtitle),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            children: [
              _section(theme, 'Zutaten'),
              for (final i in recipe.ingredients)
                _bullet(theme, i, Icons.circle, 6),
              const SizedBox(height: AppSpacing.sm),
              _section(theme, 'Zubereitung'),
              for (var n = 0; n < recipe.steps.length; n++)
                _numbered(theme, n + 1, recipe.steps[n]),
              const SizedBox(height: AppSpacing.sm),
              _infoRow(theme, Icons.inventory_2_outlined, recipe.storage),
              if (recipe.tip != null)
                _infoRow(theme, Icons.lightbulb_outline_rounded, recipe.tip!),
            ],
          ),
            ),
          ],
        ),
      ),
    );
  }

  /// Foto-Banner oben auf der Rezeptkarte. Faellt auf das Kategorie-Icon
  /// zurueck, falls das Bild (Wikimedia) mal nicht laedt. cacheWidth haelt
  /// den Speicher klein - wichtig fuer fluessiges Scrollen auf dem iPhone.
  Widget _banner() {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Image.network(
        recipe.imageUrl ?? recipe.category.imageUrl,
        fit: BoxFit.cover,
        cacheWidth: 600,
        gaplessPlayback: true,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : _bannerFallback(spinner: true),
        errorBuilder: (_, _, _) => _bannerFallback(),
      ),
    );
  }

  Widget _bannerFallback({bool spinner = false}) {
    final color = recipe.category.color;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: Center(
        child: spinner
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(recipe.category.icon, color: color, size: 40),
      ),
    );
  }

  Widget _section(ThemeData theme, String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(text, style: theme.textTheme.titleSmall),
        ),
      );

  Widget _bullet(ThemeData theme, String text, IconData icon, double size) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, right: AppSpacing.sm),
              child: Icon(icon, size: size, color: theme.colorScheme.primary),
            ),
            Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          ],
        ),
      );

  Widget _numbered(ThemeData theme, int n, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Text('$n',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          ],
        ),
      );

  Widget _infoRow(ThemeData theme, IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
            ),
          ],
        ),
      );
}
