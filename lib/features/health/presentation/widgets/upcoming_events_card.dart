import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Kompakte Dashboard-Karte: zeigt die naechsten 3 bevorstehenden Termine.
/// Tippt der Nutzer auf "Alle ansehen", landet er im Health-Kalender.
class UpcomingEventsCard extends ConsumerWidget {
  const UpcomingEventsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingHealthEventsProvider);
    final theme = Theme.of(context);
    final preview = upcoming.take(3).toList();

    return AppCard(
      onTap: () => context.push(AppRoutes.healthCalendar),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_available_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Naechste Termine',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (upcoming.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusPill,
                    ),
                  ),
                  child: Text(
                    '${upcoming.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (preview.isEmpty)
            Text(
              'Keine bevorstehenden Termine. Tippe hier, um einen anzulegen.',
              style: theme.textTheme.bodySmall,
            )
          else ...[
            for (final e in preview) ...[
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      e.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.MMMd('de').format(e.date),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ],
        ],
      ),
    );
  }
}
