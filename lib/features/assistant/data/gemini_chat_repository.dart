import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini-basierter KI-Berater. Baut bei jedem Aufruf einen System-Prompt
/// inklusive aktuellem Nutzerprofil zusammen, sendet die gesamte Historie
/// an Gemini Flash und mappt die Antwort auf eine [ChatMessage].
class GeminiChatRepository implements ChatRepository {
  GeminiChatRepository({
    required String apiKey,
    required this.userPreferences,
    String modelName = 'gemini-2.5-flash',
  }) : _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          systemInstruction: Content.system(_buildSystemPrompt(userPreferences)),
          generationConfig: GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 600,
          ),
        );

  final GenerativeModel _model;
  final UserPreferences? userPreferences;

  @override
  Future<Result<ChatMessage>> reply(List<ChatMessage> history) async {
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

  static String _buildSystemPrompt(UserPreferences? prefs) {
    final buf = StringBuffer()
      ..writeln(
        'Du bist ein freundlicher, fachkundiger Hunde-Berater in der App '
        '"DogMatch AI". Du hilfst Menschen, die passende Hunderasse zu finden '
        'und beantwortest Fragen zu Haltung, Pflege, Gesundheit und Training.',
      )
      ..writeln()
      ..writeln('Regeln:')
      ..writeln('- Antworte auf Deutsch, kurz und konkret (3-6 Saetze).')
      ..writeln('- Empfehle bei Bedarf maximal 2-3 Rassen mit Begruendung.')
      ..writeln('- Bei medizinischen Themen verweise auf einen Tierarzt.')
      ..writeln('- Keine Phrasen wie "Als KI..." - bleib im Berater-Ton.')
      ..writeln(
        '- Wenn Daten fuer eine Empfehlung fehlen, frage gezielt nach '
        '(Wohnsituation, Erfahrung, Aktivitaetslevel).',
      );

    if (prefs == null) {
      return buf.toString();
    }

    final profile = <String>[];
    if (prefs.hasName) profile.add('Name: ${prefs.displayName}');
    profile.add('Land: ${prefs.country.label}');
    if (prefs.preferredSize != null) {
      profile.add('Wunschgroesse: ${prefs.preferredSize!.label}');
    }
    if (prefs.preferredActivity != null) {
      profile.add('Aktivitaetslevel: ${prefs.preferredActivity!.label}');
    }

    if (profile.isNotEmpty) {
      buf
        ..writeln()
        ..writeln('Profil des Nutzers (nutze es fuer passendere Antworten):')
        ..writeln('- ${profile.join('\n- ')}');
    }

    return buf.toString();
  }
}
