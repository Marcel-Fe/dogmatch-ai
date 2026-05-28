import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/home/domain/hourly_quote.dart';
import 'package:flutter/material.dart';

/// Prominente Spruch-Karte fuer das Dashboard. Wechselt jede Stunde.
/// Eigene Karte (nicht im Hero versteckt) - groesseres Anfuehrungszeichen,
/// Autor wenn vorhanden, dezenter Gradient.
class WisdomQuoteCard extends StatelessWidget {
  const WisdomQuoteCard({super.key, this.now});

  /// Optional - nur fuer Tests. Default = aktuelle Zeit.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quote = HourlyQuote.currentWisdom(now);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.22),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grosses Anfuehrungszeichen
          Text(
            '"',
            style: theme.textTheme.displayMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              height: 0.9,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Hunde-Weisheit der Stunde',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  quote.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.35,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (quote.author != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '- ${quote.author}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
