import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:flutter/material.dart';

/// Wiederverwendbarer Hintergrund-Layer fuer die Startseite (und optional
/// weitere Hub-Screens). Kombiniert den gewaehlten [DashboardBackground] mit
/// dem [seed] des Dashboard-Designs, sodass sich der Hintergrund mit dem Stil
/// mitfaerbt.
///
/// Bewusst leichtgewichtig: kein Vollbild-Blur/[BackdropFilter] (iPhone-/
/// CanvasKit-Performance), keine dauerhaften Animationen. Die Toenung ist sehr
/// dezent, damit Text (der auf Karten-Surfaces liegt) in Hell, Dunkel UND
/// Senioren-Modus gut lesbar bleibt.
///
/// Wird typischerweise unter den Inhalt gelegt:
/// `Stack(children: [Positioned.fill(child: AppBackground(...)), content])`.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.background,
    required this.seed,
  });

  final DashboardBackground background;
  final Color seed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final base = theme.scaffoldBackgroundColor;

    switch (background) {
      case DashboardBackground.plain:
        // Neutraler Hintergrund - der Scaffold faerbt selbst.
        return const SizedBox.shrink();
      case DashboardBackground.gradient:
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.lerp(base, seed, isDark ? 0.22 : 0.12)!, base],
              stops: const [0.0, 0.55],
            ),
          ),
        );
      case DashboardBackground.mesh:
        return _MeshLayer(seed: seed, isDark: isDark);
      case DashboardBackground.paws:
        return CustomPaint(
          painter: _PawsPainter(
            color: seed.withValues(alpha: isDark ? 0.10 : 0.06),
          ),
        );
    }
  }
}

/// Weiche Farbkreise ("Blobs"). Die [RadialGradient] verlaufen nach aussen in
/// Transparenz - das ergibt einen weichen Look OHNE teuren Blur-Filter. Die
/// Kreise ragen bewusst ueber den Rand hinaus (negative Offsets).
class _MeshLayer extends StatelessWidget {
  const _MeshLayer({required this.seed, required this.isDark});

  final Color seed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final a1 = isDark ? 0.26 : 0.15;
    final a2 = isDark ? 0.20 : 0.11;
    return Stack(
      children: [
        Positioned(top: -80, right: -60, child: _blob(280, a1)),
        Positioned(top: 220, left: -100, child: _blob(240, a2)),
        Positioned(bottom: -110, right: -50, child: _blob(260, a2)),
      ],
    );
  }

  Widget _blob(double size, double alpha) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          seed.withValues(alpha: alpha),
          seed.withValues(alpha: 0),
        ],
      ),
    ),
  );
}

/// Statisches Pfoten-Muster, einmal gezeichnet (kein dauerhaftes Repaint). Die
/// Pfote ist das Material-Icon-Glyph, versetzt gekachelt und leicht gedreht.
class _PawsPainter extends CustomPainter {
  _PawsPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final glyph = String.fromCharCode(Icons.pets_rounded.codePoint);
    final tp = TextPainter(
      text: TextSpan(
        text: glyph,
        style: TextStyle(
          fontSize: 34,
          fontFamily: Icons.pets_rounded.fontFamily,
          package: Icons.pets_rounded.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const stepX = 104.0;
    const stepY = 104.0;
    var row = 0;
    for (double y = 16; y < size.height; y += stepY) {
      final offsetX = row.isEven ? 0.0 : stepX / 2;
      for (double x = 8 + offsetX; x < size.width; x += stepX) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-0.32);
        tp.paint(canvas, Offset.zero);
        canvas.restore();
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(_PawsPainter oldDelegate) => oldDelegate.color != color;
}
