import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_matcher.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:dogmatch_ai/features/home/domain/time_of_day_greeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "Heute fuer [Hundename]" - das personalisierte Tages-Briefing.
///
/// Kombiniert:
/// - naechster Gesundheits-Termin (falls einer in 7 Tagen ansteht)
/// - tageszeit-spezifischer Tipp (Morgen-Runde, Mittagsruhe, Abend-Routine)
/// - kleines Stoerer-Emoji zur aktuellen Tageszeit
///
/// Bewusst kompakt: zwei Zeilen Text + ein CTA pro Tipp.
class TodayCard extends ConsumerWidget {
  const TodayCard({super.key, required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final greet = TimeOfDayGreeting.forNow();
    final eventsAsync = ref.watch(healthProvider);

    final upcoming = eventsAsync.maybeWhen(
      data: (events) {
        final today = DateTime.now();
        final week = today.add(const Duration(days: 7));
        final filtered = events
            .where((e) =>
                e.dogId == dog.id &&
                e.date.isAfter(today.subtract(const Duration(days: 1))) &&
                e.date.isBefore(week))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        return filtered.isEmpty ? null : filtered.first;
      },
      orElse: () => null,
    );

    final tipText = _tipFor(greet.dayPart, dog);
    final tipIcon = _tipIconFor(greet.dayPart);

    // Rassen-Tipp (nur wenn Rasse erkannt) - nimmt den ersten careTip,
    // damit der Hund "auf den eigenen Hund zugeschnitten" wirkt.
    final breedsAsync = ref.watch(breedsProvider);
    final matchedBreed =
        matchBreed(dog.breed, breedsAsync.value ?? const []);
    final breedTip = matchedBreed != null && matchedBreed.careTips.isNotEmpty
        ? matchedBreed.careTips.first
        : null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.95),
            AppColors.primaryDark.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Foto des Hundes (Pfote als Fallback) macht die Karte
              // persoenlich - "heute fuer DEINEN Hund".
              DogAvatar(
                photoBase64: dog.photoBase64,
                size: 44,
                borderColor: Colors.white.withValues(alpha: 0.85),
                borderWidth: 2,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(greet.icon, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          greet.salutation,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Heute fuer ${dog.name}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                greet.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Row(
            icon: tipIcon,
            text: tipText,
            color: Colors.white,
          ),
          if (breedTip != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _Row(
              icon: Icons.pets_rounded,
              text: '${matchedBreed!.name}-Tipp: $breedTip',
              color: Colors.white,
            ),
          ],
          if (upcoming != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _Row(
              icon: Icons.event_rounded,
              text: '${_relativeDay(upcoming.date)}: ${upcoming.title}',
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonalIcon(
              onPressed: () => context.push(AppRoutes.healthCalendar),
              icon: const Icon(Icons.calendar_today_rounded, size: 16),
              label: const Text('Zum Kalender'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.22),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _relativeDay(DateTime when) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(when.year, when.month, when.day);
    final diff = d.difference(today).inDays;
    if (diff <= 0) return 'Heute';
    if (diff == 1) return 'Morgen';
    if (diff < 7) return 'In $diff Tagen';
    return '${d.day}.${d.month}.';
  }

  static IconData _tipIconFor(String dayPart) {
    switch (dayPart) {
      case 'morgen':
        return Icons.directions_walk_rounded;
      case 'mittag':
        return Icons.restaurant_rounded;
      case 'nachmittag':
        return Icons.sports_tennis_rounded;
      case 'abend':
        return Icons.self_improvement_rounded;
      case 'nacht':
        return Icons.bed_rounded;
      default:
        return Icons.pets_rounded;
    }
  }

  static String _tipFor(String dayPart, Dog dog) {
    final name = dog.name;
    switch (dayPart) {
      case 'morgen':
        return 'Frueher Spaziergang weckt $name sanft fuer den Tag.';
      case 'mittag':
        return 'Wasser-Check und kurze Spielrunde halten $name aktiv.';
      case 'nachmittag':
        return 'Perfekte Zeit fuer Training oder Nasenarbeit mit $name.';
      case 'abend':
        return 'Letzte Runde + Kuschelzeit - so kommt $name zur Ruhe.';
      case 'nacht':
        return '$name schlaeft jetzt vermutlich tief - leise auftreten.';
      default:
        return 'Fester Tagesablauf hilft $name am meisten.';
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color.withValues(alpha: 0.9), size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color.withValues(alpha: 0.92),
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
