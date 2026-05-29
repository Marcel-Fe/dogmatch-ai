import 'dart:convert';

import 'package:dogmatch_ai/features/assistant/domain/chat_conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokale Persistenz der KI-Konversationen. Liegt offline in
/// SharedPreferences - kostet nichts, kein Backend noetig.
///
/// Speicher-Format: ein einziger JSON-Array-String mit allen Konversationen,
/// sortiert nach updatedAt absteigend.
class LocalConversationsRepository {
  static const String _key = 'chat_conversations_v1';
  static const String _activeKey = 'active_conversation_id_v1';

  Future<List<ChatConversation>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      final convs = list
          .whereType<Map<String, dynamic>>()
          .map(ChatConversation.fromJson)
          .toList();
      convs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return convs;
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveAll(List<ChatConversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final list = conversations.map((c) => c.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<String?> loadActiveId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeKey);
  }

  Future<void> saveActiveId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_activeKey);
    } else {
      await prefs.setString(_activeKey, id);
    }
  }
}
