import 'package:flutter/material.dart';

/// Tageszeit-Begruessung mit passendem Icon + Emoji.
/// Wird im Hero und in der "Heute fuer..."-Karte verwendet.
class TimeOfDayGreeting {
  const TimeOfDayGreeting({
    required this.salutation,
    required this.icon,
    required this.emoji,
    required this.dayPart,
  });

  /// Anrede ohne Namen - "Guten Morgen", "Hallo", "Schoenen Abend".
  final String salutation;

  /// Material-Icon (Sonne, Sonnenuntergang, Mond).
  final IconData icon;

  /// Emoji-Pendant fuer Texte.
  final String emoji;

  /// "morgen", "tag", "abend", "nacht" - fuer Tipps die sich auf
  /// den Tagesabschnitt beziehen.
  final String dayPart;

  static TimeOfDayGreeting forNow([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 11) {
      return const TimeOfDayGreeting(
        salutation: 'Guten Morgen',
        icon: Icons.wb_sunny_rounded,
        emoji: '☀️',
        dayPart: 'morgen',
      );
    }
    if (hour >= 11 && hour < 14) {
      return const TimeOfDayGreeting(
        salutation: 'Hallo',
        icon: Icons.light_mode_rounded,
        emoji: '🌞',
        dayPart: 'mittag',
      );
    }
    if (hour >= 14 && hour < 18) {
      return const TimeOfDayGreeting(
        salutation: 'Schoenen Nachmittag',
        icon: Icons.wb_twilight_rounded,
        emoji: '🌤️',
        dayPart: 'nachmittag',
      );
    }
    if (hour >= 18 && hour < 23) {
      return const TimeOfDayGreeting(
        salutation: 'Schoenen Abend',
        icon: Icons.nightlight_round,
        emoji: '🌙',
        dayPart: 'abend',
      );
    }
    return const TimeOfDayGreeting(
      salutation: 'Gute Nacht',
      icon: Icons.bedtime_rounded,
      emoji: '🌛',
      dayPart: 'nacht',
    );
  }
}
