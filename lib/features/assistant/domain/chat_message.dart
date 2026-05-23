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
  });

  final String id;
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  @override
  List<Object?> get props => [id];
}
