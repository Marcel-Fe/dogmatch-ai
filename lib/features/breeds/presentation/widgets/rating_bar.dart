import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Zeigt eine 1-bis-[max]-Bewertung als beschriftete Balkenreihe.
class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.label,
    required this.value,
    this.max = 5,
  });

  final String label;
  final int value;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < max; i++)
                  Expanded(
                    child: Container(
                      height: 8,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: i < value
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
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
