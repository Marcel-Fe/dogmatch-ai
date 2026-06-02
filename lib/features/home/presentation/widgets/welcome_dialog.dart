import 'dart:convert';

import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/home/domain/hourly_quote.dart';
import 'package:dogmatch_ai/features/home/domain/time_of_day_greeting.dart';
import 'package:flutter/material.dart';

/// Begruessungs-Popup beim App-Start (Familien-App-Stil): Foto + Name des
/// aktiven Hundes, persoenliche Anrede mit Profilnamen und ein stuendlich
/// wechselnder Hundespruch. Warm gestaltet, ein Tipp und es ist weg.
Future<void> showWelcomeDialog(
  BuildContext context, {
  Dog? dog,
  String? userName,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _WelcomeDialog(dog: dog, userName: userName),
  );
}

class _WelcomeDialog extends StatelessWidget {
  const _WelcomeDialog({this.dog, this.userName});

  final Dog? dog;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greet = TimeOfDayGreeting.forNow();
    final quote = HourlyQuote.currentWisdom();
    final hello = (userName != null && userName!.trim().isNotEmpty)
        ? '${greet.salutation}, ${userName!.trim()}!'
        : '${greet.salutation}!';
    final sub = dog != null
        ? 'Schoen, dass ${dog!.name} und du wieder da seid.'
        : 'Schoen, dass du wieder da bist.';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 92,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Icon(Icons.pets_rounded,
                          color: Colors.white24, size: 40),
                    ),
                  ),
                ),
                Positioned(bottom: -44, child: _Avatar(dog: dog)),
              ],
            ),
            const SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  Text(
                    hello,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    sub,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.format_quote_rounded,
                            color: AppColors.primary, size: 32),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Wichtig zu wissen',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          quote.text,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                        if (quote.author != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '— ${quote.author!}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.pets_rounded),
                      label: const Text('Los geht\'s'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.dog});

  final Dog? dog;

  @override
  Widget build(BuildContext context) {
    Widget inner = _paw();
    final raw = dog?.photoBase64;
    if (raw != null && raw.isNotEmpty) {
      try {
        final b64 = raw.contains(',') ? raw.split(',').last : raw;
        inner = Image.memory(
          base64Decode(b64),
          width: 88,
          height: 88,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheWidth: 180,
          errorBuilder: (_, _, _) => _paw(),
        );
      } catch (_) {
        inner = _paw();
      }
    }
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: SizedBox(width: 88, height: 88, child: inner),
      ),
    );
  }

  Widget _paw() {
    return Container(
      width: 88,
      height: 88,
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Icon(Icons.pets_rounded, color: AppColors.primary, size: 40),
    );
  }
}
