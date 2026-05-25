import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/gemini_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/mock_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aktiver Modus des Chats (Berater vs. Trainer). UI setzt das per
/// Umschalter; der RepositoryProvider liest es, um den System-Prompt zu
/// bauen.
class ChatModeNotifier extends Notifier<ChatMode> {
  @override
  ChatMode build() => ChatMode.advisor;

  void setMode(ChatMode mode) => state = mode;
}

final chatModeProvider =
    NotifierProvider<ChatModeNotifier, ChatMode>(ChatModeNotifier.new);

/// Stellt die konkrete Implementierung des [ChatRepository] bereit.
/// Liegt ein Gemini-API-Key (via --dart-define) vor, wird der echte Berater
/// genutzt - andernfalls fallback auf den lokalen Mock, damit die App auch
/// ohne Key lauffaehig bleibt. Das Nutzerprofil + Mode fliessen bei jedem
/// Build in den System-Prompt ein.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  if (!Env.hasGeminiKey) {
    return const MockChatRepository();
  }
  final prefs = ref.watch(userPreferencesProvider).value;
  final mode = ref.watch(chatModeProvider);
  return GeminiChatRepository(
    apiKey: Env.geminiApiKey,
    userPreferences: prefs,
    mode: mode,
  );
});

/// Zustand der Chat-Session: alle bisherigen Nachrichten + Warte-Indikator.
class ChatState extends Equatable {
  const ChatState({this.messages = const [], this.isWaiting = false});

  final List<ChatMessage> messages;
  final bool isWaiting;

  /// Anzahl gesendeter Nutzer-Nachrichten (fuer das Free-Limit).
  int get userMessageCount =>
      messages.where((m) => m.role == ChatRole.user).length;

  ChatState copyWith({List<ChatMessage>? messages, bool? isWaiting}) {
    return ChatState(
      messages: messages ?? this.messages,
      isWaiting: isWaiting ?? this.isWaiting,
    );
  }

  @override
  List<Object?> get props => [messages, isWaiting];
}

/// Steuert den Chat: schickt Nachrichten an das Repository und haengt
/// die Antwort an den Verlauf an.
class ChatController extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState();

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isWaiting) return;

    final userMessage = ChatMessage(
      id: 'u-${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      content: trimmed,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isWaiting: true,
    );

    final result = await ref.read(chatRepositoryProvider).reply(state.messages);

    switch (result) {
      case Success(:final value):
        state = state.copyWith(
          messages: [...state.messages, value],
          isWaiting: false,
        );
      case FailureResult(:final failure):
        state = state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(
              id: 'e-${DateTime.now().microsecondsSinceEpoch}',
              role: ChatRole.assistant,
              content: 'Entschuldigung, da ist etwas schiefgelaufen: '
                  '${failure.message}',
              timestamp: DateTime.now(),
            ),
          ],
          isWaiting: false,
        );
    }
  }

  void clear() {
    state = const ChatState();
  }
}

final chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);
