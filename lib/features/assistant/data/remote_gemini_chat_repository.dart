import 'dart:convert';

import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/chat_system_prompt.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:http/http.dart' as http;

/// ChatRepository, das gegen den Cloudflare-Worker spricht.
/// Der Worker haelt den Gemini-Key serverseitig - der Key liegt nie im Bundle.
///
/// Anhaenge (Bilder) als Data-URL koennen via [imageDataUrl] uebergeben werden
/// und werden an die letzte Nachricht geheftet (Multimodal-Gemini).
class RemoteGeminiChatRepository implements ChatRepository {
  RemoteGeminiChatRepository({
    required this.proxyUrl,
    required this.userPreferences,
    this.mode = ChatMode.advisor,
    this.dogContext,
    this.model = 'gemini-2.5-flash',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String proxyUrl;
  final UserPreferences? userPreferences;
  final ChatMode mode;

  /// Fakten zum aktiven Hund + Rasseprofil (App-Datenbank), die in den
  /// System-Prompt eingespeist werden. Null, wenn kein Hund angelegt ist.
  final String? dogContext;
  final String model;
  final http.Client _client;

  @override
  bool get supportsVision => true;

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

    final body = <String, dynamic>{
      'model': model,
      'systemInstruction': buildChatSystemPrompt(
        userPreferences,
        mode,
        dogContext: dogContext,
      ),
      'messages': history
          .map(
            (m) => {
              'role': switch (m.role) {
                ChatRole.user => 'user',
                ChatRole.assistant => 'model',
              },
              'text': m.content,
            },
          )
          .toList(),
    };
    if (imageDataUrl != null && imageDataUrl.isNotEmpty) {
      body['image'] = imageDataUrl;
    }

    http.Response res;
    try {
      res = await _client
          .post(
            Uri.parse(proxyUrl),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 45));
    } catch (e) {
      return FailureResult(NetworkFailure('Netzwerkfehler: $e'));
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final err = jsonDecode(res.body) as Map<String, dynamic>;
        return FailureResult(
          NetworkFailure('KI-Fehler: ${err['error'] ?? res.statusCode}'),
        );
      } catch (_) {
        return FailureResult(
          NetworkFailure('KI-Fehler: HTTP ${res.statusCode}'),
        );
      }
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return const FailureResult(
        UnexpectedFailure('Antwort konnte nicht gelesen werden.'),
      );
    }
    final text = (data['text'] as String?)?.trim();
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
  }
}
