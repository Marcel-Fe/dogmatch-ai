import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/mock_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stellt die konkrete Implementierung des [ChatRepository] bereit.
/// In Phase 4 wird hier auf die echte Claude-API umgestellt.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
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
