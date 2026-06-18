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
              'Die Knochen-Begriffe stehen direkt am Skelett. Zum Vergroessern '
              'das Bild mit zwei Fingern zoomen. Was jeder Begriff bedeutet, '
              'steht in der Liste darunter.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Auf welcher Seite des Bildes die Beschriftung sitzt.
enum _Side { left, top, right, bottom }

/// Ordnet jeden Begriff (per Nummer) einer Beschriftungsseite zu - so sitzen
/// die Labels rund ums Bild wie auf einem Anatomie-Poster.
const Map<int, _Side> _sideOf = {
  1: _Side.left, 2: _Side.left, 7: _Side.left, 8: _Side.left, 9: _Side.left,
  3: _Side.top, 4: _Side.top, 5: _Side.top, 14: _Side.top,
  6: _Side.right, 15: _Side.right, 16: _Side.right, 17: _Side.right,
  18: _Side.right, 19: _Side.right,
  10: _Side.bottom, 11: _Side.bottom, 12: _Side.bottom, 13: _Side.bottom,
  20: _Side.bottom,
};

class _DiagramCard extends StatelessWidget {
  const _DiagramCard({required this.parts});

  final List<AnatomyPart> parts;

  // Gesamt-Seitenverhaeltnis der Tafel (Skelett in der Mitte + Label-Raender).
  // So gewaehlt, dass der Bildbereich exakt das Skelett-Seitenverhaeltnis
  // (1.384) trifft: (0.60/0.74)*1.707 = 1.384.
  static const double _ratio = 1.707;

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
          AspectRatio(
            aspectRatio: _ratio,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final h = c.maxHeight;
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  // Bildbereich zentral, Raender bleiben fuer Labels frei.
                  final pl = 0.20 * w, pt = 0.12 * h;
                  final pw = 0.60 * w, ph = 0.74 * h;
                  return SizedBox(
                    width: w,
                    height: h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: pl,
                          top: pt,
                          width: pw,
                          height: ph,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            child: Image.asset(
                              'assets/anatomy/dog_skeleton.jpg',
                              fit: BoxFit.cover,
                              cacheWidth: (pw * dpr).round(),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _LabelPainter(
                              parts: parts,
                              textColor: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Zum Vergroessern mit zwei Fingern zoomen',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                'Foto: Wikimedia Commons',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Zeichnet die Verbindungslinien, Punkte und Begriffs-Beschriftungen rund um
/// das Foto - die Begriffe stehen am Rand und zeigen mit einer Linie auf die
/// jeweilige Stelle am Hund.
class _LabelPainter extends CustomPainter {
  _LabelPainter({required this.parts, required this.textColor});

  final List<AnatomyPart> parts;
  final Color textColor;

  // Kurzform fuers Bild (volle Erklaerung steht in der Liste).
  static const Map<String, String> _shortMap = {
    'Vorderfusswurzel': 'Fusswurzel',
    'Mittelfussknochen': 'Mittelfuss',
    'Schwanzwirbel': 'Schwanz',
    'Schultergelenk': 'Schulterg.',
    'Oberschenkel': 'Oberschenkel',
  };
  String _short(String n) {
    final base = n.split(' (').first.split(' & ').first;
    return _shortMap[base] ?? base;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final pl = 0.20 * w, pt = 0.12 * h, pw = 0.60 * w, ph = 0.74 * h;
    final pr = pl + pw, pb = pt + ph;
    Offset target(AnatomyPart p) =>
        Offset(pl + p.pos.dx * pw, pt + p.pos.dy * ph);

    final fontSize = (w * 0.030).clamp(8.5, 14.0);
    final line = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.85)
      ..strokeWidth = (w * 0.004).clamp(1.0, 2.0)
      ..isAntiAlias = true;
    final dotFill = Paint()..color = AppColors.primary;
    final dotRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.005).clamp(1.0, 2.0);
    final dotR = (w * 0.009).clamp(2.5, 5.0);

    void label(String text, Offset anchor, _Align align, double maxW) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        textAlign: align == _Align.right ? TextAlign.right : TextAlign.left,
        textDirection: TextDirection.ltr,
        maxLines: 3,
      )..layout(maxWidth: maxW);
      double dx;
      switch (align) {
        case _Align.left:
          dx = anchor.dx;
        case _Align.right:
          dx = anchor.dx - tp.width;
        case _Align.center:
          dx = anchor.dx - tp.width / 2;
      }
      tp.paint(canvas, Offset(dx, anchor.dy - tp.height / 2));
    }

    void drawLine(Offset from, AnatomyPart p) {
      final t = target(p);
      canvas.drawLine(from, t, line);
      canvas.drawCircle(t, dotR, dotFill);
      canvas.drawCircle(t, dotR, dotRing);
    }

    List<AnatomyPart> on(_Side s) =>
        parts.where((p) => _sideOf[p.number] == s).toList();

    // LEFT (nach dy sortiert)
    final left = on(_Side.left)..sort((a, b) => target(a).dy.compareTo(target(b).dy));
    for (var i = 0; i < left.length; i++) {
      final y = pt + (i + 0.5) / left.length * ph;
      drawLine(Offset(pl - 6, y), left[i]);
      label(_short(left[i].name), Offset(pl - 10, y), _Align.right, pl - 16);
    }
    // RIGHT
    final right = on(_Side.right)..sort((a, b) => target(a).dy.compareTo(target(b).dy));
    for (var i = 0; i < right.length; i++) {
      final y = pt + (i + 0.5) / right.length * ph;
      drawLine(Offset(pr + 6, y), right[i]);
      label(_short(right[i].name), Offset(pr + 10, y), _Align.left, w - pr - 16);
    }
    // TOP
    final top = on(_Side.top)..sort((a, b) => target(a).dx.compareTo(target(b).dx));
    for (var i = 0; i < top.length; i++) {
      final x = pl + (i + 0.5) / top.length * pw;
      drawLine(Offset(x, pt - 6), top[i]);
      label(_short(top[i].name), Offset(x, pt * 0.5), _Align.center, pw / top.length - 4);
    }
    // BOTTOM
    final bottom = on(_Side.bottom)..sort((a, b) => target(a).dx.compareTo(target(b).dx));
    for (var i = 0; i < bottom.length; i++) {
      final x = pl + (i + 0.5) / bottom.length * pw;
      drawLine(Offset(x, pb + 6), bottom[i]);
      label(_short(bottom[i].name), Offset(x, pb + (h - pb) * 0.5), _Align.center,
          pw / bottom.length - 4);
    }
  }

  @override
  bool shouldRepaint(covariant _LabelPainter old) =>
      old.parts != parts || old.textColor != textColor;
}

enum _Align { left, right, center }

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
