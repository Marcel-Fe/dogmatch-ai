import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Uebersicht der rechtlichen Texte. Verlinkt jeweils auf eigene Seiten.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Rechtliches')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Colors.orange.shade800),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Die folgenden Texte sind Mustervorlagen. Wenn du die App '
                    'oeffentlich anbietest, pruefe sie bitte mit einem Anwalt '
                    'und passe sie auf deine Daten an.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Tile(
            icon: Icons.business_rounded,
            title: 'Impressum',
            subtitle: 'Anbieter-Kennzeichnung nach TMG §5',
            onTap: () => context.push(AppRoutes.imprint),
          ),
          _Tile(
            icon: Icons.lock_rounded,
            title: 'Datenschutzerklaerung',
            subtitle: 'Welche Daten gespeichert werden + DSGVO-Rechte',
            onTap: () => context.push(AppRoutes.privacy),
          ),
          _Tile(
            icon: Icons.description_rounded,
            title: 'Nutzungsbedingungen',
            subtitle: 'Regeln fuer die Nutzung der App',
            onTap: () => context.push(AppRoutes.terms),
          ),
          _Tile(
            icon: Icons.warning_amber_rounded,
            title: 'Haftungsausschluss',
            subtitle: 'Wofuer die App KEINEN Ersatz darstellt',
            onTap: () => context.push(AppRoutes.disclaimer),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 2),
                      Text(subtitle, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
