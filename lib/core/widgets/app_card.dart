import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Wiederverwendbare Karte im Horizon-Stil: weisse Flaeche mit grossem Radius
/// und sehr weichem Schatten (im Dark-Mode dezenter Rand statt Schatten).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 40,
                  offset: Offset(0, 18),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}
