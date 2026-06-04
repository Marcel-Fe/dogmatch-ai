import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/core/providers/app_providers.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Zentraler Einstellungs-Hub. Alles, was man personalisieren kann, ist
/// hier zu finden: Profil + Land, Hunde, Sprache, Dashboard-Sektionen,
/// Theme. UI-Toggle aendert sofort den State und persistiert ihn.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final prefs = ref.watch(userPreferencesProvider).value ??
        const UserPreferences();
    final prefsNotifier = ref.read(userPreferencesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _SectionTitle('Profil'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Persoenliche Daten'),
            subtitle: Text(prefs.hasName ? prefs.displayName! : 'Anonym'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.editProfile),
          ),
          ListTile(
            leading: const Icon(Icons.public_outlined),
            title: const Text('Land'),
            subtitle: Text(prefs.country.label),
            trailing: PopupMenuButton<Country>(
              icon: const Icon(Icons.expand_more),
              onSelected: (c) =>
                  prefsNotifier.save(prefs.copyWith(country: c)),
              itemBuilder: (_) => [
                for (final c in Country.values)
                  PopupMenuItem(value: c, child: Text(c.label)),
              ],
            ),
          ),

          _SectionTitle('Hunde'),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: const Text('Meine Hunde verwalten'),
            subtitle: const Text('Anlegen, bearbeiten, aktiv waehlen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.manageDogs),
          ),
          ListTile(
            leading: const Icon(Icons.folder_open_outlined),
            title: const Text('Dokumente'),
            subtitle: const Text('Impfpass, Berichte, Vertraege'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.documents),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Kalender'),
            subtitle: const Text('Impfungen, Tierarzt-Termine'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.healthCalendar),
          ),

          _SectionTitle('KI-Berater'),
          SwitchListTile(
            secondary: const Icon(Icons.record_voice_over_outlined),
            title: const Text('Sprachausgabe'),
            subtitle: const Text(
              'Liest Antworten des KI-Beraters laut vor (Browser-Stimme).',
            ),
            value: prefs.ttsEnabled,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(ttsEnabled: v)),
          ),

          _SectionTitle('Dashboard anpassen'),
          SwitchListTile(
            secondary: const Icon(Icons.event_available_outlined),
            title: const Text('Termine als Erinnerung im Dashboard'),
            subtitle: const Text(
              'Zeigt deine naechsten Gesundheits-Termine offline oben '
              'auf der Startseite an.',
            ),
            value: prefs.showUpcomingOnHome,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(showUpcomingOnHome: v)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.recommend_outlined),
            title: const Text('Fuer dich-Empfehlungen'),
            value: prefs.showForYouOnHome,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(showForYouOnHome: v)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.grid_view_outlined),
            title: const Text('Feature-Kacheln'),
            value: prefs.showFeatureGridOnHome,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(showFeatureGridOnHome: v)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.list_alt_outlined),
            title: const Text('Alle Rassen-Liste'),
            value: prefs.showAllBreedsOnHome,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(showAllBreedsOnHome: v)),
          ),

          _SectionTitle('Dashboard-Design'),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final style in DashboardStyle.values)
                  _StyleSwatch(
                    style: style,
                    selected: prefs.dashboardStyle == style,
                    onTap: () => prefsNotifier
                        .save(prefs.copyWith(dashboardStyle: style)),
                  ),
              ],
            ),
          ),

          _SectionTitle('Darstellung'),
          SwitchListTile(
            secondary: const Icon(Icons.elderly_outlined),
            title: const Text('Senioren-Modus'),
            subtitle: const Text(
              'Groessere Schrift in der ganzen App - angenehmer zu lesen.',
            ),
            value: prefs.seniorMode,
            onChanged: (v) =>
                prefsNotifier.save(prefs.copyWith(seniorMode: v)),
          ),
          _ModeTile(
            label: 'System',
            icon: Icons.brightness_auto_outlined,
            value: ThemeMode.system,
            selected: mode,
            onTap: () => themeNotifier.setMode(ThemeMode.system),
          ),
          _ModeTile(
            label: 'Hell',
            icon: Icons.light_mode_outlined,
            value: ThemeMode.light,
            selected: mode,
            onTap: () => themeNotifier.setMode(ThemeMode.light),
          ),
          _ModeTile(
            label: 'Dunkel',
            icon: Icons.dark_mode_outlined,
            value: ThemeMode.dark,
            selected: mode,
            onTap: () => themeNotifier.setMode(ThemeMode.dark),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _StyleSwatch extends StatelessWidget {
  const _StyleSwatch({
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final DashboardStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    style.seed,
                    Color.lerp(style.seed, Colors.black, 0.28)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: selected
                      ? theme.colorScheme.onSurface
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: style.seed.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Dezentes Pfoten-Motiv - macht den Stil-Picker hundethematisch.
                  Positioned(
                    right: 6,
                    bottom: 4,
                    child: Icon(
                      Icons.pets_rounded,
                      size: 26,
                      color: Colors.white.withValues(alpha: 0.30),
                    ),
                  ),
                  if (selected)
                    const Center(
                      child: Icon(Icons.check_rounded,
                          color: Colors.white, size: 26),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              style.label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: selected == value
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
