import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Vorgefertigte Einstiegsfragen, damit der Nutzer das KI-Feature
/// sofort ausprobieren kann, ohne zu tippen.
class SuggestedPrompts extends StatelessWidget {
  const SuggestedPrompts({
    super.key,
    required this.onSelect,
    this.prompts,
  });

  final void Function(String prompt) onSelect;

  /// Optional eigene Liste. Wenn null, werden die Standard-Berater-Prompts
  /// gezeigt.
  final List<String>? prompts;

  static const List<String> _defaultPrompts = [
    'Welche Rasse passt zu Anfaengern?',
    'Welche Hunde sind familienfreundlich?',
    'Welche Hunde sind wohnungstauglich?',
    'Welche Hunde haaren wenig?',
    'Wie viel kostet ein Hund im Monat?',
  ];

  @override
  Widget build(BuildContext context) {
    final list = prompts ?? _defaultPrompts;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final prompt in list)
          ActionChip(
            label: Text(prompt),
            onPressed: () => onSelect(prompt),
          ),
      ],
    );
  }
}
