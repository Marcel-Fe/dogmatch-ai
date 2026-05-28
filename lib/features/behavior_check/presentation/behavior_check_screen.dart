import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/behavior_check/data/behavior_catalog.dart';
import 'package:dogmatch_ai/features/behavior_check/data/behavior_engine.dart';
import 'package:dogmatch_ai/features/behavior_check/domain/behavior.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Verhaltens-Check. Nutzer waehlt auffaellige Verhaltensweisen, App
/// liefert Einschaetzung + Trainings-Empfehlung mit Verlinkung auf
/// vorhandene Trainings-Plaene.
class BehaviorCheckScreen extends StatefulWidget {
  const BehaviorCheckScreen({super.key});

  @override
  State<BehaviorCheckScreen> createState() => _BehaviorCheckScreenState();
}

class _BehaviorCheckScreenState extends State<BehaviorCheckScreen> {
  final Set<String> _selected = {};
  bool _analyzed = false;

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
      _analyzed = false;
    });
  }

  void _reset() {
    setState(() {
      _selected.clear();
      _analyzed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCategory = <BehaviorCategory, List<Behavior>>{};
    for (final b in BehaviorCatalog.all) {
      byCategory.putIfAbsent(b.category, () => []).add(b);
    }
    final results =
        _analyzed ? BehaviorEngine.analyze(_selected) : <BehaviorAssessment>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verhalten-Check'),
        actions: [
          if (_selected.isNotEmpty)
            IconButton(
              tooltip: 'Zuruecksetzen',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _reset,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Disclaimer(theme: theme),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Was zeigt dein Hund?',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tippe alle Verhaltensweisen an, die du beobachtest. '
            'Mehrfach-Auswahl verbessert die Einschaetzung.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final cat in byCategory.keys)
            _CategoryBlock(
              category: cat,
              behaviors: byCategory[cat]!,
              selected: _selected,
              onToggle: _toggle,
              theme: theme,
            ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _selected.isEmpty
                ? null
                : () => setState(() => _analyzed = true),
            icon: const Icon(Icons.psychology_alt_rounded),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                _selected.isEmpty
                    ? 'Bitte mindestens 1 Punkt waehlen'
                    : 'Auswertung starten (${_selected.length} Punkt${_selected.length == 1 ? '' : 'e'})',
              ),
            ),
          ),
          if (_analyzed) ...[
            const SizedBox(height: AppSpacing.xl),
            Text('Einschaetzung', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final a in results)
              _AssessmentTile(assessment: a, theme: theme),
          ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Dieser Check ersetzt keinen Hundetrainer oder Tierarzt. '
              'Er hilft dir Verhalten einzuordnen + den richtigen ersten '
              'Schritt zu finden.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.behaviors,
    required this.selected,
    required this.onToggle,
    required this.theme,
  });

  final BehaviorCategory category;
  final List<Behavior> behaviors;
  final Set<String> selected;
  final void Function(String) onToggle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(category.label, style: theme.textTheme.titleSmall),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: behaviors.map((b) {
              final isSel = selected.contains(b.id);
              return FilterChip(
                label: Text(b.label),
                selected: isSel,
                onSelected: (_) => onToggle(b.id),
                selectedColor:
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _AssessmentTile extends StatelessWidget {
  const _AssessmentTile({required this.assessment, required this.theme});

  final BehaviorAssessment assessment;
  final ThemeData theme;

  Color get _color {
    switch (assessment.priority) {
      case BehaviorPriority.vet:
        return Colors.red;
      case BehaviorPriority.professional:
        return Colors.deepOrange;
      case BehaviorPriority.focused:
        return Colors.amber.shade800;
      case BehaviorPriority.routine:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (assessment.priority) {
      case BehaviorPriority.vet:
        return Icons.local_hospital_rounded;
      case BehaviorPriority.professional:
        return Icons.support_agent_rounded;
      case BehaviorPriority.focused:
        return Icons.school_rounded;
      case BehaviorPriority.routine:
        return Icons.self_improvement_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: _color.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, color: _color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    assessment.title,
                    style: theme.textTheme.titleMedium?.copyWith(color: _color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                assessment.priority.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(assessment.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: _color,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      assessment.recommendation,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            if (assessment.trainingPlanId != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonalIcon(
                onPressed: () => context.push(
                  '${AppRoutes.training}/${assessment.trainingPlanId}',
                ),
                icon: const Icon(Icons.school_rounded, size: 18),
                label: const Text('Zum passenden Trainingsplan'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
