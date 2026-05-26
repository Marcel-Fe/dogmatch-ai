import 'dart:convert';

import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
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
    this.model = 'gemini-2.5-flash',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String proxyUrl;
  final UserPreferences? userPreferences;
  final ChatMode mode;
  final String model;
  final http.Client _client;

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
      'systemInstruction': _buildSystemPrompt(userPreferences, mode),
      'messages': history
          .map((m) => {
                'role': switch (m.role) {
                  ChatRole.user => 'user',
                  ChatRole.assistant => 'model',
                },
                'text': m.content,
              })
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
        return FailureResult(NetworkFailure('KI-Fehler: HTTP ${res.statusCode}'));
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

  static String _buildSystemPrompt(UserPreferences? prefs, ChatMode mode) {
    final buf = StringBuffer();
    switch (mode) {
      case ChatMode.advisor:
        buf
          ..writeln(
            'Du bist ein freundlicher, fachkundiger Hunde-Berater in der '
            'App "DogMatch AI". Du hilfst Menschen, die passende Hunderasse '
            'zu finden und beantwortest Fragen zu Haltung, Pflege, '
            'Gesundheit und Anschaffung.',
          )
          ..writeln()
          ..writeln('Regeln:')
          ..writeln('- Antworte auf Deutsch, kurz und konkret (3-6 Saetze).')
          ..writeln('- Empfehle bei Bedarf maximal 2-3 Rassen mit Begruendung.')
          ..writeln('- Bei medizinischen Themen verweise auf einen Tierarzt.')
          ..writeln('- Keine Phrasen wie "Als KI..." - bleib im Berater-Ton.')
          ..writeln(
            '- Wenn ein Bild beigefuegt ist, beschreibe was du siehst und '
            'gib eine konkrete Einschaetzung dazu.',
          );
      case ChatMode.trainer:
        buf
          ..writeln(
            'Du bist ein erfahrener Hundetrainer und Verhaltensberater in '
            'der App "DogMatch AI". Du hilfst bei Erziehung, Verhaltens-'
            'problemen, Sozialisierung und gezielten Trainings-Uebungen.',
          )
          ..writeln()
          ..writeln('Regeln:')
          ..writeln('- Antworte auf Deutsch, freundlich und sehr konkret.')
          ..writeln(
            '- Liefere Schritt-fuer-Schritt-Anleitungen, nummeriert.',
          )
          ..writeln(
            '- Setze auf positive Bestaerkung (Marker/Klick + Belohnung). '
            'Aversive Methoden lehnst du ab und erklaerst kurz, warum.',
          )
          ..writeln(
            '- Wenn ein Bild beigefuegt ist (Hund, Koerpersprache, '
            'Situation), analysiere es und gib eine konkrete Empfehlung.',
          );
    }

    if (prefs == null) return buf.toString();

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
