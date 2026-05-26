import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/gemini_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/mock_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/remote_gemini_chat_repository.dart';
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
/// Reihenfolge:
/// 1. `GEMINI_PROXY_URL` gesetzt (Cloudflare Worker) -> RemoteGemini.
///    Bevorzugt, weil der Gemini-Key serverseitig bleibt.
/// 2. Sonst `GEMINI_API_KEY` gesetzt (nur lokales Testen, NIE in Live-Build)
///    -> GeminiChatRepository direkt.
/// 3. Sonst MockChatRepository (App laeuft offline).
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final prefs = ref.watch(userPreferencesProvider).value;
  final mode = ref.watch(chatModeProvider);
  if (Env.hasGeminiProxy) {
    return RemoteGeminiChatRepository(
      proxyUrl: Env.geminiProxyUrl,
      userPreferences: prefs,
      mode: mode,
    );
  }
  if (Env.hasGeminiKey) {
    return GeminiChatRepository(
      apiKey: Env.geminiApiKey,
      userPreferences: prefs,
      mode: mode,
    );
  }
  return const MockChatRepository();
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

  Future<void> sendMessage(String text, {String? imageDataUrl}) async {
    final trimmed = text.trim();
    if ((trimmed.isEmpty && imageDataUrl == null) || state.isWaiting) return;

    final userMessage = ChatMessage(
      id: 'u-${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      content: trimmed.isEmpty ? '[Bild]' : trimmed,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isWaiting: true,
    );

    final result = await ref
        .read(chatRepositoryProvider)
        .reply(state.messages, imageDataUrl: imageDataUrl);

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
