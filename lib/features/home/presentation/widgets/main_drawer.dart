import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Haupt-Navigation als Drawer ueber den Burger-Menue-Knopf.
/// Bietet allen Modulen einen geordneten Einstieg - so bleibt das
/// Dashboard fokussiert und der Drawer fungiert als App-Index.
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  static const _sections = <_DrawerSection>[
    _DrawerSection(
      title: 'Mein Hund',
      items: [
        _DrawerItem(
          icon: Icons.pets_rounded,
          label: 'Hunde verwalten',
          color: AppColors.primary,
          route: AppRoutes.manageDogs,
        ),
        _DrawerItem(
          icon: Icons.favorite_rounded,
          label: 'Favoriten',
          color: Color(0xFFEC407A),
          route: AppRoutes.favorites,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Gesundheit & Termine',
      items: [
        _DrawerItem(
          icon: Icons.event_rounded,
          label: 'Gesundheits-Kalender',
          color: Color(0xFF81C784),
          route: AppRoutes.healthCalendar,
        ),
        _DrawerItem(
          icon: Icons.folder_rounded,
          label: 'Dokumente',
          color: Color(0xFF4FC3F7),
          route: AppRoutes.documents,
        ),
        _DrawerItem(
          icon: Icons.health_and_safety_rounded,
          label: 'Symptom-Check',
          color: Color(0xFFE57373),
          route: AppRoutes.symptomCheck,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Training & Verhalten',
      items: [
        _DrawerItem(
          icon: Icons.psychology_rounded,
          label: 'Verhalten-Check',
          color: Color(0xFFFFB74D),
          route: AppRoutes.behaviorCheck,
        ),
        _DrawerItem(
          icon: Icons.school_rounded,
          label: 'Trainings-Plaene',
          color: Color(0xFF4FC3F7),
          route: AppRoutes.training,
        ),
        _DrawerItem(
          icon: Icons.smart_toy_rounded,
          label: 'KI-Berater',
          color: Color(0xFF7C6BF0),
          route: AppRoutes.assistant,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Wissen & Alltag',
      items: [
        _DrawerItem(
          icon: Icons.lightbulb_rounded,
          label: 'Tipps & Wissen',
          color: Color(0xFFFFB300),
          route: AppRoutes.tips,
        ),
        _DrawerItem(
          icon: Icons.checklist_rounded,
          label: 'Checklisten',
          color: Color(0xFF26A69A),
          route: AppRoutes.checklists,
        ),
        _DrawerItem(
          icon: Icons.luggage_rounded,
          label: 'Urlaub mit Hund',
          color: Color(0xFF7C6BF0),
          route: AppRoutes.vacation,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Anschaffung & Mehr',
      items: [
        _DrawerItem(
          icon: Icons.verified_user_rounded,
          label: 'Zuechter finden',
          color: Color(0xFFBA68C8),
          route: AppRoutes.breederFinder,
        ),
        _DrawerItem(
          icon: Icons.quiz_rounded,
          label: 'Matching-Quiz',
          color: Color(0xFFFF8A65),
          route: AppRoutes.quiz,
        ),
        _DrawerItem(
          icon: Icons.menu_book_rounded,
          label: 'Wissensbibliothek',
          color: Color(0xFF5C6BC0),
          route: AppRoutes.knowledge,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Konto',
      items: [
        _DrawerItem(
          icon: Icons.workspace_premium_rounded,
          label: 'Premium',
          color: Color(0xFFFFB300),
          route: AppRoutes.premium,
        ),
        _DrawerItem(
          icon: Icons.person_rounded,
          label: 'Profil',
          color: AppColors.primary,
          route: AppRoutes.profile,
        ),
        _DrawerItem(
          icon: Icons.settings_rounded,
          label: 'Einstellungen',
          color: Color(0xFF78909C),
          route: AppRoutes.settings,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pets_rounded,
                      color: Colors.white, size: 36),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DogMatch AI',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Dein taeglicher Hunde-Begleiter',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final section in _sections) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: Text(
                  section.title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              for (final item in section.items) _DrawerTile(item: item),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _DrawerSection {
  const _DrawerSection({required this.title, required this.items});
  final String title;
  final List<_DrawerItem> items;
}

class _DrawerItem {
  const _DrawerItem({
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

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.item});
  final _DrawerItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(item.icon, color: item.color, size: 20),
      ),
      title: Text(item.label),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () {
        Navigator.of(context).pop(); // close drawer
        // Tab-Routes per go(), Vollbild-Routes per push().
        const tabs = {
          AppRoutes.home,
          AppRoutes.quiz,
          AppRoutes.assistant,
          AppRoutes.favorites,
          AppRoutes.profile,
        };
        if (tabs.contains(item.route)) {
          context.go(item.route);
        } else {
          context.push(item.route);
        }
      },
    );
  }
}
