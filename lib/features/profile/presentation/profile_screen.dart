import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Profil (Tab 5). Einstiegspunkt zu Premium, Wissensbereich, Zuechter-Finder
/// und Einstellungen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _navButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SizedBox(
        width: 280,
        child: OutlinedButton.icon(
          onPressed: () => context.push(route),
          icon: Icon(icon),
          label: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FeaturePlaceholder(
        icon: Icons.person_rounded,
        title: 'Dein Profil',
        description:
            'Konto, Premium und weitere Bereiche erreichst du von hier aus.',
        actions: [
          _navButton(
            context,
            Icons.workspace_premium_outlined,
            'Premium',
            AppRoutes.premium,
          ),
          _navButton(
            context,
            Icons.menu_book_outlined,
            'Wissensbereich',
            AppRoutes.knowledge,
          ),
          _navButton(
            context,
            Icons.location_on_outlined,
            'Zuechter-Finder',
            AppRoutes.breederFinder,
          ),
          _navButton(
            context,
            Icons.settings_outlined,
            'Einstellungen',
            AppRoutes.settings,
          ),
        ],
      ),
    );
  }
}
