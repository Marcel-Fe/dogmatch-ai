import 'package:dogmatch_ai/core/widgets/feature_placeholder.dart';
import 'package:flutter/material.dart';

/// Zuechter-Profil mit Zertifizierungen, Erfahrung und Bewertungen.
class BreederProfileScreen extends StatelessWidget {
  const BreederProfileScreen({super.key, required this.breederId});

  final String breederId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zuechter-Profil')),
      body: FeaturePlaceholder(
        icon: Icons.verified_outlined,
        title: 'Zuechter: $breederId',
        description:
            'Das Zuechter-Profil mit Bewertungen und Kontakt folgt in Phase 5.',
      ),
    );
  }
}
