import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/chat_system_prompt.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini-basierter KI-Berater. Baut bei jedem Aufruf einen System-Prompt
/// inklusive aktuellem Nutzerprofil + Modus (Berater vs. Trainer) zusammen,
/// sendet die gesamte Historie an Gemini Flash und mappt die Antwort auf
/// eine [ChatMessage].
class GeminiChatRepository implements ChatRepository {
  GeminiChatRepository({
    required String apiKey,
    required this.userPreferences,
    this.mode = ChatMode.advisor,
    this.dogContext,
    String modelName = 'gemini-2.5-flash',
  }) : _model = GenerativeModel(
         model: modelName,
         apiKey: apiKey,
         systemInstruction: Content.system(
           buildChatSystemPrompt(userPreferences, mode, dogContext: dogContext),
         ),
         generationConfig: GenerationConfig(
           temperature: 0.7,
           maxOutputTokens: 700,
         ),
       );

  final GenerativeModel _model;
  final UserPreferences? userPreferences;
  final ChatMode mode;

  /// Fakten zum aktiven Hund + Rasseprofil (App-Datenbank) fuer den Prompt.
  final String? dogContext;

  @override
  bool get supportsVision => false;

  @override
  Future<Result<ChatMessage>> reply(
    List<ChatMessage> history, {
    String? imageDataUrl,
  }) async {
    // Multimodal nur ueber den Proxy (RemoteGeminiChatRepository) - hier
    // ignoriert. Sonst muesste der Key serverlos eingebunden werden.
    if (history.isEmpty) {
      return const FailureResult(
        UnexpectedFailure('Keine Nachricht zum Beantworten.'),
      );
    }

    try {
      final contents = history.map(_toContent).toList();
      final response = await _model.generateContent(contents);
      final text = response.text?.trim();

      if (text == null || text.isEmpty) {
        return const FailureResult(
          NetworkFailure('Der Berater hat keine Antwort geliefert.'),
        );
      }

      return Success(
        ChatMessage(
          id: 'a-${DateTime.now().microsecondsSinceEpoch}',
          role: ChatRole.assistant,
          content: text,
          timestamp: DateTime.now(),
        ),
      );
    } on GenerativeAIException catch (e) {
      return FailureResult(NetworkFailure('KI-Fehler: ${e.message}'));
    } catch (e) {
      return FailureResult(UnexpectedFailure('Unerwarteter Fehler: $e'));
    }
  }

  static Content _toContent(ChatMessage msg) {
    final role = switch (msg.role) {
      ChatRole.user => 'user',
      ChatRole.assistant => 'model',
    };
    return Content(role, [TextPart(msg.content)]);
  }
}
