import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_button.dart';
import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Anmeldung. E-Mail-, Google- und Apple-Login folgen mit der Backend-Phase;
/// in Phase 1 geht es im Gastmodus weiter.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Expanded(
                child: FeaturePlaceholder(
                  icon: Icons.lock_outline_rounded,
                  title: 'Anmelden',
                  description:
                      'E-Mail-, Google- und Apple-Login werden mit der '
                      'Backend-Phase ergaenzt.',
                ),
              ),
              AppButton(
                label: 'Als Gast fortfahren',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
