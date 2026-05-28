import 'dart:convert';

import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/constants/app_constants.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/tts_service.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/chat_bubble.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/chat_input_bar.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/suggested_prompts.dart';
import 'package:dogmatch_ai/features/assistant/presentation/widgets/typing_indicator.dart';
import 'package:dogmatch_ai/features/dogs/data/photo_picker.dart' as picker;
import 'package:dogmatch_ai/features/premium/presentation/premium_controller.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/foundation.dart';
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

  /// Bild als data-URL, das mit der naechsten Nachricht versendet wird.
  /// Nur sichtbar im Remote-Modus (Cloudflare-Proxy aktiv).
  String? _pendingImageDataUrl;

  @override
  void initState() {
    super.initState();
    // Falls ein anderer Screen (Verhalten-Check etc.) eine Frage vorgemerkt
    // hat: Modus setzen, neuen Chat starten, Frage versenden, Handoff leeren.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final handoff = ref.read(assistantHandoffProvider);
      if (handoff == null) return;
      ref.read(chatModeProvider.notifier).setMode(handoff.mode);
      ref.read(chatControllerProvider.notifier).clear();
      ref
          .read(chatControllerProvider.notifier)
          .sendMessage(handoff.prompt);
      ref.read(assistantHandoffProvider.notifier).consume();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final url = await picker.pickImageAsDataUrl();
      if (!mounted) return;
      if (url != null) setState(() => _pendingImageDataUrl = url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  void _clearPendingImage() {
    setState(() => _pendingImageDataUrl = null);
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
    final image = _pendingImageDataUrl;
    ref
        .read(chatControllerProvider.notifier)
        .sendMessage(text, imageDataUrl: image);
    if (image != null) _clearPendingImage();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final prefs = ref.watch(userPreferencesProvider).value;
    final ttsEnabled = prefs?.ttsEnabled ?? true;
    final mode = ref.watch(chatModeProvider);
    final theme = Theme.of(context);

    final supportsVision = ref.watch(supportsVisionProvider);
    final isPremium = ref.watch(isPremiumProvider);
    // Free-Limit nur im reinen Mock-Modus relevant. Sobald ein echter
    // KI-Pfad (Pollinations / Gemini / Worker) aktiv ist, ist die App
    // ohnehin kostenfrei und das Limit waere kuenstlich.
    final limitReached = Env.isMockMode &&
        !isPremium &&
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
        title: Text(mode == ChatMode.trainer ? 'Hundetrainer' : 'KI-Berater'),
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
            _ModeSwitcher(
              current: mode,
              onChanged: (next) {
                if (next == mode) return;
                ref.read(chatModeProvider.notifier).setMode(next);
                _tts.stop();
                _lastSpokenMessageId = null;
                ref.read(chatControllerProvider.notifier).clear();
              },
            ),
            Expanded(
              child: state.messages.isEmpty
                  ? _EmptyState(
                      mode: mode,
                      onPromptSelected: _send,
                      supportsVision: supportsVision,
                    )
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
            if (state.lastFailure != null && !state.isWaiting)
              _RetryBanner(
                message: state.lastFailure!.friendlyMessage,
                onRetry: () => ref
                    .read(chatControllerProvider.notifier)
                    .retryLast(),
                onDismiss: () => ref
                    .read(chatControllerProvider.notifier)
                    .dismissFailure(),
              ),
            if (_pendingImageDataUrl != null)
              _PendingImagePreview(
                dataUrl: _pendingImageDataUrl!,
                onRemove: _clearPendingImage,
              ),
            ChatInputBar(
              isEnabled: !state.isWaiting && !limitReached,
              onSend: _send,
              onPickImage: supportsVision ? _pickImage : null,
              hasPendingImage: _pendingImageDataUrl != null,
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
  const _EmptyState({
    required this.mode,
    required this.onPromptSelected,
    required this.supportsVision,
  });

  final ChatMode mode;
  final void Function(String) onPromptSelected;
  final bool supportsVision;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTrainer = mode == ChatMode.trainer;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            isTrainer
                ? 'Hi! Ich bin dein Hundetrainer.'
                : 'Hi! Ich bin dein KI-Hundeberater.',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isTrainer
                ? 'Erzaehl mir vom Verhalten oder waehle eine Trainings-Frage:'
                : 'Frag mich etwas - oder waehle einen Vorschlag:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!isTrainer)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.mic_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      supportsVision
                          ? 'Tipp: Tipp aufs Mikro fuer Sprach-Eingabe oder '
                              'aufs Foto-Symbol, um ein Bild deines Hundes '
                              'zur Erkennung hochzuladen.'
                          : 'Tipp: Tipp aufs Mikro fuer Sprach-Eingabe. '
                              'Beschreibe deinen Hund einfach in Worten - der '
                              'Berater hilft dir gerne weiter.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          SuggestedPrompts(
            onSelect: onPromptSelected,
            prompts: isTrainer ? _trainerPrompts : null,
          ),
        ],
      ),
    );
  }

  static const _trainerPrompts = <String>[
    'Wie bringe ich meinem Hund "Sitz" bei?',
    'Mein Hund zieht an der Leine - was tun?',
    'Welpe beisst beim Spielen - wie reagieren?',
    'Mein Hund bellt fremde Hunde an - Trainingsplan?',
  ];
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

/// Banner mit "Erneut versuchen" und Schliessen-Knopf. Wird nach jedem
/// fehlgeschlagenen KI-Aufruf eingeblendet.
class _RetryBanner extends StatelessWidget {
  const _RetryBanner({
    required this.message,
    required this.onRetry,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Erneut versuchen'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
          ),
          IconButton(
            tooltip: 'Schliessen',
            icon: Icon(
              Icons.close_rounded,
              color: theme.colorScheme.onErrorContainer,
              size: 20,
            ),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

/// Segmentierter Umschalter zwischen Berater- und Trainer-Modus.
class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({required this.current, required this.onChanged});

  final ChatMode current;
  final ValueChanged<ChatMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Row(
          children: [
            for (final m in ChatMode.values)
              Expanded(child: _modeButton(theme, m)),
          ],
        ),
      ),
    );
  }

  Widget _modeButton(ThemeData theme, ChatMode m) {
    final selected = m == current;
    return GestureDetector(
      onTap: () => onChanged(m),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        alignment: Alignment.center,
        child: Text(
          m.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Vorschau eines angehaengten Bildes vor dem Versand (Multimodal-Chat).
class _PendingImagePreview extends StatelessWidget {
  const _PendingImagePreview({required this.dataUrl, required this.onRemove});

  final String dataUrl;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Uint8List? bytes;
    try {
      final idx = dataUrl.indexOf(',');
      final b64 = idx >= 0 ? dataUrl.substring(idx + 1) : dataUrl;
      bytes = base64Decode(b64);
    } catch (_) {
      bytes = null;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: SizedBox(
              width: 48,
              height: 48,
              child: bytes != null
                  ? Image.memory(bytes, fit: BoxFit.cover)
                  : Container(
                      color: theme.colorScheme.surface,
                      child: const Icon(Icons.image_outlined),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Bild angehaengt - wird mit deiner naechsten Nachricht analysiert.',
              style: theme.textTheme.bodySmall,
            ),
          ),
          IconButton(
            tooltip: 'Bild entfernen',
            icon: const Icon(Icons.close_rounded),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
