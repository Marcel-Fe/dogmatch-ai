import 'dart:convert';
import 'dart:typed_data';

import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:flutter/material.dart';

/// Eine Chat-Sprechblase. Nutzer-Nachrichten rechts in Lila, Assistent-
/// Nachrichten links auf neutralem Hintergrund.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatRole.user;

    final bubbleColor = isUser
        ? AppColors.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = isUser ? Colors.white : null;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSpacing.radiusMd),
            topRight: const Radius.circular(AppSpacing.radiusMd),
            bottomLeft: Radius.circular(isUser ? AppSpacing.radiusMd : 4),
            bottomRight: Radius.circular(isUser ? 4 : AppSpacing.radiusMd),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imageUrl != null) ...[
              _GeneratedImage(url: message.imageUrl!),
              const SizedBox(height: 8),
            ],
            Text(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Zeigt ein von der KI erzeugtes Bild in der Sprechblase. Laedt mit
/// cacheWidth (Safari-Speicherlimit), zeigt waehrend des Ladens einen
/// Platzhalter und bei Fehler eine freundliche Notiz statt eines Absturzes.
class _GeneratedImage extends StatelessWidget {
  const _GeneratedImage({required this.url});

  final String url;

  static const double _w = 280;
  static const double _h = 187;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: url.startsWith('data:')
          ? _buildMemory(context)
          : _buildNetwork(context),
    );
  }

  /// Bild aus einer base64-data-URL (Worker/Gemini). cacheWidth schuetzt vor
  /// dem Safari-Speicherlimit.
  Widget _buildMemory(BuildContext context) {
    Uint8List? bytes;
    try {
      final idx = url.indexOf(',');
      bytes = base64Decode(idx >= 0 ? url.substring(idx + 1) : url);
    } catch (_) {
      bytes = null;
    }
    if (bytes == null) return _errorBox(context);
    return Image.memory(
      bytes,
      width: _w,
      height: _h,
      fit: BoxFit.cover,
      cacheWidth: 768,
      errorBuilder: (context, error, stack) => _errorBox(context),
    );
  }

  /// Bild aus einer normalen URL (Fallback, falls je eine http-URL genutzt
  /// wird).
  Widget _buildNetwork(BuildContext context) {
    final theme = Theme.of(context);
    return Image.network(
      url,
      width: _w,
      height: _h,
      fit: BoxFit.cover,
      cacheWidth: 768,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: _w,
          height: _h,
          color: theme.colorScheme.surface,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stack) => _errorBox(context),
    );
  }

  Widget _errorBox(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: _w,
      height: _h,
      color: theme.colorScheme.surface,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_outlined,
              color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 4),
          Text(
            'Bild konnte nicht geladen werden.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
