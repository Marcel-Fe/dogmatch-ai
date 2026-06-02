import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
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
      icon: Icons.near_me_rounded,
      label: 'In der Naehe',
      color: Color(0xFF4DB6AC),
      route: AppRoutes.nearby,
    ),
    _QuickActionItem(
      icon: Icons.pets_rounded,
      label: 'Alle Rassen',
      color: Color(0xFFBA68C8),
      route: AppRoutes.breedList,
    ),
    _QuickActionItem(
      icon: Icons.cookie_rounded,
      label: 'Leckerli',
      color: Color(0xFFFFB74D),
      route: AppRoutes.treats,
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
      childAspectRatio: 0.92,
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
    final isDark = theme.brightness == Brightness.dark;
    // Ruhige, helle Karte - die Farbe lebt nur im kleinen Akzent-Badge,
    // nicht mehr als grosser Farbkasten. Das wirkt modern und aufgeraeumt.
    final cardColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          onTap: () => context.push(item.route),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Abgerundetes Quadrat (squircle) statt Kreis - kraeftige
                // Farbe als sanfter Verlauf, mit weichem farbigem Schimmer.
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        item.color,
                        Color.lerp(item.color, Colors.black, 0.22)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withValues(alpha: 0.40),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
