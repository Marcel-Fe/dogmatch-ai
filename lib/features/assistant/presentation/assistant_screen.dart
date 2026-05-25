import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/tts_service.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/chat_bubble.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/chat_input_bar.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/suggested_prompts.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/typing_indicator.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// KI-Berater (Tab 3). Mock-Antworten in Phase 2; in Phase 4 wird das
/// Repository auf die echte Claude-API umgestellt.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _scrollController = ScrollController();
  final _tts = const TtsService();
  String? _lastSpokenMessageId;

  @override
  void dispose() {
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send(String text) {
    ref.read(chatControllerProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final prefs = ref.watch(userPreferencesProvider).value;
    final ttsEnabled = prefs?.ttsEnabled ?? true;
    final theme = Theme.of(context);

    final limitReached =
        state.userMessageCount >= AppConstants.freeAiMessageLimit;

    // Nach jedem Rebuild ans Ende scrollen, sobald Nachrichten dazukommen.
    if (state.messages.isNotEmpty) _scrollToBottom();

    // Sprich die letzte Assistant-Nachricht aus, wenn aktiviert + neu.
    if (ttsEnabled && _tts.isAvailable && state.messages.isNotEmpty) {
      final last = state.messages.last;
      if (last.role == ChatRole.assistant && last.id != _lastSpokenMessageId) {
        _lastSpokenMessageId = last.id;
        _tts.speak(last.content);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('KI-Berater'),
        actions: [
          if (_tts.isAvailable)
            IconButton(
              tooltip: ttsEnabled
                  ? 'Sprachausgabe ausschalten'
                  : 'Sprachausgabe einschalten',
              icon: Icon(
                ttsEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              ),
              onPressed: () {
                final current = prefs ?? const UserPreferences();
                ref
                    .read(userPreferencesProvider.notifier)
                    .save(current.copyWith(ttsEnabled: !ttsEnabled));
                if (ttsEnabled) _tts.stop();
              },
            ),
          if (state.messages.isNotEmpty)
            IconButton(
              tooltip: 'Neuer Chat',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                _tts.stop();
                _lastSpokenMessageId = null;
                ref.read(chatControllerProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: state.messages.isEmpty
                  ? _EmptyState(onPromptSelected: _send)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount:
                          state.messages.length + (state.isWaiting ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == state.messages.length) {
                          return const TypingIndicator();
                        }
                        return ChatBubble(message: state.messages[i]);
                      },
                    ),
            ),
            if (limitReached) _LimitBanner(theme: theme),
            ChatInputBar(
              isEnabled: !state.isWaiting && !limitReached,
              onSend: _send,
              hintText: limitReached
                  ? 'Free-Limit erreicht - Premium schaltet alles frei'
                  : 'Frag den KI-Berater ...',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPromptSelected});

  final void Function(String) onPromptSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Hi! Ich bin dein KI-Hundeberater.',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Frag mich etwas - oder waehle einen Vorschlag:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          SuggestedPrompts(onSelect: onPromptSelected),
        ],
      ),
    );
  }
}

class _LimitBanner extends StatelessWidget {
  const _LimitBanner({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primarySoft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            size: 18,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Limit der kostenlosen Stufe erreicht.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.premium),
            child: const Text('Premium'),
          ),
        ],
      ),
    );
  }
}
