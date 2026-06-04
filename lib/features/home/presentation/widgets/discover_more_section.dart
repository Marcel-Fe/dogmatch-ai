import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Empfehlungs-Sektion "Entdecke mehr": horizontale Karten zu den wichtigsten
/// Bereichen der App. Leichtgewichtig (nur Icons + Navigation), damit der
/// Start nicht schwerer wird.
class DiscoverMoreSection extends StatelessWidget {
  const DiscoverMoreSection({super.key});

  static const _items = <_DiscoverItem>[
    _DiscoverItem(
      icon: Icons.lightbulb_rounded,
      title: 'Tipps fuer den Alltag',
      subtitle: 'Kleine Helfer, grosse Wirkung',
      color: Color(0xFFFFB300),
      route: AppRoutes.tips,
    ),
    _DiscoverItem(
      icon: Icons.cookie_rounded,
      title: 'Leckerli-Rezepte',
      subtitle: 'Hundesicher selbst gemacht',
      color: Color(0xFFFF8A65),
      route: AppRoutes.treats,
    ),
    _DiscoverItem(
      icon: Icons.menu_book_rounded,
      title: 'Wissensbibliothek',
      subtitle: 'Verstehen, was deinen Hund bewegt',
      color: Color(0xFF7C6BF0),
      route: AppRoutes.knowledge,
    ),
    _DiscoverItem(
      icon: Icons.school_rounded,
      title: 'Trainings-Plaene',
      subtitle: 'Schritt fuer Schritt zum Ziel',
      color: Color(0xFF4FC3F7),
      route: AppRoutes.training,
    ),
    _DiscoverItem(
      icon: Icons.near_me_rounded,
      title: 'In deiner Naehe',
      subtitle: 'Tieraerzte, Parks & mehr',
      color: Color(0xFF4DB6AC),
      route: AppRoutes.nearby,
    ),
    _DiscoverItem(
      icon: Icons.merge_type_rounded,
      title: 'Mischling-Rechner',
      subtitle: 'Wesen von Mix-Hunden',
      color: Color(0xFFBA68C8),
      route: AppRoutes.mixBreed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text('Entdecke mehr', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Empfehlungen rund um deinen Hund',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _items.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, i) =>
                _DiscoverCard(item: _items[i], theme: theme),
          ),
        ),
      ],
    );
  }
}

class _DiscoverItem {
  const _DiscoverItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard({required this.item, required this.theme});

  final _DiscoverItem item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return SizedBox(
      width: 170,
      child: Material(
        color: isDark ? const Color(0xFF1E1B27) : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(item.route),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: item.color.withValues(alpha: 0.25),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
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
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
