import 'package:dogmatch_ai/app/router/app_router.dart';
import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/providers/app_providers.dart';
import 'package:dogmatch_ai/core/theme/app_theme.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wurzel-Widget der App. Bindet Router und Theme an und reagiert auf den
/// per Riverpod gewaehlten Theme-Modus sowie den Senioren-Modus.
class DogMatchApp extends ConsumerWidget {
  const DogMatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final prefs = ref.watch(userPreferencesProvider).value;
    // Senioren-Modus vergroessert die gesamte Schrift der App.
    final seniorMode = prefs?.seniorMode ?? false;
    // Gewaehltes Dashboard-Design bestimmt die Akzentfarbe der App.
    final seed = prefs?.dashboardStyle.seed;

    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(seed: seed),
      darkTheme: AppTheme.dark(seed: seed),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final base = media.textScaler.scale(1.0);
        // Im Senioren-Modus ~30 % groesser, aber gedeckelt, damit Layouts
        // nicht brechen.
        final factor = seniorMode ? (base * 1.3).clamp(1.0, 1.6) : base;
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(factor)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
