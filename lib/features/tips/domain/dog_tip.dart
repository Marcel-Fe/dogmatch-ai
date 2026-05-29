import 'package:flutter/material.dart';

enum TipCategory {
  daily('Alltag', Icons.today_rounded, Color(0xFF7C6BF0)),
  health('Gesundheit', Icons.favorite_rounded, Color(0xFFE57373)),
  nutrition('Ernaehrung', Icons.restaurant_rounded, Color(0xFFFFB74D)),
  behavior('Verhalten', Icons.psychology_rounded, Color(0xFFBA68C8)),
  care('Pflege', Icons.spa_rounded, Color(0xFF4DD0E1)),
  summer('Sommer', Icons.wb_sunny_rounded, Color(0xFFFFB300)),
  winter('Winter', Icons.ac_unit_rounded, Color(0xFF64B5F6)),
  safety('Sicherheit', Icons.shield_rounded, Color(0xFF81C784)),
  socialization('Sozialisierung', Icons.groups_rounded, Color(0xFFFF8A65));

  const TipCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class DogTip {
  const DogTip({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
  });

  final String id;
  final TipCategory category;
  final String title;
  final String body;
}
