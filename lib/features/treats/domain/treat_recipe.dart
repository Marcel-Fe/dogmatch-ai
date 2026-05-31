import 'package:flutter/material.dart';

/// Kategorie eines Leckerli-Rezepts.
enum TreatCategory {
  baked('Gebacken', Icons.cookie_rounded, Color(0xFFFFB74D)),
  noBake('Ohne Backen', Icons.blender_rounded, Color(0xFF4DD0E1)),
  frozen('Gefroren', Icons.ac_unit_rounded, Color(0xFF64B5F6)),
  training('Trainings-Snack', Icons.school_rounded, Color(0xFF81C784));

  const TreatCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Ein einfaches, hundesicheres Leckerli-Rezept.
class TreatRecipe {
  const TreatRecipe({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.ingredients,
    required this.steps,
    required this.storage,
    this.tip,
  });

  final String id;
  final TreatCategory category;
  final String title;
  final String subtitle;
  final List<String> ingredients;
  final List<String> steps;

  /// Haltbarkeit / Aufbewahrung.
  final String storage;

  /// Optionaler Zusatz-Tipp.
  final String? tip;
}
