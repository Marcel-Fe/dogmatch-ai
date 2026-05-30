import 'dart:convert';

import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/home/domain/time_of_day_greeting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Familien-App-Stil: grosses Hundebild oben mit verlaufendem Overlay,
/// darunter Hundename, optional Rasse/Alter, und ein stuendlich
/// wechselnder Wissens-/Beziehungs-Spruch.
///
/// Bild-Quellen-Reihenfolge: eigenes Foto -> Rassen-Bild -> Pfoten-Fallback.
/// So sieht der Nutzer immer "seinen" Hund, nicht nur Pfoten.
class DogHeroCard extends StatelessWidget {
  const DogHeroCard({
    super.key,
    required this.dog,
    this.greetingName,
    this.breedImageUrl,
  });

  final Dog? dog;
  final String? greetingName;

  /// Optional: Bild der zugewiesenen Rasse. Wird gezeigt, wenn der Hund
  /// kein eigenes Foto hat.
  final String? breedImageUrl;

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
          child: _DogPhotoOrFallback(
            dog: dog!,
            breedImageUrl: breedImageUrl,
          ),
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
          top: AppSpacing.md,
          child: _TimeBadge(greeting: TimeOfDayGreeting.forNow()),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _personalGreeting(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _withoutDog(BuildContext context, ThemeData theme) {
    final greet = TimeOfDayGreeting.forNow();
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
          _TimeBadge(greeting: greet),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  greetingName != null && greetingName!.isNotEmpty
                      ? '${greet.salutation}, $greetingName!'
                      : '${greet.salutation}!',
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
        ],
      ),
    );
  }

  String _personalGreeting() {
    final greet = TimeOfDayGreeting.forNow();
    final name = greetingName;
    if (name == null || name.isEmpty) return '${greet.salutation}!';
    return '${greet.salutation}, $name';
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

/// Kleines Glas-Etikett oben im Hero, das die Tageszeit + Emoji zeigt.
/// Sehr dezent (geringer Alpha) - dient nur als visueller Anker.
class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.greeting});

  final TimeOfDayGreeting greeting;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(greeting.icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              greeting.salutation,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DogPhotoOrFallback extends StatelessWidget {
  const _DogPhotoOrFallback({required this.dog, this.breedImageUrl});

  final Dog dog;
  final String? breedImageUrl;

  @override
  Widget build(BuildContext context) {
    // 1) Eigenes Foto - in BoxFit.contain damit der Hund komplett
    //    sichtbar bleibt (kein Kopf-Abschnitt).
    final raw = dog.photoBase64;
    if (raw != null && raw.isNotEmpty) {
      try {
        final base64Part = raw.contains(',') ? raw.split(',').last : raw;
        return Container(
          color: AppColors.primary.withValues(alpha: 0.12),
          child: Image.memory(
            base64Decode(base64Part),
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        );
      } catch (_) {
        // faellt durch zum naechsten Fallback
      }
    }
    // 2) Rassen-Bild (sekundaerer Fallback) - so steht statt Pfoten
    //    immer ein konkreter Hund auf dem Dashboard.
    if (breedImageUrl != null && breedImageUrl!.isNotEmpty) {
      return Container(
        color: AppColors.primary.withValues(alpha: 0.12),
        child: Image.network(
          breedImageUrl!,
          fit: BoxFit.contain,
          // Grosses Bild fuer das Handy auf vernuenftige Breite begrenzen.
          cacheWidth: 1000,
          errorBuilder: (_, _, _) => _photoFallback(),
        ),
      );
    }
    // 3) Letzter Notfall: Pfoten-Gradient.
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

