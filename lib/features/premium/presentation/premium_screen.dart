import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';

/// Premium-Upgrade. Stellt spaeter das Freemium-Modell und die Vorteile dar.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DogMatch Premium')),
      body: const FeaturePlaceholder(
        icon: Icons.workspace_premium_outlined,
        title: 'DogMatch Premium',
        description:
            'Unbegrenzte KI-Beratung, detaillierte Analysen und '
            'Trainingsplaene - die Upgrade-Seite folgt in Phase 4.',
      ),
    );
  }
}
