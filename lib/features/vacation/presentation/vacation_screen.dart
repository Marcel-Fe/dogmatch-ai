import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/vacation/data/travel_rules.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VacationScreen extends StatefulWidget {
  const VacationScreen({super.key});

  @override
  State<VacationScreen> createState() => _VacationScreenState();
}

class _VacationScreenState extends State<VacationScreen> {
  TravelRule? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Urlaub mit Hund')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.95),
                  theme.colorScheme.primary.withValues(alpha: 0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.luggage_rounded, color: Colors.white),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Reiseplaner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Waehle dein Reiseziel - du bekommst die wichtigsten '
                  'Regeln: Maulkorb, Leine, Tollwut, Pass, Listenhund-Status.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      context.push('${AppRoutes.checklists}/travel'),
                  icon: const Icon(Icons.checklist_rounded, size: 16),
                  label: const Text('Reise-Checkliste oeffnen'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Reiseziel', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final rule in TravelRules.all)
                ChoiceChip(
                  label: Text('${rule.flag}  ${rule.country}'),
                  selected: _selected == rule,
                  onSelected: (_) => setState(() => _selected = rule),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_selected == null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Text(
                  'Land waehlen, um die Regeln zu sehen.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          else ...[
            _RuleCard(
              icon: Icons.masks_rounded,
              color: Colors.orange.shade700,
              title: 'Maulkorb',
              body: _selected!.muzzleRule,
            ),
            _RuleCard(
              icon: Icons.link_rounded,
              color: Colors.blue.shade700,
              title: 'Leinenpflicht',
              body: _selected!.leashRule,
            ),
            _RuleCard(
              icon: Icons.vaccines_rounded,
              color: Colors.red.shade700,
              title: 'Tollwut & Impfungen',
              body: _selected!.rabiesRule,
            ),
            _RuleCard(
              icon: Icons.badge_rounded,
              color: Colors.purple.shade700,
              title: 'Heimtierausweis',
              body: _selected!.passportRule,
            ),
            _RuleCard(
              icon: Icons.gavel_rounded,
              color: Colors.brown.shade700,
              title: 'Listenhunde-Regeln',
              body: _selected!.listenhundRule,
            ),
            if (_selected!.transitNote != null)
              _RuleCard(
                icon: Icons.directions_boat_rounded,
                color: Colors.teal.shade700,
                title: 'Einreise / Transit',
                body: _selected!.transitNote!,
              ),
            if (_selected!.specialNote != null)
              _RuleCard(
                icon: Icons.info_rounded,
                color: theme.colorScheme.primary,
                title: 'Gut zu wissen',
                body: _selected!.specialNote!,
              ),
          ],
        ],
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(body, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
