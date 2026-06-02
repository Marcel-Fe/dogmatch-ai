import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_button.dart';
import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:dogmatch_ai/features/onboarding/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding. In Phase 1 ein einzelner Platzhalter - die animierten
/// Intro-Screens entstehen in Phase 2.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    // WICHTIG: Die Navigation darf NICHT vom Speichern abhaengen. In einer
    // iPhone-Home-Bildschirm-App (Standalone-PWA) kann der localStorage-
    // Schreibzugriff fehlschlagen - dann wuerde der Knopf sonst "nichts tun"
    // und man haengt ewig auf dem Willkommen-Screen fest.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kOnboardingDoneKey, true);
    } catch (_) {
      // Flag konnte nicht gespeichert werden - egal, trotzdem weiter.
    }
    if (!context.mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sicherheitsnetz: Ein Tipp IRGENDWO auf dem Screen fuehrt weiter - so
      // bleibt niemand haengen, falls das Knopf-Trefferfeld mal nicht reagiert.
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _finish(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Expanded(
                  child: FeaturePlaceholder(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Willkommen',
                    description:
                        'In drei Schritten zur passenden Hunderasse: Quiz '
                        'ausfuellen, Match erhalten, KI-Beratung nutzen.\n\n'
                        'Tippe auf "Los geht\'s" (oder irgendwo auf den Screen).',
                  ),
                ),
                AppButton(
                  label: "Los geht's",
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => _finish(context),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
