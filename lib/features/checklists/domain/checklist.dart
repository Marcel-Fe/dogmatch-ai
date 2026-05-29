import 'package:flutter/material.dart';

class Checklist {
  const Checklist({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> items;
}
