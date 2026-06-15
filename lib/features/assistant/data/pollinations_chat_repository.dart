import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/chat_system_prompt.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:http/http.dart' as http;

/// Kostenfreies KI-Backend ohne API-Key via Pollinations.ai.
///
/// Wir nutzen primaer den GET-Endpoint, weil der als "simple request"
/// keinen CORS-Preflight ausloest - viele Flutter-Web-fetch-Aufrufe
/// scheitern sonst am preflight + credentials-Verhalten von Browsern.
///
/// Fuer Bild-Eingabe (Vision) wird POST genutzt - das funktioniert
/// in den meisten Browsern, weil dort keine credentials-Probleme
/// auftreten (image-URL wird base64 inline gesendet).
class PollinationsChatRepository implements ChatRepository {
  PollinationsChatRepository({
    required this.userPreferences,
    this.mode = ChatMode.advisor,
    this.dogContext,
    this.model = 'openai',
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const String _getBase = 'https://text.pollinations.ai';

  final UserPreferences? userPreferences;
  final ChatMode mode;

  /// Fakten zum aktiven Hund + Rasseprofil (App-Datenbank) fuer den Prompt.
  final String? dogContext;
  final String model;
  final http.Client _client;

  @override
  bool get supportsVision => false;

  @override
  Future<Result<ChatMessage>> reply(
    List<ChatMessage> history, {
    String? imageDataUrl,
  }) async {
    if (history.isEmpty) {
      return const FailureResult(
        UnexpectedFailure('Keine Nachricht zum Beantworten.'),
      );
    }

    final systemPrompt = buildChatSystemPrompt(
      userPreferences,
      mode,
      dogContext: dogContext,
    );

    // Bild-Analyse ist im anonymen Pollinations-Tier nicht moeglich (nur
    // `openai-fast` ohne Vision). Wir liefern eine klare Meldung statt
    // einen 400-Fehler vom Server zu produzieren.
    if (imageDataUrl != null && imageDataUrl.isNotEmpty) {
      return const FailureResult(
        UnexpectedFailure(
          'Bild-Analyse ist im kostenlosen Modus nicht verfuegbar. '
          'Beschreibe den Hund bitte in Worten - der Berater hilft dir gerne weiter.',
        ),
      );
    }
    return _replyTextOnly(history, systemPrompt);
  }

  Future<Result<ChatMessage>> _replyTextOnly(
    List<ChatMessage> history,
    String systemPrompt,
  ) async {
    // Fehler-Bubbles (id-Praefix 'e-') haben Inhalt wie "Verbindung
    // fehlgeschlagen ..." - die gehoeren NICHT in den Prompt, sonst
    // antwortet die KI auf die App-Fehlermeldung.
    final clean = history
        .where((m) => !m.id.startsWith('e-'))
        .toList(growable: false);
    if (clean.isEmpty) {
      return const FailureResult(
        UnexpectedFailure('Keine Nachricht zum Beantworten.'),
      );
    }
    // Letzte 6 Messages reichen - mehr ueberschreitet GET-URL-Limit.
    final relevant = clean.length > 6 ? clean.sublist(clean.length - 6) : clean;

    // Conversation als laufender Text fuer den GET-Endpoint. System wird
    // separat als Query-Parameter uebergeben.
    final conversation = StringBuffer();
    for (var i = 0; i < relevant.length - 1; i++) {
      final m = relevant[i];
      final speaker = m.role == ChatRole.user ? 'Nutzer' : 'Berater';
      conversation
        ..writeln('$speaker: ${m.content}')
        ..writeln();
    }
    final lastUser = relevant.last.content;
    if (conversation.isNotEmpty) {
      conversation
        ..writeln('Nutzer: $lastUser')
        ..writeln()
        ..write('Berater:');
    } else {
      conversation.write(lastUser);
    }

    final prompt = conversation.toString();
    final uri = Uri.parse(_getBase).replace(
      pathSegments: [prompt],
      queryParameters: {
        'model': model,
        'system': systemPrompt,
        'private': 'true',
      },
    );

    http.Response res;
    try {
      res = await _client.get(uri).timeout(const Duration(seconds: 45));
    } catch (e) {
      return FailureResult(NetworkFailure('Netzwerkfehler: $e'));
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      return FailureResult(NetworkFailure('KI-Fehler: HTTP ${res.statusCode}'));
    }

    final text = res.body.trim();
    if (text.isEmpty) {
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
  }
}
