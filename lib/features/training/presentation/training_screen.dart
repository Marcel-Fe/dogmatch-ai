import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/premium/presentation/premium_controller.dart';
import 'package:dogmatch_ai/features/training/domain/training_plan.dart';
import 'package:dogmatch_ai/features/training/domain/training_progress.dart';
import 'package:dogmatch_ai/features/training/presentation/training_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Liste aller Trainingsplaene mit Fortschritts-Anzeige.
class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(trainingPlansProvider);
    final progressAsync = ref.watch(trainingProgressProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (plans) {
          final progress = progressAsync.value ?? const {};
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Strukturierte Trainingsplaene fuer dich und deinen Hund. '
                'Hak einzelne Schritte ab und behalte den Ueberblick.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Schnelle Trainings-Tipps',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _QuickTipsRow(),
              const SizedBox(height: AppSpacing.lg),
              _HelpBox(theme: theme),
              const SizedBox(height: AppSpacing.lg),
              Text('Alle Plaene', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final plan in plans)
                _PlanTile(
                  plan: plan,
                  progress: progress[plan.id],
                  isPremium: isPremium,
                  theme: theme,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.progress,
    required this.isPremium,
    required this.theme,
  });

  final TrainingPlan plan;
  final TrainingProgress? progress;
  final bool isPremium;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final locked = plan.isPremium && !isPremium;
    final completedCount = progress?.completedCount ?? 0;
    final totalSteps = plan.steps.length;
    final pct = totalSteps == 0 ? 0.0 : completedCount / totalSteps;
    final isDone = completedCount == totalSteps && totalSteps > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () {
          if (locked) {
            _showLocked(context);
            return;
          }
          context.push('${AppRoutes.training}/${plan.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isDone
                  ? Colors.green.withValues(alpha: 0.5)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _iconFor(plan.icon),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.title,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        if (locked)
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: Colors.amber.shade700,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      plan.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _Chip(
                          label: plan.difficulty.label,
                          theme: theme,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _Chip(
                          label: '${plan.estimatedDays} Tage',
                          theme: theme,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _Chip(
                          label: '$completedCount/$totalSteps',
                          theme: theme,
                          highlight: isDone,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusPill),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation(
                          isDone ? Colors.green : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocked(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Premium-Trainingsplan'),
        content: const Text(
          'Dieser Trainingsplan ist Premium-Mitgliedern vorbehalten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Spaeter'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push(AppRoutes.premium);
            },
            child: const Text('Mehr erfahren'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.theme, this.highlight = false});

  final String label;
  final ThemeData theme;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? Colors.green : theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

/// Horizontale Karten-Reihe mit Schnell-Tipps. Lebt direkt im Code, weil
/// es weder Persistenz noch i18n braucht. Jede Karte ist eine kleine
/// Trainings-Wahrheit, die der Nutzer in 10 Sekunden lesen kann.
class _QuickTipsRow extends StatelessWidget {
  const _QuickTipsRow();

  static const _tips = <_QuickTip>[
    _QuickTip(
      icon: Icons.timer_outlined,
      title: 'Kurze Einheiten',
      body: '3-5 Minuten am Stueck, mehrmals taeglich. '
          'Lange Sessions ermueden und frustrieren.',
    ),
    _QuickTip(
      icon: Icons.flash_on_rounded,
      title: '1-2 Sekunden-Fenster',
      body: 'Belohne sofort - sonst lernt der Hund das Falsche.',
    ),
    _QuickTip(
      icon: Icons.workspace_premium_outlined,
      title: 'Jackpot bei Top-Leistung',
      body: '3-5 kleine Leckerli hintereinander - der Hund denkt: "Wow".',
    ),
    _QuickTip(
      icon: Icons.psychology_outlined,
      title: 'Konsistenz schlaegt Strenge',
      body: 'Alle im Haushalt: gleiches Signalwort, gleicher Ton.',
    ),
    _QuickTip(
      icon: Icons.celebration_outlined,
      title: 'Mit Erfolg aufhoeren',
      body: 'Beende das Training mit einer gelungenen Uebung - '
          'so bleibt die Motivation hoch.',
    ),
    _QuickTip(
      icon: Icons.do_not_touch_outlined,
      title: 'Niemals strafen',
      body: 'Strafe erzeugt Angst, nicht Lernen. Verhalten umlenken, '
          'Alternative anbieten, Alternative belohnen.',
    ),
    _QuickTip(
      icon: Icons.directions_run_rounded,
      title: 'Erst Auspowern, dann Lernen',
      body: 'Ein ueberdrehter Hund kann nicht denken - kurzer Spaziergang '
          'oder Nasenspiel vor der Trainingseinheit.',
    ),
    _QuickTip(
      icon: Icons.location_on_outlined,
      title: 'Generalisieren ueben',
      body: 'Kommandos in 5 verschiedenen Raeumen / Orten ueben - '
          'sonst funktioniert "Sitz" nur in der Kueche.',
    ),
    _QuickTip(
      icon: Icons.volume_down_outlined,
      title: 'Leise sprechen',
      body: 'Hunde reagieren auf Klang. Ruhige Stimme = Aufmerksamkeit, '
          'laute Stimme = Stress.',
    ),
    _QuickTip(
      icon: Icons.psychology_alt_outlined,
      title: 'Frust = Pause',
      body: 'Wenn DU genervt bist: aufhoeren. Hunde spueren das sofort - '
          'die naechste Einheit wird besser.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) => _QuickTipCard(tip: _tips[i]),
      ),
    );
  }
}

class _QuickTip {
  const _QuickTip({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
}

class _QuickTipCard extends StatelessWidget {
  const _QuickTipCard({required this.tip});
  final _QuickTip tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(tip.icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            tip.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              tip.body,
              style: theme.textTheme.bodySmall,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpBox extends StatelessWidget {
  const _HelpBox({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'So funktioniert es',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _HelpItem(
            theme: theme,
            text: 'Waehle einen Plan, der zu deinem Hund passt - '
                'Anfaenger zuerst, danach Fortgeschritten/Profi.',
          ),
          _HelpItem(
            theme: theme,
            text: 'Tippe einen Schritt an, um ihn als erledigt zu '
                'markieren - der Fortschrittsbalken passt sich an.',
          ),
          _HelpItem(
            theme: theme,
            text: 'Ueb jeden Schritt 2-3 Tage in kurzen 5-Minuten-Einheiten, '
                'mehrfach am Tag, bevor du zum naechsten gehst.',
          ),
          _HelpItem(
            theme: theme,
            text: 'Belohne sofort (innerhalb 1 Sekunde) - kleine '
                'Leckerli oder Lob, je nach Hund.',
          ),
          _HelpItem(
            theme: theme,
            text: 'Bei Frust oder Ueberforderung: einen Schritt '
                'zurueck und nochmal festigen.',
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  const _HelpItem({required this.theme, required this.text});

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String key) {
  switch (key) {
    case 'school':
      return Icons.school_rounded;
    case 'self_improvement':
      return Icons.self_improvement_rounded;
    case 'directions_walk':
      return Icons.directions_walk_rounded;
    case 'campaign':
      return Icons.campaign_rounded;
    case 'back_hand':
      return Icons.back_hand_rounded;
    case 'pause_circle':
      return Icons.pause_circle_rounded;
    case 'trending_flat':
      return Icons.trending_flat_rounded;
    case 'bed':
      return Icons.bed_rounded;
    default:
      return Icons.pets_rounded;
  }
}
