import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';

/// Vertrag fuer den KI-Berater. In Phase 2 liefert ein lokaler Mock die
/// Antworten; in Phase 4 wird hier die Claude-/OpenAI-Anbindung eingehaengt -
/// ohne dass UI oder State-Schicht angefasst werden muessen.
abstract interface class ChatRepository {
  /// Erzeugt eine Antwort des Assistenten auf den bisherigen Verlauf.
  /// Die letzte Nachricht in [history] ist die aktuelle User-Frage.
  /// Optional kann ein Bild als Data-URL angehaengt werden - nur Backends
  /// mit `supportsVision == true` werten das aus.
  Future<Result<ChatMessage>> reply(
    List<ChatMessage> history, {
    String? imageDataUrl,
  });

  /// True, wenn dieses Backend Bilder analysieren kann (Multimodal).
  /// Wird im UI genutzt, um den Foto-Button auszublenden, wenn das aktive
  /// Backend keine Vision unterstuetzt.
  bool get supportsVision;
}
