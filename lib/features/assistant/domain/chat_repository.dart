import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';

/// Vertrag fuer den KI-Berater. In Phase 2 liefert ein lokaler Mock die
/// Antworten; in Phase 4 wird hier die Claude-/OpenAI-Anbindung eingehaengt -
/// ohne dass UI oder State-Schicht angefasst werden muessen.
abstract interface class ChatRepository {
  /// Erzeugt eine Antwort des Assistenten auf den bisherigen Verlauf.
  /// Die letzte Nachricht in [history] ist die aktuelle User-Frage.
  Future<Result<ChatMessage>> reply(List<ChatMessage> history);
}
