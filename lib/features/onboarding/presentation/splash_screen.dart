import 'dart:async';

import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistenter Flag - true sobald der Nutzer das Onboarding abgeschlossen
/// hat. Wird im SplashScreen gelesen + im OnboardingScreen gesetzt.
const String kOnboardingDoneKey = 'onboarding_done';

/// Startbildschirm. Zeigt kurz das App-Logo und springt dann zum Onboarding
/// oder direkt zum Home, je nachdem ob der Nutzer schon mal hier war.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    // Splash mind. so kurz, dass das Logo erkennbar ist.
    final stopwatch = Stopwatch()..start();
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(kOnboardingDoneKey) ?? false;
    final remaining =
        AppConstants.splashDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted) return;
    context.go(done ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets_rounded, size: 88, color: Colors.white),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'DogMatch AI',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Finde deinen perfekten Hund',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
