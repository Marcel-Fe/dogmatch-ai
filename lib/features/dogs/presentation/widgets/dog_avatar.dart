import 'dart:convert';

import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Rundes Hunde-Avatar-Widget. Zeigt das Foto an, wenn vorhanden -
/// sonst einen Pfoten-Platzhalter im Markenlila.
class DogAvatar extends StatelessWidget {
  const DogAvatar({
    super.key,
    required this.size,
    this.photoBase64,
    this.borderColor,
    this.borderWidth = 0,
  });

  final double size;
  final String? photoBase64;
  final Color? borderColor;
  final double borderWidth;

  Uint8List? _decodedBytes() {
    final raw = photoBase64;
    if (raw == null || raw.isEmpty) return null;
    final base64Part = raw.contains(',') ? raw.split(',').last : raw;
    try {
      return base64Decode(base64Part);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _decodedBytes();
    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.primary.withValues(alpha: 0.12),
      border: borderWidth > 0 && borderColor != null
          ? Border.all(color: borderColor!, width: borderWidth)
          : null,
    );

    // Foto nur in Anzeigegroesse dekodieren (x3 fuer hohe Pixeldichte) -
    // sonst haelt das iPhone das Vollbild im Speicher und ruckelt.
    final cacheW = (size * 3).round();

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: bytes != null
          ? Image.memory(bytes, fit: BoxFit.cover, cacheWidth: cacheW)
          : Icon(
              Icons.pets_rounded,
              size: size * 0.55,
              color: AppColors.primary,
            ),
    );
  }
}
