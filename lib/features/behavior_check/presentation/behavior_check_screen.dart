import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/stt_service.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/behavior_check/data/behavior_catalog.dart';
import 'package:dogmatch_ai/features/behavior_check/data/behavior_engine.dart';
import 'package:dogmatch_ai/features/behavior_check/domain/behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Verhaltens-Check. Nutzer waehlt auffaellige Verhaltensweisen, App
/// liefert Einschaetzung + Trainings-Empfehlung mit Verlinkung auf
/// vorhandene Trainings-Plaene.
class BehaviorCheckScreen extends ConsumerStatefulWidget {
  const BehaviorCheckScreen({super.key});

  @override
  ConsumerState<BehaviorCheckScreen> createState() =>
      _BehaviorCheckScreenState();
}

class _BehaviorCheckScreenState extends ConsumerState<BehaviorCheckScreen> {
  final Set<String> _selected = {};
  final _noteController = TextEditingController();
  final _stt = SttService();
  bool _listening = false;
  bool _analyzed = false;

  @override
  void dispose() {
    _stt.stop();
    _noteController.dispose();
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
      _noteController.clear();
      _analyzed = false;
    });
  }

  /// Diktat fuer das Freitext-Feld (gleiche Web-Speech-API wie im Chat).
  Future<void> _toggleMic() async {
    if (_listening) {
      _stt.stop();
      setState(() => _listening = false);
      return;
    }
    if (!_stt.isAvailable) {
      final msg = _stt.isIosSafari
          ? 'Apple unterstuetzt Sprach-Eingabe im iPhone-Safari nicht. '
              'Bitte tippe deine Beobachtung.'
          : 'Sprach-Eingabe ist in diesem Browser nicht unterstuetzt '
              '(Chrome / Edge nutzen).';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
      );
      return;
    }
    setState(() => _listening = true);
    try {
      final text = await _stt.listenOnce();
      if (!mounted) return;
      if (text != null && text.trim().isNotEmpty) {
        final existing = _noteController.text.trim();
        _noteController.text =
            existing.isEmpty ? text.trim() : '$existing ${text.trim()}';
        _noteController.selection = TextSelection.fromPosition(
          TextPosition(offset: _noteController.text.length),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  /// Baut einen deutschen Prompt aus den gewaehlten Verhaltensweisen +
  /// Top-Empfehlung und schickt den User zum KI-Trainer-Tab, der die
  /// Frage automatisch absendet.
  void _askAiTrainer(List<BehaviorAssessment> results) {
    final labels = <String>[];
    for (final b in BehaviorCatalog.all) {
      if (_selected.contains(b.id)) labels.add(b.label);
    }
    final topRecommendation =
        results.isNotEmpty ? results.first.recommendation : null;

    final prompt = StringBuffer()
      ..writeln('Mein Hund zeigt folgende Verhaltensweisen:')
      ..writeln('- ${labels.join('\n- ')}')
      ..writeln();
    final note = _noteController.text.trim();
    if (note.isNotEmpty) {
      prompt
        ..writeln('Meine eigene Beschreibung dazu: $note')
        ..writeln();
    }
    if (topRecommendation != null) {
      prompt
        ..writeln('Erste App-Einschaetzung: $topRecommendation')
        ..writeln();
    }
    prompt.write(
      'Wie kann ich konkret damit umgehen? Bitte gib mir 4-7 nummerierte '
      'Schritte mit positiver Bestaerkung.',
    );

    ref.read(assistantHandoffProvider.notifier).queue(
          AssistantHandoff(
            prompt: prompt.toString(),
            mode: ChatMode.trainer,
            origin: AppRoutes.behaviorCheck,
          ),
        );
    context.go(AppRoutes.assistant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCategory = <BehaviorCategory, List<Behavior>>{};
    for (final b in BehaviorCatalog.all) {
      byCategory.putIfAbsent(b.category, () => []).add(b);
    }
    final results =
        _analyzed ? BehaviorEngine.analyze(_selected) : <BehaviorAssessment>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verhalten-Check'),
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
            'Was zeigt dein Hund?',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tippe alle Verhaltensweisen an, die du beobachtest. '
            'Mehrfach-Auswahl verbessert die Einschaetzung.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final cat in byCategory.keys)
            _CategoryBlock(
              category: cat,
              behaviors: byCategory[cat]!,
              selected: _selected,
              onToggle: _toggle,
              theme: theme,
            ),
          const SizedBox(height: AppSpacing.md),

          // Freitext: eigenes Verhalten beschreiben (tippen oder diktieren).
          Text(
            'Eigene Beobachtung (optional)',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _noteController,
            minLines: 2,
            maxLines: 4,
            enabled: !_listening,
            decoration: InputDecoration(
              hintText: _listening
                  ? 'Hoere zu ...'
                  : 'Beschreibe das Verhalten in eigenen Worten - '
                      'z.B. wann und wie oft es auftritt.',
              filled: true,
              alignLabelWithHint: true,
              suffixIcon: IconButton(
                tooltip: _listening ? 'Aufnahme stoppen' : 'Diktieren',
                onPressed: _toggleMic,
                icon: Icon(
                  _listening ? Icons.stop_circle_outlined : Icons.mic_rounded,
                  color: _listening ? Colors.redAccent : theme.colorScheme.primary,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Builder(builder: (context) {
            final hasInput =
                _selected.isNotEmpty || _noteController.text.trim().isNotEmpty;
            return FilledButton.icon(
              onPressed:
                  hasInput ? () => setState(() => _analyzed = true) : null,
              icon: const Icon(Icons.psychology_alt_rounded),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  hasInput
                      ? 'Auswertung starten'
                      : 'Punkt waehlen oder Beobachtung schreiben',
                ),
              ),
            );
          }),
          if (_analyzed) ...[
            const SizedBox(height: AppSpacing.xl),
            if (results.isNotEmpty) ...[
              Text('Einschaetzung', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              for (final a in results)
                _AssessmentTile(assessment: a, theme: theme),
            ] else
              Text(
                'Deine Beschreibung ist notiert. Lass sie dir vom KI-Trainer '
                'persoenlich auswerten:',
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: AppSpacing.lg),
            _AskAiCard(
              onAskAi: () => _askAiTrainer(results),
              theme: theme,
            ),
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
              'Dieser Check ersetzt keinen Hundetrainer oder Tierarzt. '
              'Er hilft dir Verhalten einzuordnen + den richtigen ersten '
              'Schritt zu finden.',
              style: theme.textTheme.bodySmall,
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
    required this.behaviors,
    required this.selected,
    required this.onToggle,
    required this.theme,
  });

  final BehaviorCategory category;
  final List<Behavior> behaviors;
  final Set<String> selected;
  final void Function(String) onToggle;
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
            children: behaviors.map((b) {
              final isSel = selected.contains(b.id);
              return FilterChip(
                label: Text(b.label),
                selected: isSel,
                onSelected: (_) => onToggle(b.id),
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

/// Karte am Ende der Auswertung: "Hol dir eine persoenliche Trainer-Antwort
/// von der KI". Schickt die gewaehlten Verhalten + erste Empfehlung an den
/// Assistant-Tab.
class _AskAiCard extends StatelessWidget {
  const _AskAiCard({required this.onAskAi, required this.theme});

  final VoidCallback onAskAi;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.10),
            theme.colorScheme.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_toy_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Persoenliche Trainer-Antwort von der KI',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Die KI bekommt deine Auswahl als Kontext und schlaegt dir '
            'konkrete Trainings-Schritte vor.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onAskAi,
            icon: const Icon(Icons.psychology_rounded),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Text('Mit KI-Trainer besprechen'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentTile extends StatelessWidget {
  const _AssessmentTile({required this.assessment, required this.theme});

  final BehaviorAssessment assessment;
  final ThemeData theme;

  Color get _color {
    switch (assessment.priority) {
      case BehaviorPriority.vet:
        return Colors.red;
      case BehaviorPriority.professional:
        return Colors.deepOrange;
      case BehaviorPriority.focused:
        return Colors.amber.shade800;
      case BehaviorPriority.routine:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (assessment.priority) {
      case BehaviorPriority.vet:
        return Icons.local_hospital_rounded;
      case BehaviorPriority.professional:
        return Icons.support_agent_rounded;
      case BehaviorPriority.focused:
        return Icons.school_rounded;
      case BehaviorPriority.routine:
        return Icons.self_improvement_rounded;
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
                    assessment.title,
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
                assessment.priority.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(assessment.description, style: theme.textTheme.bodyMedium),
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
                      assessment.recommendation,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            if (assessment.trainingPlanId != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonalIcon(
                onPressed: () => context.push(
                  '${AppRoutes.training}/${assessment.trainingPlanId}',
                ),
                icon: const Icon(Icons.school_rounded, size: 18),
                label: const Text('Zum passenden Trainingsplan'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
