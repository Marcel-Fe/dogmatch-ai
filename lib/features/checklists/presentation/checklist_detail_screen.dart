import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/checklists/data/checklist_catalog.dart';
import 'package:dogmatch_ai/features/checklists/data/checklist_progress_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChecklistDetailScreen extends ConsumerWidget {
  const ChecklistDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final checklist = ChecklistCatalog.byId(id);
    if (checklist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkliste')),
        body: const Center(child: Text('Liste nicht gefunden.')),
      );
    }
    final progressAll =
        ref.watch(checklistProgressProvider).value ?? const {};
    final done = progressAll[checklist.id] ?? const <int>{};
    final total = checklist.items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.title),
        actions: [
          if (done.isNotEmpty)
            IconButton(
              tooltip: 'Zuruecksetzen',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => ref
                  .read(checklistProgressProvider.notifier)
                  .resetChecklist(checklist.id),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  checklist.color.withValues(alpha: 0.18),
                  checklist.color.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: checklist.color.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: checklist.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(checklist.icon,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(checklist.description,
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${done.length} von $total erledigt',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: checklist.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < total; i++)
            _ItemTile(
              text: checklist.items[i],
              done: done.contains(i),
              color: checklist.color,
              onTap: () => ref
                  .read(checklistProgressProvider.notifier)
                  .toggleItem(checklist.id, i),
            ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.text,
    required this.done,
    required this.color,
    required this.onTap,
  });

  final String text;
  final bool done;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: done
                ? Colors.green.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: done
                  ? Colors.green.withValues(alpha: 0.4)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: done ? Colors.green : color,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: done ? TextDecoration.lineThrough : null,
                    color: done
                        ? theme.colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
