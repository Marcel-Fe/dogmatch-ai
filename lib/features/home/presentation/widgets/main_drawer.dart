import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/utils/share_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Haupt-Navigation als Drawer. Oberkategorien als ExpansionTile, jedes
/// mit eigenem Hunde-Icon. Footer am Ende: App teilen + Rechtliches.
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  static const _sections = <_DrawerSection>[
    _DrawerSection(
      title: 'Mein Hund',
      icon: Icons.pets_rounded,
      color: AppColors.primary,
      items: [
        _DrawerItem(
          icon: Icons.pets_rounded,
          label: 'Hunde verwalten',
          route: AppRoutes.manageDogs,
        ),
        _DrawerItem(
          icon: Icons.favorite_rounded,
          label: 'Favoriten',
          route: AppRoutes.favorites,
        ),
        _DrawerItem(
          icon: Icons.add_a_photo_rounded,
          label: 'Neuen Hund anlegen',
          route: AppRoutes.addDog,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Gesundheit & Termine',
      icon: Icons.health_and_safety_rounded,
      color: Color(0xFFE57373),
      items: [
        _DrawerItem(
          icon: Icons.event_rounded,
          label: 'Gesundheits-Kalender',
          route: AppRoutes.healthCalendar,
        ),
        _DrawerItem(
          icon: Icons.folder_rounded,
          label: 'Dokumente & Befunde',
          route: AppRoutes.documents,
        ),
        _DrawerItem(
          icon: Icons.medical_services_rounded,
          label: 'Symptom-Check',
          route: AppRoutes.symptomCheck,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Training & Verhalten',
      icon: Icons.school_rounded,
      color: Color(0xFFFFB74D),
      items: [
        _DrawerItem(
          icon: Icons.psychology_rounded,
          label: 'Verhalten-Check',
          route: AppRoutes.behaviorCheck,
        ),
        _DrawerItem(
          icon: Icons.school_rounded,
          label: 'Trainings-Plaene',
          route: AppRoutes.training,
        ),
        _DrawerItem(
          icon: Icons.smart_toy_rounded,
          label: 'KI-Hundetrainer',
          route: AppRoutes.assistant,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Wissen & Alltag',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFFFB300),
      items: [
        _DrawerItem(
          icon: Icons.lightbulb_rounded,
          label: 'Tipps-Bibliothek',
          route: AppRoutes.tips,
        ),
        _DrawerItem(
          icon: Icons.checklist_rounded,
          label: 'Checklisten',
          route: AppRoutes.checklists,
        ),
        _DrawerItem(
          icon: Icons.luggage_rounded,
          label: 'Urlaub mit Hund',
          route: AppRoutes.vacation,
        ),
        _DrawerItem(
          icon: Icons.menu_book_rounded,
          label: 'Wissensbibliothek',
          route: AppRoutes.knowledge,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Anschaffung',
      icon: Icons.verified_user_rounded,
      color: Color(0xFFBA68C8),
      items: [
        _DrawerItem(
          icon: Icons.verified_user_rounded,
          label: 'Zuechter finden',
          route: AppRoutes.breederFinder,
        ),
        _DrawerItem(
          icon: Icons.quiz_rounded,
          label: 'Rassen-Matching-Quiz',
          route: AppRoutes.quiz,
        ),
      ],
    ),
    _DrawerSection(
      title: 'Konto',
      icon: Icons.person_rounded,
      color: AppColors.primary,
      items: [
        _DrawerItem(
          icon: Icons.workspace_premium_rounded,
          label: 'Premium',
          route: AppRoutes.premium,
        ),
        _DrawerItem(
          icon: Icons.person_rounded,
          label: 'Mein Profil',
          route: AppRoutes.profile,
        ),
        _DrawerItem(
          icon: Icons.settings_rounded,
          label: 'Einstellungen',
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
            // Header mit Pfoten-Logo + Untertitel
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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(Icons.pets_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
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
                  ),
                ],
              ),
            ),
            // Sections als ExpansionTile
            for (final s in _sections) _SectionExpansion(section: s),
            const Divider(),
            // Footer-Knoepfe
            _FooterTile(
              icon: Icons.share_rounded,
              label: 'App teilen',
              onTap: () async {
                final ok = await shareApp(
                  title: 'DogMatch AI',
                  text: 'Mein taeglicher Hunde-Begleiter:',
                  url: 'https://marcel-fe.github.io/dogmatch-ai/',
                );
                if (!context.mounted) return;
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link in die Zwischenablage kopiert / geteilt'),
                    ),
                  );
                }
              },
            ),
            _FooterTile(
              icon: Icons.gavel_rounded,
              label: 'Rechtliches & Impressum',
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.legal);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                '© DogMatch AI · v1.0',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _DrawerSection {
  const _DrawerSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<_DrawerItem> items;
}

class _DrawerItem {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String route;
}

class _SectionExpansion extends StatelessWidget {
  const _SectionExpansion({required this.section});
  final _DrawerSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: section.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(section.icon, color: section.color, size: 20),
        ),
        title: Text(
          section.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: AppSpacing.md),
        children: [
          for (final item in section.items)
            _ItemTile(item: item, color: section.color),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item, required this.color});
  final _DrawerItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(item.icon, color: color, size: 20),
      title: Text(item.label),
      onTap: () {
        Navigator.of(context).pop();
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

class _FooterTile extends StatelessWidget {
  const _FooterTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(label),
      onTap: onTap,
    );
  }
}
