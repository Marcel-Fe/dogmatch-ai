import 'dart:convert';

import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Familien-App-Stil: grosses Hundebild oben mit verlaufendem Overlay,
/// darunter Hundename, optional Rasse/Alter, und ein stuendlich
/// wechselnder Wissens-/Beziehungs-Spruch.
///
/// Ohne Hund: ein einladendes Onboarding-Layout mit gleichem Footprint,
/// damit das Dashboard nicht "leer" wirkt.
class DogHeroCard extends StatelessWidget {
  const DogHeroCard({
    super.key,
    required this.dog,
    required this.quote,
    this.greetingName,
  });

  final Dog? dog;
  final String quote;
  final String? greetingName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hero = dog != null ? _withDog(theme) : _withoutDog(context, theme);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: hero,
      ),
    );
  }

  Widget _withDog(ThemeData theme) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 11,
          child: _DogPhotoOrFallback(dog: dog!),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
                stops: const [0.45, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (greetingName != null && greetingName!.isNotEmpty)
                Text(
                  'Hallo $greetingName',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              Text(
                dog!.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _subtitleFor(dog!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _QuoteRow(quote: quote, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _withoutDog(BuildContext context, ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  greetingName != null && greetingName!.isNotEmpty
                      ? 'Hallo $greetingName!'
                      : 'Willkommen!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Hund anlegen',
                color: Colors.white,
                icon: const Icon(Icons.add_a_photo_outlined),
                onPressed: () => context.push(AppRoutes.addDog),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Lege deinen Hund mit Foto an - das Dashboard wird sofort '
            'auf euch beide zugeschnitten.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _QuoteRow(quote: quote, color: Colors.white),
        ],
      ),
    );
  }

  String _subtitleFor(Dog dog) {
    final parts = <String>[];
    if (dog.breed != null) parts.add(dog.breed!);
    if (dog.ageYears != null) {
      parts.add(dog.ageYears == 1 ? '1 Jahr' : '${dog.ageYears} Jahre');
    }
    if (dog.weightKg != null) {
      parts.add('${dog.weightKg!.toStringAsFixed(1)} kg');
    }
    return parts.isEmpty ? 'Dein Hund' : parts.join(' · ');
  }
}

class _DogPhotoOrFallback extends StatelessWidget {
  const _DogPhotoOrFallback({required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    final raw = dog.photoBase64;
    if (raw != null && raw.isNotEmpty) {
      try {
        final base64Part = raw.contains(',') ? raw.split(',').last : raw;
        return Image.memory(
          base64Decode(base64Part),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (_) {
        // faellt durch zum Fallback
      }
    }
    return _photoFallback();
  }

  Widget _photoFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: Colors.white,
          size: 96,
        ),
      ),
    );
  }
}

class _QuoteRow extends StatelessWidget {
  const _QuoteRow({required this.quote, required this.color});

  final String quote;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              quote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
