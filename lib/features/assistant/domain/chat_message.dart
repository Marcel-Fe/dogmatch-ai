import 'package:equatable/equatable.dart';

/// Absender einer Chat-Nachricht im KI-Berater.
enum ChatRole { user, assistant }

/// Eine einzelne Nachricht im KI-Berater-Chat.
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.imageUrl,
  });

  final String id;
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  /// Optionale Bild-URL, die in der Sprechblase angezeigt wird (z. B. ein
  /// von der KI erzeugtes Bild). Null bei reinen Text-Nachrichten.
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      role: ChatRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => ChatRole.assistant,
      ),
      content: json['content'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [id];
}
