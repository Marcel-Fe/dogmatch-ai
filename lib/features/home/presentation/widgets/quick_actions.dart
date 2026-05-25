import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fuenf farbig akzentuierte Quick-Action-Karten - generische Aktionen,
/// die zu jedem Hundealltag passen.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_Action>[
      _Action(
        icon: Icons.directions_walk_rounded,
        label: 'Spaziergang',
        hint: '30-60 Min taeglich',
        color: Colors.blue,
        onTap: () => _showInfo(
          context,
          title: 'Spaziergang heute',
          body:
              'Plane mindestens einen laengeren Spaziergang ein. Wechsele '
              'gelegentlich die Route - neue Geruechen ermueden geistig '
              'staerker als gleiche Strecken.',
        ),
      ),
      _Action(
        icon: Icons.water_drop_outlined,
        label: 'Trinken',
        hint: 'Wasser auffuellen',
        color: Colors.teal,
        onTap: () => _showInfo(
          context,
          title: 'Frisches Wasser',
          body:
              'Faustregel: 40-60 ml pro kg Koerpergewicht und Tag. Im Sommer '
              'oder bei Aktivitaet deutlich mehr - Napf 1-2x taeglich '
              'frisch befuellen.',
        ),
      ),
      _Action(
        icon: Icons.brush_outlined,
        label: 'Pflege',
        hint: 'Fell + Krallen',
        color: Colors.orange,
        onTap: () => _showInfo(
          context,
          title: 'Pflege-Routine',
          body:
              'Kurzes Fell: 1x/Woche buersten. Langes Fell: 2-3x/Woche. '
              'Krallen kontrollieren: klicken sie beim Gehen, sind sie '
              'zu lang. Zaehne wenn moeglich taeglich.',
        ),
      ),
      _Action(
        icon: Icons.school_outlined,
        label: 'Training',
        hint: '5 Min reichen',
        color: Colors.purple,
        onTap: () => context.push(AppRoutes.assistant),
      ),
      _Action(
        icon: Icons.lightbulb_outline_rounded,
        label: 'Tipp lesen',
        hint: 'Wissens-Spruch',
        color: Colors.amber.shade700,
        onTap: () => _showInfo(
          context,
          title: 'Tipp des Augenblicks',
          body:
              'Der Wissens-Spruch oben aendert sich stuendlich. Schau immer '
              'mal wieder rein - so sammelst du im Laufe der Tage ein '
              'breites Wissen ueber Verhalten, Pflege und Training.',
        ),
      ),
    ];

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => _ActionCard(action: actions[i]),
      ),
    );
  }

  void _showInfo(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _Action {
  _Action({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  final VoidCallback onTap;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _Action action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 128,
      child: AppCard(
        onTap: action.onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(action.icon, color: action.color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.label,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  action.hint,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
