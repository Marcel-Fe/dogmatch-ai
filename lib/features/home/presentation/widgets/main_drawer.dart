import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/utils/share_app.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Haupt-Navigation als Drawer. Oberkategorien sind aufklappbare Gruppen mit
/// eigenem Hunde-Icon. Das Auf-/Zuklappen laeuft ueber InkWell + setState +
/// AnimatedSize - schnell und zuverlaessig auch auf dem Handy (das alte
/// ExpansionTile reagierte unter der schweren Web-Engine oft nicht auf Tippen).
class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  // Erste Gruppe ist anfangs offen - so ist sofort Inhalt sichtbar.
  final Set<String> _open = {'Mein Hund'};

  static const _sections = <_DrawerSection>[
    _DrawerSection(
      title: 'Mein Hund',
      icon: Icons.pets_rounded,
      color: AppColors.primary,
      items: [
        _DrawerItem(
          icon: Icons.folder_shared_rounded,
          label: 'Hunde-Akte',
          route: AppRoutes.dogRecord,
        ),
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
        _DrawerItem(
          icon: Icons.near_me_rounded,
          label: 'Tieraerzte in der Naehe',
          route: AppRoutes.nearby,
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
          assistantMode: ChatMode.trainer,
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
          icon: Icons.cookie_rounded,
          label: 'Leckerli-Rezepte',
          route: AppRoutes.treats,
        ),
        _DrawerItem(
          icon: Icons.groups_rounded,
          label: 'Hundevereine',
          route: AppRoutes.clubs,
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
          icon: Icons.assignment_rounded,
          label: 'Antraege & Formulare',
          route: AppRoutes.forms,
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
          icon: Icons.pets_rounded,
          label: 'Alle Rassen durchstoebern',
          route: AppRoutes.breedList,
        ),
        _DrawerItem(
          icon: Icons.merge_type_rounded,
          label: 'Mischling-Wesensrechner',
          route: AppRoutes.mixBreed,
        ),
        _DrawerItem(
          icon: Icons.verified_user_rounded,
          label: 'Zuechter finden',
          route: AppRoutes.breederFinder,
        ),
        _DrawerItem(
          icon: Icons.school_rounded,
          label: 'Zuechterwissen',
          route: AppRoutes.breedingKnowledge,
        ),
        _DrawerItem(
          icon: Icons.menu_book_rounded,
          label: 'FCI-Standards',
          route: AppRoutes.fciStandards,
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
      ],
    ),
  ];

  void _toggle(String title) {
    setState(() {
      if (!_open.remove(title)) _open.add(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = ref.watch(userPreferencesProvider).value;
    final name = prefs != null && prefs.hasName ? prefs.displayName : null;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(theme: theme, name: name),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  for (final s in _sections)
                    _Section(
                      section: s,
                      expanded: _open.contains(s.title),
                      onToggle: () => _toggle(s.title),
                    ),
                  // Einstellungen als eigene Kategorie (direkt, ohne Aufklappen).
                  _CategoryLink(
                    icon: Icons.settings_rounded,
                    title: 'Einstellungen',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.settings);
                    },
                  ),
                  const Divider(
                    height: AppSpacing.xl,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
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
                            content: Text(
                              'Link in die Zwischenablage kopiert / geteilt',
                            ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
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
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.theme, required this.name});

  final ThemeData theme;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 28,
            ),
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
                  name != null
                      ? 'Schoen, dass du da bist, $name!'
                      : 'Dein taeglicher Hunde-Begleiter',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    this.assistantMode,
  });
  final IconData icon;
  final String label;
  final String route;

  /// Wenn gesetzt, wird der KI-Berater beim Oeffnen in diesen Modus
  /// geschaltet (z. B. "KI-Hundetrainer" -> Trainer statt Berater).
  final ChatMode? assistantMode;
}

/// Aufklappbare Gruppe. Tipp auf die Kopfzeile klappt zuverlaessig auf/zu.
class _Section extends StatelessWidget {
  const _Section({
    required this.section,
    required this.expanded,
    required this.onToggle,
  });

  final _DrawerSection section;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: section.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(section.icon, color: section.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    section.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.lg,
                    bottom: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      for (final item in section.items)
                        _ItemTile(item: item, color: section.color),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item, required this.color});
  final _DrawerItem item;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(item.icon, color: color, size: 20),
      title: Text(item.label),
      onTap: () {
        Navigator.of(context).pop();
        // Optional den KI-Modus setzen (z. B. direkt in den Trainer).
        if (item.assistantMode != null) {
          ref.read(chatModeProvider.notifier).setMode(item.assistantMode!);
        }
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

/// Eigenstaendige Menue-Kategorie ohne Unterpunkte: sieht aus wie ein
/// Sektionskopf (farbiges Icon-Badge + Titel), navigiert aber direkt.
class _CategoryLink extends StatelessWidget {
  const _CategoryLink({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
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
