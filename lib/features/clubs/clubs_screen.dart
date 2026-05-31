import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/places/data/geo_service.dart';
import 'package:flutter/material.dart';

/// Ein offizieller Hunde-Dachverband oder -verein.
class DogClub {
  const DogClub({
    required this.name,
    required this.region,
    required this.description,
    required this.url,
  });

  final String name;
  final String region;
  final String description;
  final String url;
}

/// Uebersicht offizieller Hundevereine und Dachverbaende mit Links zu den
/// jeweiligen Webseiten. Kuratiert, Schwerpunkt DACH.
class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  static const _clubs = <DogClub>[
    DogClub(
      name: 'VDH - Verband fuer das Deutsche Hundewesen',
      region: 'Deutschland',
      description:
          'Groesster kynologischer Dachverband Deutschlands. Zuechter-Suche, '
          'Rassestandards, Hundeschulen und Ausstellungen.',
      url: 'https://www.vdh.de',
    ),
    DogClub(
      name: 'OEKV - Oesterreichischer Kynologenverband',
      region: 'Oesterreich',
      description:
          'Dachverband fuer Hundezucht und -sport in Oesterreich, '
          'mit Zuechter- und Vereinsverzeichnis.',
      url: 'https://www.oekv.at',
    ),
    DogClub(
      name: 'SKG - Schweizerische Kynologische Gesellschaft',
      region: 'Schweiz',
      description:
          'Dachorganisation des Schweizer Hundewesens: Zucht, Sport, '
          'Ausbildung und Rasseklubs.',
      url: 'https://www.skg.ch',
    ),
    DogClub(
      name: 'FCI - Federation Cynologique Internationale',
      region: 'International',
      description:
          'Weltdachverband der Kynologie. Definiert die rund 350 anerkannten '
          'Rassestandards (auch in dieser App genutzt).',
      url: 'https://www.fci.be',
    ),
    DogClub(
      name: 'dhv - Deutscher Hundesportverein',
      region: 'Deutschland',
      description:
          'Verband fuer Hundesport und Ausbildung (Begleithund, Agility, '
          'Faehrte) mit angeschlossenen Ortsvereinen.',
      url: 'https://www.dhv-hundesport.de',
    ),
    DogClub(
      name: 'BHV - Berufsverband der Hundeerzieher',
      region: 'Deutschland',
      description:
          'Zusammenschluss gepruefter Hundetrainer und -schulen. Hilfreich, '
          'um eine serioese Hundeschule in der Naehe zu finden.',
      url: 'https://www.hundeerzieher.de',
    ),
    DogClub(
      name: 'Deutscher Tierschutzbund',
      region: 'Deutschland',
      description:
          'Dachverband der Tierschutzvereine und Tierheime. Anlaufstelle, '
          'wenn du einen Hund adoptieren moechtest.',
      url: 'https://www.tierschutzbund.de',
    ),
    DogClub(
      name: 'TASSO Haustierzentralregister',
      region: 'Deutschland / EU',
      description:
          'Kostenloses Register fuer Chip-Nummern. Registriere deinen Hund, '
          'damit er bei Verlust schnell zugeordnet werden kann.',
      url: 'https://www.tasso.net',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final geo = GeoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Hundevereine')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Offizielle Dachverbaende und Anlaufstellen rund um den Hund. '
            'Tippe auf einen Eintrag, um die Webseite zu oeffnen.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final c in _clubs)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Material(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  onTap: () => geo.openExternal(c.url),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.groups_rounded,
                              color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )),
                              const SizedBox(height: 2),
                              Text(c.region,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  )),
                              const SizedBox(height: AppSpacing.xs),
                              Text(c.description,
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
