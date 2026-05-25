import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Hervorgehobener Header-Bereich oben auf dem Dashboard.
/// Lila Verlauf + personalisierte Begruessung + CTA zum Quiz.
///
/// Wenn der Nutzer einen aktiven Hund hat, ersetzt dessen Foto den
/// generischen Pfoten-Kreis rechts und der Header bekommt einen Tap-Handler,
/// der zur Hunde-Verwaltung navigiert.
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
    this.dogPhotoBase64,
    this.dogName,
  });

  final String greeting;
  final String subtitle;
  final String? dogPhotoBase64;
  final String? dogName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(
                onTap: () => context.push(AppRoutes.manageDogs),
                child: dogPhotoBase64 != null
                    ? DogAvatar(
                        size: 64,
                        photoBase64: dogPhotoBase64,
                        borderColor: Colors.white,
                        borderWidth: 2,
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pets_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.quiz),
            icon: const Icon(Icons.bolt_rounded),
            label: const Text('Matching-Quiz starten'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
