import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_button.dart';
import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onboarding. In Phase 1 ein einzelner Platzhalter - die animierten
/// Intro-Screens entstehen in Phase 2.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      'ausfuellen, Match erhalten, KI-Beratung nutzen.',
                ),
              ),
              AppButton(
                label: "Los geht's",
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppRoutes.login),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
