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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: AspectRatio(
        aspectRatio: 1.6,
        child: CustomPaint(
          painter: _DogDiagramPainter(
            parts: parts,
            bodyColor: AppColors.primary.withValues(alpha: isDark ? 0.55 : 0.85),
          ),
        ),
      ),
    );
  }
}

/// Zeichnet einen stilisierten, nach links schauenden Hund (flaeche) und
/// setzt die nummerierten Marker aus dem Katalog darauf.
class _DogDiagramPainter extends CustomPainter {
  _DogDiagramPainter({required this.parts, required this.bodyColor});

  final List<AnatomyPart> parts;
  final Color bodyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Offset o(double fx, double fy) => Offset(fx * w, fy * h);
    Rect r(double l, double t, double rt, double b) =>
        Rect.fromLTRB(l * w, t * h, rt * w, b * h);
    final rad = Radius.circular(0.10 * h);
    final body = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Rumpf
    canvas.drawRRect(RRect.fromRectAndRadius(r(0.30, 0.34, 0.80, 0.64), rad),
        body);
    // Hals (Verbindung Kopf -> Rumpf)
    final neck = Path()
      ..moveTo(0.21 * w, 0.32 * h)
      ..lineTo(0.36 * w, 0.30 * h)
      ..lineTo(0.38 * w, 0.58 * h)
      ..lineTo(0.26 * w, 0.58 * h)
      ..close();
    canvas.drawPath(neck, body);
    // Kopf
    canvas.drawCircle(o(0.20, 0.38), 0.16 * h, body);
    // Fang / Schnauze
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.04, 0.46, 0.22, 0.60), Radius.circular(0.06 * h)),
        body);
    // Behang (Ohr) - haengt seitlich herunter
    final ear = Path()
      ..moveTo(0.24 * w, 0.26 * h)
      ..quadraticBezierTo(0.33 * w, 0.22 * h, 0.31 * w, 0.46 * h)
      ..quadraticBezierTo(0.26 * w, 0.42 * h, 0.24 * w, 0.26 * h)
      ..close();
    canvas.drawPath(ear, body);
    // Vorderbeine
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.34, 0.58, 0.42, 0.82), Radius.circular(0.04 * h)),
        body);
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.46, 0.58, 0.54, 0.82), Radius.circular(0.04 * h)),
        body);
    // Hinterbein - Keule + Unterschenkel
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.60, 0.46, 0.80, 0.70), Radius.circular(0.10 * h)),
        body);
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.62, 0.64, 0.70, 0.82), Radius.circular(0.04 * h)),
        body);
    canvas.drawRRect(
        RRect.fromRectAndRadius(r(0.72, 0.64, 0.80, 0.82), Radius.circular(0.04 * h)),
        body);
    // Rute (Schwanz)
    final tail = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.07 * h
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final tailPath = Path()
      ..moveTo(0.79 * w, 0.40 * h)
      ..quadraticBezierTo(0.93 * w, 0.40 * h, 0.90 * w, 0.24 * h);
    canvas.drawPath(tailPath, tail);

    // Marker
    final dotFill = Paint()..color = Colors.white;
    final dotBorder = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.012 * h;
    final dotR = 0.058 * h;
    for (final p in parts) {
      final c = Offset(p.pos.dx * w, p.pos.dy * h);
      canvas.drawCircle(c, dotR, dotFill);
      canvas.drawCircle(c, dotR, dotBorder);
      final tp = TextPainter(
        text: TextSpan(
          text: '${p.number}',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w800,
            fontSize: 0.072 * h,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DogDiagramPainter old) =>
      old.bodyColor != bodyColor || old.parts != parts;
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
