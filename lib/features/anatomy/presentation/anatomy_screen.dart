import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/anatomy/domain/anatomy_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:go_router/go_router.dart';

/// Anatomie-Nachschlagewerk: ein beschriftetes Schaubild des Hundes plus eine
/// Liste der wichtigsten Begriffe mit Tierarzt-Erklaerung. Hilft Haltern zu
/// verstehen, was der Tierarzt meint (z.B. Widerrist, Sprunggelenk, Rute).
///
/// Interaktiv: Tippt man im Bild auf einen Punkt (oder dessen Beschriftung),
/// springt die Liste zum passenden Eintrag und hebt ihn hervor.
class AnatomyScreen extends StatefulWidget {
  const AnatomyScreen({super.key});

  @override
  State<AnatomyScreen> createState() => _AnatomyScreenState();
}

class _AnatomyScreenState extends State<AnatomyScreen> {
  final _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};

  /// Nummer des aktuell hervorgehobenen Begriffs (per Bild-Tipp gewaehlt).
  int? _selected;

  GlobalKey _keyFor(int number) =>
      _cardKeys.putIfAbsent(number, () => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Tipp auf einen Marker im Bild: Begriff hervorheben und zur passenden
  /// Karte scrollen.
  void _selectPart(int number) {
    setState(() => _selected = number);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _cardKeys[number]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.12,
      );
    });
  }

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
        controller: _scrollController,
        // Grosszuegiger Cache, damit alle Karten gebaut sind und das
        // Scrollen-zur-Karte (ensureVisible) immer einen Kontext findet.
        scrollCacheExtent: ScrollCacheExtent.pixels(4000),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _IntroCard(theme: theme),
          const SizedBox(height: AppSpacing.lg),
          _DiagramCard(
            parts: parts,
            selected: _selected,
            onSelect: _selectPart,
          ),
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
              _PartCard(
                key: _keyFor(p.number),
                part: p,
                theme: theme,
                highlighted: _selected == p.number,
              ),
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
          Icon(Icons.touch_app_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Tippe im Bild auf einen Punkt oder Begriff - die Liste springt '
              'dann zur passenden Erklaerung. Zum Vergroessern das Bild mit '
              'zwei Fingern zoomen.',
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

enum _Align { left, right, center }

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

/// Fertig berechnete Platzierung eines Begriffs auf der Tafel. Wird von
/// EINER Stelle erzeugt und sowohl vom Painter (Zeichnen) als auch von der
/// Tipp-Erkennung genutzt - so koennen sie nie auseinanderdriften.
class _Placed {
  const _Placed({
    required this.part,
    required this.dot,
    required this.from,
    required this.labelAnchor,
    required this.align,
    required this.maxW,
  });

  final AnatomyPart part;

  /// Punkt am Skelett (Linienziel).
  final Offset dot;

  /// Startpunkt der Verbindungslinie am Bildrand.
  final Offset from;

  /// Ankerpunkt der Beschriftung.
  final Offset labelAnchor;
  final _Align align;
  final double maxW;
}

/// Berechnet die Platzierung aller Begriffe fuer eine Tafel der Groesse w x h.
List<_Placed> _placeLabels(List<AnatomyPart> parts, double w, double h) {
  final pl = 0.20 * w, pt = 0.12 * h, pw = 0.60 * w, ph = 0.74 * h;
  final pr = pl + pw, pb = pt + ph;
  Offset target(AnatomyPart p) =>
      Offset(pl + p.pos.dx * pw, pt + p.pos.dy * ph);
  List<AnatomyPart> on(_Side s) =>
      parts.where((p) => _sideOf[p.number] == s).toList();

  final out = <_Placed>[];

  final left = on(_Side.left)
    ..sort((a, b) => target(a).dy.compareTo(target(b).dy));
  for (var i = 0; i < left.length; i++) {
    final y = pt + (i + 0.5) / left.length * ph;
    out.add(_Placed(
      part: left[i],
      dot: target(left[i]),
      from: Offset(pl - 6, y),
      labelAnchor: Offset(pl - 10, y),
      align: _Align.right,
      maxW: pl - 16,
    ));
  }

  final right = on(_Side.right)
    ..sort((a, b) => target(a).dy.compareTo(target(b).dy));
  for (var i = 0; i < right.length; i++) {
    final y = pt + (i + 0.5) / right.length * ph;
    out.add(_Placed(
      part: right[i],
      dot: target(right[i]),
      from: Offset(pr + 6, y),
      labelAnchor: Offset(pr + 10, y),
      align: _Align.left,
      maxW: w - pr - 16,
    ));
  }

  final top = on(_Side.top)
    ..sort((a, b) => target(a).dx.compareTo(target(b).dx));
  for (var i = 0; i < top.length; i++) {
    final x = pl + (i + 0.5) / top.length * pw;
    out.add(_Placed(
      part: top[i],
      dot: target(top[i]),
      from: Offset(x, pt - 6),
      labelAnchor: Offset(x, pt * 0.5),
      align: _Align.center,
      maxW: pw / top.length - 4,
    ));
  }

  final bottom = on(_Side.bottom)
    ..sort((a, b) => target(a).dx.compareTo(target(b).dx));
  for (var i = 0; i < bottom.length; i++) {
    final x = pl + (i + 0.5) / bottom.length * pw;
    out.add(_Placed(
      part: bottom[i],
      dot: target(bottom[i]),
      from: Offset(x, pb + 6),
      labelAnchor: Offset(x, pb + (h - pb) * 0.5),
      align: _Align.center,
      maxW: pw / bottom.length - 4,
    ));
  }

  return out;
}

class _DiagramCard extends StatelessWidget {
  const _DiagramCard({
    required this.parts,
    required this.selected,
    required this.onSelect,
  });

  final List<AnatomyPart> parts;
  final int? selected;
  final ValueChanged<int> onSelect;

  // Gesamt-Seitenverhaeltnis der Tafel (Skelett in der Mitte + Label-Raender).
  // So gewaehlt, dass der Bildbereich exakt das Skelett-Seitenverhaeltnis
  // (1.384) trifft: (0.60/0.74)*1.707 = 1.384.
  static const double _ratio = 1.707;

  /// Findet den naechstgelegenen Begriff zu einem Tipp-Punkt. Beruecksichtigt
  /// sowohl den Marker-Punkt als auch die Beschriftung; null, wenn nichts in
  /// Reichweite liegt.
  int? _hitTest(Offset local, double w, double h) {
    final placed = _placeLabels(parts, w, h);
    final threshold = w * 0.13;
    double best = double.infinity;
    int? hit;
    for (final p in placed) {
      final d = (p.dot - local).distance < (p.labelAnchor - local).distance
          ? (p.dot - local).distance
          : (p.labelAnchor - local).distance;
      if (d < best) {
        best = d;
        hit = p.part.number;
      }
    }
    return best <= threshold ? hit : null;
  }

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
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (d) {
                      final hit = _hitTest(d.localPosition, w, h);
                      if (hit != null) onSelect(hit);
                    },
                    child: SizedBox(
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
                                selected: selected,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  'Tippe auf einen Punkt - oder zoome mit zwei Fingern',
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
/// jeweilige Stelle am Hund. Der ausgewaehlte Begriff wird hervorgehoben.
class _LabelPainter extends CustomPainter {
  _LabelPainter({
    required this.parts,
    required this.textColor,
    required this.selected,
  });

  final List<AnatomyPart> parts;
  final Color textColor;
  final int? selected;

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
    final w = size.width;
    final fontSize = (w * 0.030).clamp(8.5, 14.0);
    final line = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.85)
      ..strokeWidth = (w * 0.004).clamp(1.0, 2.0)
      ..isAntiAlias = true;
    final lineSel = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = (w * 0.006).clamp(1.5, 3.0)
      ..isAntiAlias = true;
    final dotFill = Paint()..color = AppColors.primary;
    final dotFillSel = Paint()..color = AppColors.primaryDark;
    final dotRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.005).clamp(1.0, 2.0);
    final dotR = (w * 0.009).clamp(2.5, 5.0);

    void label(String text, Offset anchor, _Align align, double maxW,
        bool isSel) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: isSel ? AppColors.primaryDark : textColor,
            fontSize: isSel ? fontSize + 1 : fontSize,
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

    for (final p in _placeLabels(parts, w, size.height)) {
      final isSel = p.part.number == selected;
      canvas.drawLine(p.from, p.dot, isSel ? lineSel : line);
      final r = isSel ? dotR * 1.8 : dotR;
      canvas.drawCircle(p.dot, r, isSel ? dotFillSel : dotFill);
      canvas.drawCircle(p.dot, r, dotRing);
      label(_short(p.part.name), p.labelAnchor, p.align, p.maxW, isSel);
    }
  }

  @override
  bool shouldRepaint(covariant _LabelPainter old) =>
      old.parts != parts ||
      old.textColor != textColor ||
      old.selected != selected;
}

class _PartCard extends StatelessWidget {
  const _PartCard({
    super.key,
    required this.part,
    required this.theme,
    this.highlighted = false,
  });

  final AnatomyPart part;
  final ThemeData theme;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.10)
            : (isDark ? AppColors.darkSurface : Colors.white),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: highlighted
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: highlighted ? 2 : 1,
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
