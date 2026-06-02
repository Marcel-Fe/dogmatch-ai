import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/forms/data/form_catalog.dart';
import 'package:dogmatch_ai/features/places/data/geo_service.dart';
import 'package:flutter/material.dart';

// Schritt-fuer-Schritt-Ausfuellhilfen, je nach Formular-Typ. Werden anhand
// des Titels zugeordnet, damit der Katalog (32 Eintraege) unveraendert bleibt.
const _steuerSteps = <String>[
  'Deine Stadt/Gemeinde auf dem Portal suchen (oder "Hundesteuer + Wohnort" googeln).',
  'Formular "Hundesteuer-Anmeldung" oeffnen (online ausfuellbar oder als PDF).',
  'Deine Daten + Hundedaten eintragen: Rasse, Wurftag, Geschlecht, Chip-Nummer.',
  'Anschaffungs-/Zuzugsdatum angeben - ab da wird die Steuer faellig.',
  'Absenden bzw. unterschrieben einreichen. Du bekommst Bescheid + Hundemarke.',
];
const _sachkundeSteps = <String>[
  'Pruefen, ob in deinem Bundesland/fuer deinen Hund die Sachkunde Pflicht ist.',
  'Theorie-Termin bei einer anerkannten Stelle (Tierarzt/Hundeschule) buchen.',
  'Theorie bestehen, danach den Praxisteil mit deinem Hund absolvieren.',
  'Bescheinigung erhalten und bei der zustaendigen Behoerde einreichen.',
];
const _listeSteps = <String>[
  'Pruefen, ob deine Rasse im Bundesland als Listenhund gilt.',
  'Nachweise sammeln: Fuehrungszeugnis, Sachkunde, Wesenstest, Haftpflicht.',
  'Antrag auf Erlaubnis beim Ordnungsamt/der zustaendigen Behoerde stellen.',
  'Nach Pruefung Erlaubnis erhalten - oft mit Auflagen (z. B. Leine/Maulkorb).',
];

List<String> _formSteps(String title) {
  final t = title.toLowerCase();
  if (t.contains('steuer')) return _steuerSteps;
  if (t.contains('sachkunde') || t.contains('fuehrerschein')) {
    return _sachkundeSteps;
  }
  return _listeSteps;
}

/// Antraege & Formulare rund um den Hund, nach Bundesland (#23).
/// Zeigt Hundesteuer-Anmeldung, Sachkunde/Hundefuehrerschein und
/// Listenhund-Erlaubnis mit Ausfuellhilfe + Link zum offiziellen Portal.
class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  // Standard: NRW (grosses Bundesland) - Nutzer kann umstellen.
  BundeslandForms _selected = FormCatalog.all.firstWhere(
    (b) => b.name == 'Nordrhein-Westfalen',
    orElse: () => FormCatalog.all.first,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final geo = GeoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Antraege & Formulare')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blue.shade800),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Waehle dein Bundesland - du bekommst die wichtigsten '
                    'Antraege mit Ausfuellhilfe und Link zum offiziellen '
                    'Portal. Die Hundesteuer regelt deine Gemeinde; der Link '
                    'fuehrt zum Landesportal als Startpunkt.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          DropdownButtonFormField<BundeslandForms>(
            initialValue: _selected,
            decoration: const InputDecoration(
              labelText: 'Bundesland',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final b in FormCatalog.all)
                DropdownMenuItem(value: b, child: Text(b.name)),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _selected = v);
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          for (final form in _selected.forms)
            _FormCard(form: form, onOpen: () => geo.openExternal(form.url)),

          const SizedBox(height: AppSpacing.lg),
          Text(
            'Hinweis: Regeln und Pflichten unterscheiden sich je Gemeinde und '
            'aendern sich. Diese Angaben sind ein Startpunkt, keine '
            'Rechtsberatung - im Zweifel direkt bei deiner Gemeinde nachfragen.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _FormCard extends StatefulWidget {
  const _FormCard({required this.form, required this.onOpen});

  final DogForm form;
  final VoidCallback onOpen;

  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = widget.form;
    final steps = _formSteps(f.title);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
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
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.description_rounded,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 2),
                          Text(f.purpose, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Icon(_open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded),
                  ],
                ),
              ),
            ),
            if (_open)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('So fuellst du es aus:',
                        style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    for (var s = 0; s < steps.length; s++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Text('${s + 1}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                                child: Text(steps[s],
                                    style: theme.textTheme.bodySmall)),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Das solltest du bereithalten:',
                        style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    for (final h in f.fillHelp)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                                child: Text(h,
                                    style: theme.textTheme.bodySmall)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            // Direkter Zugriff aufs Formular - immer sichtbar, nicht erst
            // nach dem Aufklappen.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.onOpen,
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Formular oeffnen'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
