import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reihe aus runden, bunten Schnellzugriffen (Look "Bunt"/Bild 8): grosses
/// Foto darueber, darunter farbige Kreis-Buttons. Tap fuehrt direkt zum Ziel.
class RoundActionRow extends StatelessWidget {
  const RoundActionRow({super.key});

  static const _items = <_RoundItem>[
    _RoundItem(Icons.pets_rounded, 'Rassen', Color(0xFF7551FF),
        AppRoutes.breedList),
    _RoundItem(Icons.school_rounded, 'Trainer', Color(0xFF01B574),
        AppRoutes.assistant),
    _RoundItem(Icons.psychology_rounded, 'Verhalten', Color(0xFFFF8A3D),
        AppRoutes.behaviorCheck),
    _RoundItem(Icons.event_rounded, 'Termine', Color(0xFF2F80ED),
        AppRoutes.healthCalendar),
    _RoundItem(Icons.folder_shared_rounded, 'Akte', Color(0xFFFF5E8A),
        AppRoutes.dogRecord),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [for (final it in _items) _RoundButton(item: it)],
    );
  }
}

class _RoundItem {
  const _RoundItem(this.icon, this.label, this.color, this.route);

  final IconData icon;
  final String label;
  final Color color;
  final String route;
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.item});

  final _RoundItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () => context.push(item.route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color,
                  Color.lerp(item.color, Colors.black, 0.22)!,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.40),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(item.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
