import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sichtbarer "Zum Start"-Knopf fuer die Haupt-Tabs (Profil, Quiz, Favoriten,
/// KI-Berater). Diese Tabs lassen sich sonst nur ueber die untere Leiste
/// verlassen - der Knopf gibt einen klaren Weg zurueck zum Dashboard, damit
/// niemand das Gefuehl hat, festzustecken.
class HomeLeadingButton extends StatelessWidget {
  const HomeLeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Zum Start',
      icon: const Icon(Icons.home_rounded),
      onPressed: () => context.go(AppRoutes.home),
    );
  }
}
