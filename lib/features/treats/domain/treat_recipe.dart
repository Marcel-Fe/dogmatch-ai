import 'package:flutter/material.dart';

/// Kategorie eines Leckerli-Rezepts.
///
/// [imageUrl] ist ein passendes Foto (Wikimedia Commons, CORS-faehig). Falls
/// es mal nicht laedt, faellt die Karte auf das [icon] zurueck.
enum TreatCategory {
  baked(
    'Gebacken',
    Icons.cookie_rounded,
    Color(0xFFFFB74D),
    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Peanut_butter_cookies%2C_2015-07-12.jpg/960px-Peanut_butter_cookies%2C_2015-07-12.jpg',
  ),
  noBake(
    'Ohne Backen',
    Icons.blender_rounded,
    Color(0xFF4DD0E1),
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/2006-June-26-Peanut-Butter-Cookies-Uncooked.JPG/960px-2006-June-26-Peanut-Butter-Cookies-Uncooked.JPG',
  ),
  frozen(
    'Gefroren',
    Icons.ac_unit_rounded,
    Color(0xFF64B5F6),
    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Girl%2C_ice_cream_and_dog.jpg/960px-Girl%2C_ice_cream_and_dog.jpg',
  ),
  training(
    'Trainings-Snack',
    Icons.school_rounded,
    Color(0xFF81C784),
    'https://upload.wikimedia.org/wikipedia/commons/1/17/A_Dog_biscuit.jpg',
  );

  const TreatCategory(this.label, this.icon, this.color, this.imageUrl);
  final String label;
  final IconData icon;
  final Color color;
  final String imageUrl;
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
    this.imageUrl,
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

  /// Eigenes Foto fuer dieses Rezept. Wenn null, nutzt die Karte das
  /// Kategorie-Bild als Fallback.
  final String? imageUrl;
}
