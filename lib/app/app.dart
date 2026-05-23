import 'package:dogmatch_ai/app/router/app_router.dart';
import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/providers/app_providers.dart';
import 'package:dogmatch_ai/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wurzel-Widget der App. Bindet Router und Theme an und reagiert auf den
/// per Riverpod gewaehlten Theme-Modus.
class DogMatchApp extends ConsumerWidget {
  const DogMatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
