import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:equatable/equatable.dart';

/// Eine gespeicherte Konversation des KI-Beraters - wie ein einzelner
/// Chat-Faden in ChatGPT. Persistierung erfolgt lokal in SharedPreferences.
class ChatConversation extends Equatable {
  const ChatConversation({
    required this.id,
    required this.title,
    required this.mode,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final ChatMode mode;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation copyWith({
    String? id,
    String? title,
    ChatMode? mode,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      mode: mode ?? this.mode,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'mode': mode.name,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    final rawMessages = (json['messages'] as List?) ?? const [];
    return ChatConversation(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Chat',
      mode: ChatMode.values.firstWhere(
        (m) => m.name == json['mode'],
        orElse: () => ChatMode.advisor,
      ),
      messages: rawMessages
          .whereType<Map<String, dynamic>>()
          .map(ChatMessage.fromJson)
          .toList(growable: false),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Erzeugt aus der ersten Nutzer-Nachricht einen kurzen Titel
  /// (max 48 Zeichen). Fuer leere Konversationen "Neuer Chat".
  static String autoTitle(List<ChatMessage> messages) {
    for (final m in messages) {
      if (m.role != ChatRole.user) continue;
      final text = m.content.trim();
      if (text.isEmpty) continue;
      if (text.length <= 48) return text;
      return '${text.substring(0, 45)}...';
    }
    return 'Neuer Chat';
  }

  @override
  List<Object?> get props => [id, title, mode, messages, createdAt, updatedAt];
}
