import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/home_leading_button.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Profil-Tab. Oben die persoenliche Profilkarte (Name, Land, Vorlieben),
/// darunter Navigation zu Premium, Wissensbereich, Zuechter-Finder und
/// Einstellungen.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: const HomeLeadingButton(),
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _ProfileHeader(prefs: prefs ?? const UserPreferences()),
          const SizedBox(height: AppSpacing.xl),
          _MenuTile(
            icon: Icons.workspace_premium_outlined,
            label: 'Premium',
            onTap: () => context.push(AppRoutes.premium),
          ),
          _MenuTile(
            icon: Icons.menu_book_outlined,
            label: 'Wissensbereich',
            onTap: () => context.push(AppRoutes.knowledge),
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            label: 'Zuechter-Finder',
            onTap: () => context.push(AppRoutes.breederFinder),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Einstellungen',
            onTap: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.prefs});

  final UserPreferences prefs;

  String _initials() {
    if (!prefs.hasName) return '?';
    final parts = prefs.displayName!.trim().split(RegExp(r'\s+'));
    final letters =
        parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = prefs.hasName ? prefs.displayName! : 'Persoenliches Profil';
    final subtitle = prefs.hasName
        ? '${prefs.country.label} · personalisiert'
        : 'Tippe auf Bearbeiten, um die App auf dich zuzuschneiden';

    return AppCard(
      onTap: () => context.push(AppRoutes.editProfile),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.outline),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(label, style: theme.textTheme.titleSmall),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
