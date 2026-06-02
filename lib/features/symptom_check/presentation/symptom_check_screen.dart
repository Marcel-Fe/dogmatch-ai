import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/stt_service.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/symptom_check/data/symptom_catalog.dart';
import 'package:dogmatch_ai/features/symptom_check/data/symptom_engine.dart';
import 'package:dogmatch_ai/features/symptom_check/domain/symptom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Symptom-Check. Nutzer waehlt vorhandene Beschwerden, beschreibt sie
/// optional per Sprache und bekommt Verdachts-Diagnosen mit Dringlichkeits-
/// Einstufung. Auf Wunsch wird der Fall an den KI-Berater uebergeben.
///
/// WICHTIG: Ersetzt keine tieraerztliche Diagnose - Hinweis ist im UI.
class SymptomCheckScreen extends ConsumerStatefulWidget {
  const SymptomCheckScreen({super.key});

  @override
  ConsumerState<SymptomCheckScreen> createState() => _SymptomCheckScreenState();
}

class _SymptomCheckScreenState extends ConsumerState<SymptomCheckScreen> {
  final Set<String> _selected = {};
  final _descController = TextEditingController();
  final _stt = SttService();
  bool _listening = false;
  bool _analyzed = false;

  @override
  void dispose() {
    _stt.stop();
    _descController.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
      _analyzed = false;
    });
  }

  void _reset() {
    setState(() {
      _selected.clear();
      _descController.clear();
      _analyzed = false;
    });
  }

  /// Startet/stoppt die Sprach-Eingabe fuer die Freitext-Beschreibung.
  Future<void> _toggleMic() async {
    if (_listening) {
      _stt.stop();
      setState(() => _listening = false);
      return;
    }
    if (!_stt.isAvailable) {
      final msg = _stt.isIosSafari
          ? 'Sprach-Eingabe wird auf iPhone/iPad (Safari) leider nicht '
              'unterstuetzt. Tippe deine Beschreibung bitte ein.'
          : 'Sprach-Eingabe braucht einen Chrome- oder Edge-Browser. '
              'Tippe deine Beschreibung sonst einfach ein.';
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    setState(() => _listening = true);
    try {
      final text = await _stt.listenOnce();
      if (text != null && text.trim().isNotEmpty) {
        final existing = _descController.text.trim();
        _descController.text =
            existing.isEmpty ? text.trim() : '$existing ${text.trim()}';
      }
    } catch (_) {
      // Stillschweigend - das UI bleibt nutzbar, Tippen geht weiter.
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  /// Uebergibt Symptome + Beschreibung an den KI-Berater und wechselt dorthin.
  void _discussWithAi(List<Diagnosis> results) {
    final labels = <String>[];
    for (final s in SymptomCatalog.all) {
      if (_selected.contains(s.id)) labels.add(s.label);
    }
    final desc = _descController.text.trim();

    final prompt = StringBuffer()
      ..writeln('Ich mache mir Sorgen um meinen Hund.');
    if (labels.isNotEmpty) {
      prompt
        ..writeln('Beobachtete Symptome:')
        ..writeln('- ${labels.join('\n- ')}');
    }
    if (desc.isNotEmpty) {
      prompt
        ..writeln()
        ..writeln('Meine Beschreibung: $desc');
    }
    if (results.isNotEmpty) {
      prompt
        ..writeln()
        ..writeln(
            'Erste App-Einschaetzung: ${results.first.title} '
            '(${results.first.urgency.label}).');
    }
    prompt
      ..writeln()
      ..write(
        'Was koennten die Ursachen sein, wie dringend ist es, und was sollte '
        'ich jetzt tun? Bitte sei ehrlich, wenn ich sofort zum Tierarzt '
        'sollte. Du ersetzt keine tieraerztliche Untersuchung.',
      );

    ref.read(assistantHandoffProvider.notifier).queue(
          AssistantHandoff(
            prompt: prompt.toString(),
            mode: ChatMode.advisor,
            origin: AppRoutes.symptomCheck,
          ),
        );
    context.go(AppRoutes.assistant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCategory = <SymptomCategory, List<Symptom>>{};
    for (final s in SymptomCatalog.all) {
      byCategory.putIfAbsent(s.category, () => []).add(s);
    }
    final results = _analyzed ? SymptomEngine.analyze(_selected) : <Diagnosis>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom-Check'),
        actions: [
          if (_selected.isNotEmpty)
            IconButton(
              tooltip: 'Zuruecksetzen',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _reset,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Disclaimer(theme: theme),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Was beobachtest du an deinem Hund?',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tippe alle Symptome an, die zutreffen. Mehrfach-Auswahl '
            'verbessert die Einschaetzung.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final cat in byCategory.keys)
            _CategoryBlock(
              category: cat,
              symptoms: byCategory[cat]!,
              selected: _selected,
              onToggle: _toggle,
              theme: theme,
            ),
          const SizedBox(height: AppSpacing.md),
          Text('In eigenen Worten (optional)',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Beschreibe per Mikrofon oder Tippen, was du beobachtest - das '
            'hilft der spaeteren KI-Einschaetzung.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _descController,
            maxLines: 3,
            minLines: 2,
            decoration: InputDecoration(
              hintText: _listening
                  ? 'Hoere zu ...'
                  : 'z.B. seit gestern Abend frisst er nicht und wirkt schlapp',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              suffixIcon: IconButton(
                tooltip: _listening ? 'Aufnahme stoppen' : 'Sprach-Eingabe',
                onPressed: _toggleMic,
                icon: Icon(
                  _listening
                      ? Icons.stop_circle_outlined
                      : Icons.mic_rounded,
                  color: _listening
                      ? Colors.redAccent
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _selected.isEmpty
                ? null
                : () => setState(() => _analyzed = true),
            icon: const Icon(Icons.health_and_safety_rounded),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                _selected.isEmpty
                    ? 'Bitte mindestens 1 Symptom waehlen'
                    : 'Auswertung starten (${_selected.length} Symptom${_selected.length == 1 ? '' : 'e'})',
              ),
            ),
          ),
          if (_analyzed) ...[
            const SizedBox(height: AppSpacing.xl),
            if (results.any((d) => d.urgency == Urgency.emergency)) ...[
              _EmergencyBox(theme: theme),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              'Moegliche Ursachen',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final d in results)
              _DiagnosisTile(diagnosis: d, theme: theme),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => _discussWithAi(results),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text('Mit dem KI-Berater besprechen'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Die KI bekommt deine Symptome und Beschreibung als Text. Sie '
              'kann keine Fotos oder Videos auswerten - dafuer bitte den '
              'Tierarzt aufsuchen.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _PhotoTipBox(theme: theme),
          ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.orange.shade800),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Dieser Check ersetzt keinen Tierarzt. Er hilft dir nur, '
              'die Dringlichkeit einzuschaetzen. Im Zweifel: lieber '
              'einmal mehr anrufen.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Auffaellige Notfall-Box. Erscheint, wenn mindestens eine Verdachts-
/// Diagnose als Notfall eingestuft wurde - sie soll zum sofortigen Handeln
/// auffordern, nennt aber bewusst keine erfundene Telefonnummer.
class _EmergencyBox extends StatelessWidget {
  const _EmergencyBox({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: Colors.red.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.crisis_alert_rounded, color: Colors.red),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moeglicher Notfall',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Mindestens ein Symptom kann auf einen Notfall hindeuten. '
                  'Warte nicht ab - rufe sofort deine Tierklinik oder den '
                  'tieraerztlichen Notdienst an und fahre im Zweifel direkt '
                  'hin. Halte das Alter, Gewicht und die Symptome bereit.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.symptoms,
    required this.selected,
    required this.onToggle,
    required this.theme,
  });

  final SymptomCategory category;
  final List<Symptom> symptoms;
  final Set<String> selected;
  final void Function(String id) onToggle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(category.label, style: theme.textTheme.titleSmall),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: symptoms.map((s) {
              final isSel = selected.contains(s.id);
              return FilterChip(
                label: Text(s.label),
                selected: isSel,
                onSelected: (_) => onToggle(s.id),
                selectedColor:
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _PhotoTipBox extends StatelessWidget {
  const _PhotoTipBox({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.photo_camera_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Tipp: Mach mit dem Handy ein Foto der Stelle / Symptome - '
              'das hilft dem Tierarzt enorm. Im KI-Berater kannst du das Foto '
              'hochladen und KI-Vorschlaege bekommen, sobald der KI-Proxy '
              'aktiv ist.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosisTile extends StatelessWidget {
  const _DiagnosisTile({required this.diagnosis, required this.theme});

  final Diagnosis diagnosis;
  final ThemeData theme;

  Color get _color {
    switch (diagnosis.urgency) {
      case Urgency.emergency:
        return Colors.red;
      case Urgency.urgent:
        return Colors.deepOrange;
      case Urgency.visit:
        return Colors.amber.shade800;
      case Urgency.routine:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (diagnosis.urgency) {
      case Urgency.emergency:
        return Icons.crisis_alert_rounded;
      case Urgency.urgent:
        return Icons.local_hospital_rounded;
      case Urgency.visit:
        return Icons.medical_services_rounded;
      case Urgency.routine:
        return Icons.visibility_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: _color.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, color: _color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    diagnosis.title,
                    style: theme.textTheme.titleMedium?.copyWith(color: _color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                diagnosis.urgency.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(diagnosis.description, style: theme.textTheme.bodyMedium),
            if (diagnosis.recommendation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: _color,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        diagnosis.recommendation,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
