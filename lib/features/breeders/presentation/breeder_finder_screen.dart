import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';

/// Zuechter-Finder. Suche nach Standort, Rasse und Bewertungen; Kartenansicht
/// und Geo-Suche werden in Phase 5 ergaenzt.
class BreederFinderScreen extends StatelessWidget {
  const BreederFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zuechter-Finder')),
      body: const FeaturePlaceholder(
        icon: Icons.location_on_outlined,
        title: 'Seriöse Zuechter finden',
        description:
            'Finde verifizierte Hundezuechter in deiner Naehe. Die Suche '
            'und Kartenansicht entstehen in Phase 5.',
      ),
    );
  }
}
