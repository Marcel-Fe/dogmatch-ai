import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Vorgefertigte Einstiegsfragen, damit der Nutzer das KI-Feature
/// sofort ausprobieren kann, ohne zu tippen.
class SuggestedPrompts extends StatelessWidget {
  const SuggestedPrompts({super.key, required this.onSelect});

  final void Function(String prompt) onSelect;

  static const List<String> _prompts = [
    'Welche Rasse passt zu Anfaengern?',
    'Welche Hunde sind familienfreundlich?',
    'Welche Hunde sind wohnungstauglich?',
    'Welche Hunde haaren wenig?',
    'Wie viel kostet ein Hund im Monat?',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final prompt in _prompts)
          ActionChip(
            label: Text(prompt),
            onPressed: () => onSelect(prompt),
          ),
      ],
    );
  }
}
