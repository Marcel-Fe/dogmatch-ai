import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Portionsrechner fuer Leckerli (#7). Faustregel: Leckerli duerfen max.
/// ~10 % des taeglichen Energiebedarfs ausmachen. Wir schaetzen den
/// Tagesbedarf grob ueber das Gewicht und zeigen ein sinnvolles
/// Leckerli-Budget in kcal + ungefaehrer Stueckzahl.
class PortionCalculator extends StatefulWidget {
  const PortionCalculator({super.key});

  @override
  State<PortionCalculator> createState() => _PortionCalculatorState();
}

class _PortionCalculatorState extends State<PortionCalculator> {
  double _weightKg = 15;
  bool _expanded = false;

  // Grobe Schaetzung Tages-Energiebedarf erwachsener, normal aktiver Hund:
  // RER = 70 * kg^0.75, MER ~ 1.6 * RER. Wir nutzen eine einfache, robuste
  // Naeherung ohne pow-Import: linear interpoliert ist fuer den Zweck genug.
  int get _dailyKcal {
    // Naeherung an MER fuer normal aktive Hunde.
    final rer = 70 * _pow075(_weightKg);
    return (rer * 1.6).round();
  }

  int get _treatKcal => (_dailyKcal * 0.10).round();

  // Ein durchschnittliches selbstgemachtes Mini-Leckerli ~ 5 kcal.
  int get _treatPieces => (_treatKcal / 5).round();

  static double _pow075(double x) {
    // x^0.75 = sqrt(x) * sqrt(sqrt(x)) - ohne dart:math-Import.
    final s = _sqrt(x);
    return s * _sqrt(s);
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    var g = x;
    for (var i = 0; i < 20; i++) {
      g = (g + x / g) / 2;
    }
    return g;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.calculate_rounded,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Portionsrechner: Wie viele Leckerli sind ok?',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Icon(_expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gewicht deines Hundes: ${_weightKg.round()} kg',
                      style: theme.textTheme.bodyMedium),
                  Slider(
                    value: _weightKg,
                    min: 2,
                    max: 80,
                    divisions: 78,
                    label: '${_weightKg.round()} kg',
                    onChanged: (v) => setState(() => _weightKg = v),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _resultLine(theme, 'Tagesbedarf (ca.)', '$_dailyKcal kcal'),
                  _resultLine(theme, 'Leckerli-Budget (10 %)',
                      '$_treatKcal kcal'),
                  _resultLine(theme, 'Das sind grob',
                      '$_treatPieces Mini-Leckerli/Tag'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Richtwerte fuer einen normal aktiven, erwachsenen Hund. '
                    'Welpen, Senioren und kranke Hunde brauchen andere Mengen - '
                    'im Zweifel den Tierarzt fragen.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _resultLine(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              )),
        ],
      ),
    );
  }
}
