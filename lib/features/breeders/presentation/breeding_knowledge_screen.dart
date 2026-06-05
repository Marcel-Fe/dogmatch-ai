import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ein aufklappbarer Wissensblock.
class _Topic {
  const _Topic(this.icon, this.title, this.intro, this.points);
  final IconData icon;
  final String title;
  final String intro;
  final List<String> points;
}

const List<_Topic> _kTopics = [
  _Topic(
    Icons.pets_rounded,
    'Was ein Welpe dabei haben muss',
    'Beim serioesen Zuechter bekommst du den Welpen nie "einfach so". Das '
        'gehoert beim Abholen dazu:',
    [
      'Mindestalter 8 Wochen (viele geben erst mit 9-10 Wochen ab)',
      'Mikrochip (Transponder) - die Nummer steht im Ausweis',
      'EU-Heimtierausweis',
      'Begonnene Grundimmunisierung - erste Impfung dokumentiert',
      'Mehrfach entwurmt, mit Datum belegt',
      'Ahnentafel / Papiere eines anerkannten Verbands (VDH/FCI)',
      'Schriftlicher Kaufvertrag',
      'Du darfst Mutterhuendin und Aufzuchtumgebung sehen',
    ],
  ),
  _Topic(
    Icons.biotech_rounded,
    'Gesundheitstests der Elterntiere',
    'Serioese Zuchten testen die Elterntiere, bevor sie verpaart werden - '
        'das senkt das Risiko fuer Erbkrankheiten. Ueblich sind:',
    [
      'HD- und ED-Roentgen (Hueft- und Ellbogendysplasie)',
      'Augenuntersuchung (z. B. DOK/ECVO) - u. a. PRA, Katarakt',
      'Patella-Luxation (Kniescheibe), v. a. bei kleinen Rassen',
      'Herzuntersuchung (Abhoeren/Ultraschall) bei dafuer anfaelligen Rassen',
      'DNA-/Gentests je nach Rasse (z. B. PRA, DM, MDR1)',
      'Wesenstest bzw. Zuchtzulassung des Verbands',
    ],
  ),
  _Topic(
    Icons.medical_services_rounded,
    'Tierarzt-Untersuchungen fuer deinen Hund',
    'Dieses Grundprogramm begleitet einen gesunden Hund durchs Leben - das '
        'genaue Schema legt deine Tierarztpraxis fest:',
    [
      'Erstuntersuchung kurz nach dem Einzug',
      'Grundimmunisierung: Staupe, Parvovirose, Hepatitis, Leptospirose, '
          'Tollwut - Welpenschema, dann regelmaessige Auffrischung',
      'Entwurmung nach Schema + Floh-/Zeckenschutz',
      'Jaehrlicher Gesundheits-Check inkl. Impfkontrolle',
      'Zaehne, Ohren, Krallen und Gewicht im Blick behalten',
      'Kastration: optional - in Ruhe mit dem Tierarzt abwaegen',
      'Ab ca. 7 Jahren: haeufigere Checks, ggf. Blutbild (Senioren)',
    ],
  ),
  _Topic(
    Icons.warning_amber_rounded,
    'Daran erkennst du unserioese Anbieter',
    'Finger weg, wenn dir eines dieser Dinge begegnet:',
    [
      '"Ohne Papiere, dafuer guenstig" oder auffallend billig',
      'Mehrere Rassen "auf Lager", staendig Welpen verfuegbar',
      'Uebergabe auf Parkplatz, Versand oder kein Besuch moeglich',
      'Mutterhuendin ist nie zu sehen',
      'Welpe wirkt zu jung, kraenklich oder ungeimpft',
      'Der Anbieter stellt dir keinerlei Fragen',
    ],
  ),
];

/// Zuechterwissen: was ein Welpe und ein Hund an Untersuchungen und Papieren
/// braucht - allgemein gueltig fuer alle Rassen. Rassespezifische
/// Gesundheitsthemen stehen im jeweiligen Rasseprofil.
class BreedingKnowledgeScreen extends StatefulWidget {
  const BreedingKnowledgeScreen({super.key});

  @override
  State<BreedingKnowledgeScreen> createState() =>
      _BreedingKnowledgeScreenState();
}

class _BreedingKnowledgeScreenState extends State<BreedingKnowledgeScreen> {
  final Set<int> _open = {0};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Zuechterwissen')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school_rounded,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Gut vorbereitet zum Welpen',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Welche Papiere und Untersuchungen ein Welpe und ein Hund '
                  'braucht - gilt fuer alle Rassen. So weisst du genau, worauf '
                  'du beim Zuechter und beim Tierarzt achten musst.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < _kTopics.length; i++)
            _TopicCard(
              topic: _kTopics[i],
              open: _open.contains(i),
              theme: theme,
              onTap: () => setState(() {
                if (_open.contains(i)) {
                  _open.remove(i);
                } else {
                  _open.add(i);
                }
              }),
            ),
          const SizedBox(height: AppSpacing.md),

          // Rassespezifischer Verweis
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rassespezifische Tests',
                    style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Jede Rasse hat eigene typische Gesundheitsthemen. Welche '
                  'Tests fuer deine Wunschrasse besonders wichtig sind, siehst '
                  'du im Rasseprofil unter "Haeufige Gesundheitsthemen".',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.breedList),
                  icon: const Icon(Icons.pets_rounded, size: 18),
                  label: const Text('Rassen ansehen'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Diese Infos sind eine allgemeine Orientierung und ersetzen keine '
            'tieraerztliche Beratung. Im Zweifel immer die Tierarztpraxis '
            'deines Vertrauens fragen.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.open,
    required this.onTap,
    required this.theme,
  });

  final _Topic topic;
  final bool open;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final warn = topic.icon == Icons.warning_amber_rounded;
    final accent =
        warn ? Colors.orange.shade800 : theme.colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(topic.icon, color: accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(topic.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Icon(open
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic.intro, style: theme.textTheme.bodySmall),
                        const SizedBox(height: AppSpacing.sm),
                        for (final p in topic.points)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Icon(
                                    warn
                                        ? Icons.close_rounded
                                        : Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(p,
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
