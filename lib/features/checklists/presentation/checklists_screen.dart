import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/checklists/data/checklist_catalog.dart';
import 'package:dogmatch_ai/features/checklists/data/checklist_progress_repository.dart';
import 'package:dogmatch_ai/features/checklists/domain/checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChecklistsScreen extends ConsumerWidget {
  const ChecklistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(checklistProgressProvider).value ?? const {};
    return Scaffold(
      appBar: AppBar(title: const Text('Checklisten')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Wichtige Listen zum Abhaken - der Fortschritt wird automatisch gespeichert.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final c in ChecklistCatalog.all)
            _ListTile(
              checklist: c,
              done: progress[c.id]?.length ?? 0,
              onTap: () =>
                  context.push('${AppRoutes.checklistDetail}/${c.id}'),
            ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.checklist,
    required this.done,
    required this.onTap,
  });

  final Checklist checklist;
  final int done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = checklist.items.length;
    final pct = total == 0 ? 0.0 : done / total;
    final isDone = done == total && total > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: Container(
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
                      Text(checklist.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 2),
                      Text(checklist.description,
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusPill),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: Colors.white.withValues(
                                    alpha: 0.45),
                                valueColor: AlwaysStoppedAnimation(
                                  isDone ? Colors.green : checklist.color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text('$done/$total',
                              style: theme.textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
