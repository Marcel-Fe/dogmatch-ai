import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 3x2-Grid mit den wichtigsten Direkt-Aktionen der Familien-App.
/// Liegt direkt unter dem Hund-Bereich - ein Tap, ein Ziel.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const _items = <_QuickActionItem>[
    _QuickActionItem(
      icon: Icons.health_and_safety_rounded,
      label: 'Symptom-Check',
      color: Color(0xFFE57373),
      route: AppRoutes.symptomCheck,
    ),
    _QuickActionItem(
      icon: Icons.psychology_rounded,
      label: 'Verhalten',
      color: Color(0xFFFFB74D),
      route: AppRoutes.behaviorCheck,
    ),
    _QuickActionItem(
      icon: Icons.smart_toy_rounded,
      label: 'KI-Berater',
      color: Color(0xFF7C6BF0),
      route: AppRoutes.assistant,
    ),
    _QuickActionItem(
      icon: Icons.school_rounded,
      label: 'Training',
      color: Color(0xFF4FC3F7),
      route: AppRoutes.training,
    ),
    _QuickActionItem(
      icon: Icons.event_rounded,
      label: 'Termine',
      color: Color(0xFF81C784),
      route: AppRoutes.healthCalendar,
    ),
    _QuickActionItem(
      icon: Icons.verified_user_rounded,
      label: 'Zuechter',
      color: Color(0xFFBA68C8),
      route: AppRoutes.breederFinder,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.0,
      children: [
        for (final it in _items) _Tile(item: it, theme: theme),
      ],
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String route;
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item, required this.theme});

  final _QuickActionItem item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () => context.push(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
