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
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
