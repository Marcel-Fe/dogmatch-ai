import 'dart:convert';

import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
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
    this.model = 'openai',
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const String _getBase = 'https://text.pollinations.ai';
  static const String _postEndpoint = 'https://text.pollinations.ai/openai';

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

    final systemPrompt = _buildSystemPrompt(userPreferences, mode);

    // Mit Bild -> POST (Vision). Ohne Bild -> GET (kein CORS-preflight).
    if (imageDataUrl != null && imageDataUrl.isNotEmpty) {
      return _replyWithImage(history, systemPrompt, imageDataUrl);
    }
    return _replyTextOnly(history, systemPrompt);
  }

  Future<Result<ChatMessage>> _replyTextOnly(
    List<ChatMessage> history,
    String systemPrompt,
  ) async {
    // Letzte 6 Messages reichen - mehr ueberschreitet GET-URL-Limit.
    final relevant = history.length > 6
        ? history.sublist(history.length - 6)
        : history;

    // Conversation als laufender Text fuer den GET-Endpoint. System wird
    // separat als Query-Parameter uebergeben.
    final conversation = StringBuffer();
    for (var i = 0; i < relevant.length - 1; i++) {
      final m = relevant[i];
      final speaker =
          m.role == ChatRole.user ? 'Nutzer' : 'Berater';
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

  Future<Result<ChatMessage>> _replyWithImage(
    List<ChatMessage> history,
    String systemPrompt,
    String imageDataUrl,
  ) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemPrompt},
    ];

    for (var i = 0; i < history.length; i++) {
      final msg = history[i];
      final role = switch (msg.role) {
        ChatRole.user => 'user',
        ChatRole.assistant => 'assistant',
      };
      final isLast = i == history.length - 1;
      if (isLast && msg.role == ChatRole.user) {
        messages.add({
          'role': role,
          'content': <Map<String, dynamic>>[
            {'type': 'text', 'text': msg.content},
            {
              'type': 'image_url',
              'image_url': {'url': imageDataUrl},
            },
          ],
        });
      } else {
        messages.add({'role': role, 'content': msg.content});
      }
    }

    final body = jsonEncode({
      'model': model,
      'messages': messages,
      'referrer': 'dogmatch-ai',
    });

    http.Response res;
    try {
      res = await _client
          .post(
            Uri.parse(_postEndpoint),
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      return FailureResult(
        NetworkFailure('Netzwerkfehler bei Bild-Upload: $e'),
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      return FailureResult(NetworkFailure('KI-Fehler: HTTP ${res.statusCode}'));
    }

    String? text;
    try {
      final data = jsonDecode(res.body);
      if (data is Map<String, dynamic>) {
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final first = choices.first as Map<String, dynamic>;
          final message = first['message'] as Map<String, dynamic>?;
          final raw = message?['content'];
          if (raw is String) {
            text = raw.trim();
          } else if (raw is List) {
            final parts = raw
                .whereType<Map<String, dynamic>>()
                .map((p) => p['text'] as String? ?? '')
                .join();
            text = parts.trim();
          }
        }
        text ??= (data['text'] as String?)?.trim();
      } else if (data is String) {
        text = data.trim();
      }
    } catch (_) {
      text = res.body.trim();
    }

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
            '- Liefere Schritt-fuer-Schritt-Anleitungen, nummeriert (4-7 Schritte).',
          )
          ..writeln(
            '- Setze auf positive Bestaerkung (Marker/Klick + Belohnung). '
            'Aversive Methoden lehnst du ab und erklaerst kurz, warum.',
          )
          ..writeln(
            '- Wenn ein Bild beigefuegt ist (Hund, Koerpersprache, '
            'Situation), analysiere es und gib eine konkrete Empfehlung.',
          )
          ..writeln(
            '- Bei medizinischen Symptomen: verweise auf Tierarzt + '
            'zertifizierten Trainer.',
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
        ..writeln('Profil des Nutzers:')
        ..writeln('- ${profile.join('\n- ')}');
    }
    return buf.toString();
  }
}
