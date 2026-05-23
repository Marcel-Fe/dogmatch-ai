import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Platzhalter-Inhalt fuer Phase 1. Jeder Feature-Screen zeigt vorerst diesen
/// Baustein; die echte UI folgt in Phase 2. So ist die Navigation bereits
/// vollstaendig testbar, bevor die Screens ausgebaut werden.
class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actions = const [],
  });

  final IconData icon;
  final String title;
  final String description;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              ...actions,
            ],
          ],
        ),
      ),
    );
  }
}
