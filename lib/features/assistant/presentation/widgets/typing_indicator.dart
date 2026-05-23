import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Zeigt waehrend des Wartens auf die KI-Antwort eine schmale Bubble mit
/// drei Punkten. Bewusst statisch in Phase 2 - eine Animation kann
/// spaeter folgen.
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusMd),
            topRight: Radius.circular(AppSpacing.radiusMd),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Text(
          '...',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
