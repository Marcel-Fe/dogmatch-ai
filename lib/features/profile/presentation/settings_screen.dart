import 'package:dogmatch_ai/core/providers/app_providers.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Einstellungen. In Phase 1 schon funktionsfaehig: die Theme-Auswahl
/// schaltet die App live zwischen Hell-, Dunkel- und Systemmodus um und
/// demonstriert damit das Riverpod-State-Management.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final theme = Theme.of(context);

    Widget modeTile(String label, IconData icon, ThemeMode value) {
      return ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: mode == value
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
        onTap: () => notifier.setMode(value),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xs,
            ),
            child: Text('Darstellung', style: theme.textTheme.titleMedium),
          ),
          modeTile('System', Icons.brightness_auto_outlined, ThemeMode.system),
          modeTile('Hell', Icons.light_mode_outlined, ThemeMode.light),
          modeTile('Dunkel', Icons.dark_mode_outlined, ThemeMode.dark),
        ],
      ),
    );
  }
}
