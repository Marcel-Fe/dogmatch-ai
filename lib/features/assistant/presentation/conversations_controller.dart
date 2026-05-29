import 'package:dogmatch_ai/features/assistant/data/local_conversations_repository.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_conversation.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversationsRepositoryProvider =
    Provider<LocalConversationsRepository>((ref) {
  return LocalConversationsRepository();
});

/// Liste aller gespeicherten KI-Konversationen, sortiert nach
/// updatedAt absteigend.
class ConversationsListNotifier
    extends AsyncNotifier<List<ChatConversation>> {
  late LocalConversationsRepository _repo;

  @override
  Future<List<ChatConversation>> build() async {
    _repo = ref.read(conversationsRepositoryProvider);
    return _repo.loadAll();
  }

  Future<void> upsert(ChatConversation conv) async {
    final current = List<ChatConversation>.from(state.value ?? const []);
    final idx = current.indexWhere((c) => c.id == conv.id);
    if (idx >= 0) {
      current[idx] = conv;
    } else {
      current.add(conv);
    }
    current.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = AsyncData(current);
    await _repo.saveAll(current);
  }

  /// Aktualisiert nur die Nachrichten + Modus einer existierenden
  /// Konversation. Wenn `id` (noch) nicht existiert: legt sie an.
  Future<void> updateMessages(
    String id,
    List<ChatMessage> messages,
    ChatMode mode,
  ) async {
    final current = List<ChatConversation>.from(state.value ?? const []);
    final idx = current.indexWhere((c) => c.id == id);
    final now = DateTime.now();
    if (idx >= 0) {
      final old = current[idx];
      current[idx] = old.copyWith(
        messages: messages,
        mode: mode,
        title: ChatConversation.autoTitle(messages),
        updatedAt: now,
      );
    } else {
      current.add(ChatConversation(
        id: id,
        title: ChatConversation.autoTitle(messages),
        mode: mode,
        messages: messages,
        createdAt: now,
        updatedAt: now,
      ));
    }
    current.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = AsyncData(current);
    await _repo.saveAll(current);
  }

  Future<void> deleteChat(String id) async {
    final current = List<ChatConversation>.from(state.value ?? const [])
      ..removeWhere((c) => c.id == id);
    state = AsyncData(current);
    await _repo.saveAll(current);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    await _repo.saveAll(const []);
  }
}

final conversationsListProvider = AsyncNotifierProvider<
    ConversationsListNotifier, List<ChatConversation>>(
  ConversationsListNotifier.new,
);

/// ID der aktuell im UI sichtbaren Konversation. Null = "Neuer Chat",
/// noch nicht gespeichert.
class ActiveConversationIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}

final activeConversationIdProvider =
    NotifierProvider<ActiveConversationIdNotifier, String?>(
  ActiveConversationIdNotifier.new,
);
