import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/anatomy/domain/anatomy_part.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Anatomie-Nachschlagewerk: ein beschriftetes Schaubild des Hundes plus eine
/// Liste der wichtigsten Begriffe mit Tierarzt-Erklaerung. Hilft Haltern zu
/// verstehen, was der Tierarzt meint (z.B. Widerrist, Sprunggelenk, Rute).
class AnatomyScreen extends StatelessWidget {
  const AnatomyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = AnatomyCatalog.all;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hunde-Anatomie'),
        // Garantierter Zurueck-Weg: poppen wenn moeglich, sonst aufs
        // Dashboard - so steht der Nutzer nie ohne Ausweg da.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Zurueck',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _IntroCard(theme: theme),
          const SizedBox(height: AppSpacing.lg),
          _DiagramCard(parts: parts),
          const SizedBox(height: AppSpacing.xl),
          for (final region in AnatomyRegion.values) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.sm,
              ),
              child: Text(region.label, style: theme.textTheme.titleLarge),
            ),
            for (final p in parts.where((e) => e.region == region))
              _PartCard(part: p, theme: theme),
            const SizedBox(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Damit du beim Tierarzt sofort weisst, was gemeint ist: Tippe '
              'die Zahlen im Bild in der Liste darunter nach. So findest du '
              'jeden Begriff am Hund wieder.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagramCard extends StatelessWidget {
  const _DiagramCard({required this.parts});

  final List<AnatomyPart> parts;

  // Seitenverhaeltnis des Fotos (560 x 462).
  static const double _ratio = 560 / 462;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: AspectRatio(
              aspectRatio: _ratio,
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final h = c.maxHeight;
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/anatomy/dog_side.jpg',
                        fit: BoxFit.cover,
                        cacheWidth: (w * dpr).round(),
                      ),
                      for (final p in parts)
                        Positioned(
                          left: p.pos.dx * w - _kMarker / 2,
                          top: p.pos.dy * h - _kMarker / 2,
                          child: _Marker(number: p.number),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Foto: Wikimedia Commons',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const double _kMarker = 26;

/// Nummerierter Marker auf dem Foto - kraeftiges Indigo mit weisser Ziffer
/// und weissem Ring, damit er auf jedem Fell-/Hintergrund gut lesbar ist.
class _Marker extends StatelessWidget {
  const _Marker({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kMarker,
      height: _kMarker,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _PartCard extends StatelessWidget {
  const _PartCard({required this.part, required this.theme});

  final AnatomyPart part;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${part.number}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(part.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                _Line(label: 'Wo', text: part.where, theme: theme),
                const SizedBox(height: 2),
                _Line(label: 'Arzt', text: part.vetNote, theme: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.text, required this.theme});

  final String label;
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
