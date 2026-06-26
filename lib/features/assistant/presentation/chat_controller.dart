import 'package:dogmatch_ai/core/config/env.dart';
import 'package:dogmatch_ai/core/error/failures.dart';
import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/data/chat_system_prompt.dart';
import 'package:dogmatch_ai/features/assistant/data/gemini_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/image_gen_service.dart';
import 'package:dogmatch_ai/features/assistant/data/mock_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/pollinations_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/data/remote_gemini_chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';
import 'package:dogmatch_ai/features/assistant/presentation/conversations_controller.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aktiver Modus des Chats (Berater vs. Trainer). UI setzt das per
/// Umschalter; der RepositoryProvider liest es, um den System-Prompt zu
/// bauen.
class ChatModeNotifier extends Notifier<ChatMode> {
  @override
  ChatMode build() => ChatMode.advisor;

  void setMode(ChatMode mode) => state = mode;
}

final chatModeProvider = NotifierProvider<ChatModeNotifier, ChatMode>(
  ChatModeNotifier.new,
);

/// "Vorgemerkte" Eingabe fuer den Chat, die ein anderer Screen
/// (Verhalten-Check, Symptom-Check) gesetzt hat. Der AssistantScreen
/// liest sie beim Mount aus, schaltet den Modus und sendet die Frage
/// automatisch. Danach wird sie auf null gesetzt.
class AssistantHandoff {
  const AssistantHandoff({
    required this.prompt,
    required this.mode,
    this.origin,
  });
  final String prompt;
  final ChatMode mode;

  /// Route, von der aus der Handoff ausgeloest wurde (z. B. Rasse-Detail).
  /// Der AssistantScreen zeigt damit einen Zurueck-Pfeil dorthin. Null,
  /// wenn der Assistant direkt ueber die Tab-Leiste geoeffnet wurde.
  final String? origin;
}

class AssistantHandoffNotifier extends Notifier<AssistantHandoff?> {
  @override
  AssistantHandoff? build() => null;

  void queue(AssistantHandoff handoff) => state = handoff;
  void consume() => state = null;
}

final assistantHandoffProvider =
    NotifierProvider<AssistantHandoffNotifier, AssistantHandoff?>(
      AssistantHandoffNotifier.new,
    );

/// Stellt die konkrete Implementierung des [ChatRepository] bereit.
/// Reihenfolge:
/// 1. `GEMINI_PROXY_URL` gesetzt (Cloudflare Worker) -> RemoteGemini.
///    Bevorzugt, weil der Gemini-Key serverseitig bleibt.
/// 2. Sonst `GEMINI_API_KEY` gesetzt (nur lokales Testen).
/// 3. Sonst Pollinations.ai (kostenlos, ohne Key, Default in Live).
/// 4. Sonst MockChatRepository (Offline-Notfall).
/// True, wenn das aktive Backend Bilder analysieren kann. UI nutzt das, um
/// den Foto-Button auszublenden, wenn keine echte Vision verfuegbar ist.
final supportsVisionProvider = Provider<bool>((ref) {
  return ref.watch(chatRepositoryProvider).supportsVision;
});

/// True, wenn Bild-Erzeugung moeglich ist (nur ueber den Worker-Proxy, weil
/// das Gemini-Bildmodell serverseitig laeuft). UI zeigt den Bild-Knopf nur
/// dann an.
final supportsImageGenProvider = Provider<bool>((ref) {
  return Env.hasGeminiProxy;
});

/// Service fuer die Bild-Erzeugung. Null, wenn kein Worker-Proxy gesetzt ist.
final imageGenServiceProvider = Provider<ImageGenService?>((ref) {
  if (!Env.hasGeminiProxy) return null;
  return ImageGenService(proxyUrl: Env.geminiProxyUrl);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final prefs = ref.watch(userPreferencesProvider).value;
  final mode = ref.watch(chatModeProvider);
  // Aktiven Hund + Rasseprofil aus der App-Datenbank in den Prompt einspeisen,
  // damit Antworten rassetypisch und konkret werden.
  final activeDog = ref.watch(dogsProvider).value?.activeDog;
  final breeds = ref.watch(breedsProvider).value ?? const [];
  // Bevorstehende Termine NUR des aktiven Hundes (sortiert nach Datum).
  final upcomingEvents = activeDog == null
      ? const <HealthEvent>[]
      : ref
            .watch(upcomingHealthEventsProvider)
            .where((e) => e.dogId == activeDog.id)
            .toList();
  final dogContext = buildDogContext(
    activeDog,
    breeds,
    upcomingEvents: upcomingEvents,
  );
  if (Env.hasGeminiProxy) {
    return RemoteGeminiChatRepository(
      proxyUrl: Env.geminiProxyUrl,
      userPreferences: prefs,
      mode: mode,
      dogContext: dogContext,
    );
  }
  if (Env.hasGeminiKey) {
    return GeminiChatRepository(
      apiKey: Env.geminiApiKey,
      userPreferences: prefs,
      mode: mode,
      dogContext: dogContext,
    );
  }
  if (Env.hasPollinations) {
    return PollinationsChatRepository(
      userPreferences: prefs,
      mode: mode,
      dogContext: dogContext,
    );
  }
  return const MockChatRepository();
});

/// Letzter fehlgeschlagener Versuch - dient dem Retry-Banner.
class FailedAttempt extends Equatable {
  const FailedAttempt({
    required this.text,
    required this.friendlyMessage,
    required this.technicalDetail,
    this.imageDataUrl,
  });

  final String text;
  final String? imageDataUrl;

  /// Kurze, freundliche Erklaerung fuer den Nutzer (Deutsch, keine Stacktraces).
  final String friendlyMessage;

  /// Roher Fehlertext - landet in der Browser-Konsole, nicht im UI.
  final String technicalDetail;

  @override
  List<Object?> get props => [
    text,
    imageDataUrl,
    friendlyMessage,
    technicalDetail,
  ];
}

/// Zustand der Chat-Session: alle bisherigen Nachrichten + Warte-Indikator.
class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.isWaiting = false,
    this.lastFailure,
  });

  final List<ChatMessage> messages;
  final bool isWaiting;

  /// Wenn gesetzt, kann der Nutzer den letzten Versuch wiederholen.
  /// Wird zurueckgesetzt, sobald ein neuer Versuch startet.
  final FailedAttempt? lastFailure;

  /// Anzahl gesendeter Nutzer-Nachrichten (fuer das Free-Limit).
  int get userMessageCount =>
      messages.where((m) => m.role == ChatRole.user).length;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isWaiting,
    FailedAttempt? lastFailure,
    bool clearFailure = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isWaiting: isWaiting ?? this.isWaiting,
      lastFailure: clearFailure ? null : (lastFailure ?? this.lastFailure),
    );
  }

  @override
  List<Object?> get props => [messages, isWaiting, lastFailure];
}

/// Steuert den Chat: schickt Nachrichten an das Repository, haengt
/// die Antwort an den Verlauf an und persistiert die aktive Konversation
/// nach jeder Aenderung.
class ChatController extends Notifier<ChatState> {
  @override
  ChatState build() {
    // Beim Start: wenn eine aktive Konversation ausgewaehlt ist, laden.
    final activeId = ref.read(activeConversationIdProvider);
    if (activeId != null) {
      final convs = ref.read(conversationsListProvider).value ?? const [];
      for (final c in convs) {
        if (c.id == activeId) return ChatState(messages: c.messages);
      }
    }
    return const ChatState();
  }

  Future<void> sendMessage(String text, {String? imageDataUrl}) async {
    final trimmed = text.trim();
    if ((trimmed.isEmpty && imageDataUrl == null) || state.isWaiting) return;

    final userMessage = ChatMessage(
      id: 'u-${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      content: trimmed.isEmpty ? '[Bild]' : trimmed,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isWaiting: true,
      clearFailure: true,
    );

    final result = await ref
        .read(chatRepositoryProvider)
        .reply(state.messages, imageDataUrl: imageDataUrl);

    switch (result) {
      case Success(:final value):
        // Markdown-Zeichen entfernen - die Sprechblase zeigt reinen Text,
        // sonst erscheinen ** und * als rohe Sonderzeichen.
        final clean = ChatMessage(
          id: value.id,
          role: value.role,
          content: _stripMarkdown(value.content),
          timestamp: value.timestamp,
          imageUrl: value.imageUrl,
        );
        state = state.copyWith(
          messages: [...state.messages, clean],
          isWaiting: false,
          clearFailure: true,
        );
      case FailureResult(:final failure):
        final friendly = _humanize(failure);
        if (kDebugMode || kIsWeb) {
          // ignore: avoid_print
          print('[KI-Fehler] ${failure.runtimeType}: ${failure.message}');
        }
        state = state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(
              id: 'e-${DateTime.now().microsecondsSinceEpoch}',
              role: ChatRole.assistant,
              content: friendly,
              timestamp: DateTime.now(),
            ),
          ],
          isWaiting: false,
          lastFailure: FailedAttempt(
            text: trimmed,
            imageDataUrl: imageDataUrl,
            friendlyMessage: friendly,
            technicalDetail: failure.message,
          ),
        );
    }

    // Aktive Konversation persistieren (Auto-Save nach jeder Nachricht).
    await _persistActive();
  }

  /// Erzeugt aus [prompt] ein Bild und zeigt es im Chat. Laeuft ueber den
  /// Cloudflare-Worker (Gemini-Bildmodell) - der Key bleibt serverseitig.
  /// Die Antwort ist eine data-URL, die in der Sprechblase via
  /// [ChatMessage.imageUrl] angezeigt wird.
  Future<void> generateImage(String prompt) async {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty || state.isWaiting) return;

    final service = ref.read(imageGenServiceProvider);
    if (service == null) return; // Knopf ist ohne Worker ohnehin ausgeblendet.

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final userMessage = ChatMessage(
      id: 'u-$stamp',
      role: ChatRole.user,
      content: '🎨 Bild: $trimmed',
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isWaiting: true,
      clearFailure: true,
    );

    final result = await service.generate(trimmed);
    switch (result) {
      case Success(:final value):
        state = state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(
              id: 'a-$stamp',
              role: ChatRole.assistant,
              content: 'Hier ist dein Bild zu „$trimmed".',
              timestamp: DateTime.now(),
              imageUrl: value,
            ),
          ],
          isWaiting: false,
          clearFailure: true,
        );
      case FailureResult(:final failure):
        if (kDebugMode || kIsWeb) {
          // ignore: avoid_print
          print('[Bild-Fehler] ${failure.runtimeType}: ${failure.message}');
        }
        state = state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(
              id: 'e-$stamp',
              role: ChatRole.assistant,
              content: 'Das Bild hat gerade nicht geklappt. Bitte tippe noch '
                  'einmal aufs ✨-Symbol - meist klappt es dann.',
              timestamp: DateTime.now(),
            ),
          ],
          isWaiting: false,
        );
    }
    await _persistActive();
  }

  /// Speichert den aktuellen Chat in der lokalen Konversations-Liste.
  /// Erzeugt eine neue Konversation, wenn noch keine aktive ID gesetzt
  /// war.
  Future<void> _persistActive() async {
    final mode = ref.read(chatModeProvider);
    var activeId = ref.read(activeConversationIdProvider);
    if (activeId == null) {
      activeId = 'c-${DateTime.now().microsecondsSinceEpoch}';
      ref.read(activeConversationIdProvider.notifier).set(activeId);
    }
    await ref
        .read(conversationsListProvider.notifier)
        .updateMessages(activeId, _slimForStorage(state.messages), mode);
  }

  /// Entfernt grosse base64-Bild-Daten (data-URLs) vor dem Speichern - sie
  /// wuerden den lokalen Speicher (localStorage im Web) sprengen. Im laufenden
  /// Chat bleibt das Bild sichtbar; nach App-Neustart ist es nicht mehr im
  /// Verlauf (bewusst, wie in vergleichbaren Apps).
  List<ChatMessage> _slimForStorage(List<ChatMessage> messages) {
    return messages.map((m) {
      final url = m.imageUrl;
      if (url == null || !url.startsWith('data:')) return m;
      return ChatMessage(
        id: m.id,
        role: m.role,
        content: m.content,
        timestamp: m.timestamp,
      );
    }).toList();
  }

  /// Wiederholt den letzten fehlgeschlagenen Versuch.
  Future<void> retryLast() async {
    final attempt = state.lastFailure;
    if (attempt == null || state.isWaiting) return;

    var msgs = state.messages;
    if (msgs.isNotEmpty && msgs.last.role == ChatRole.assistant) {
      msgs = msgs.sublist(0, msgs.length - 1);
    }
    if (msgs.isNotEmpty && msgs.last.role == ChatRole.user) {
      msgs = msgs.sublist(0, msgs.length - 1);
    }
    state = state.copyWith(messages: msgs, clearFailure: true);
    await sendMessage(attempt.text, imageDataUrl: attempt.imageDataUrl);
  }

  void dismissFailure() {
    if (state.lastFailure == null) return;
    state = state.copyWith(clearFailure: true);
  }

  /// Starte einen neuen, leeren Chat. Behaelt die alte Konversation in der
  /// gespeicherten Liste - die ist ueber das Chat-Menue weiter erreichbar.
  void newChat() {
    ref.read(activeConversationIdProvider.notifier).set(null);
    state = const ChatState();
  }

  /// Aktiviert eine gespeicherte Konversation. Modus + Nachrichten werden
  /// uebernommen.
  Future<void> selectConversation(String id) async {
    final convs = ref.read(conversationsListProvider).value ?? const [];
    for (final c in convs) {
      if (c.id == id) {
        ref.read(activeConversationIdProvider.notifier).set(id);
        ref.read(chatModeProvider.notifier).setMode(c.mode);
        state = ChatState(messages: c.messages);
        return;
      }
    }
  }

  /// Loescht eine gespeicherte Konversation. Wenn es die aktive war,
  /// startet ein neuer leerer Chat.
  Future<void> deleteConversation(String id) async {
    await ref.read(conversationsListProvider.notifier).deleteChat(id);
    if (ref.read(activeConversationIdProvider) == id) {
      newChat();
    }
  }

  /// Veralteter Alias - intern wie newChat.
  void clear() => newChat();
}

/// Entfernt Markdown-Formatierung aus einer KI-Antwort, damit sie in der
/// reinen Text-Sprechblase sauber aussieht (keine rohen ** oder #).
/// Aufzaehlungs-Sternchen am Zeilenanfang werden zu Bindestrichen.
String _stripMarkdown(String input) {
  final buffer = StringBuffer();
  for (final raw in input.split('\n')) {
    var line = raw.replaceFirst(RegExp(r'^\s*#{1,6}\s+'), '');
    line = line.replaceFirstMapped(
      RegExp(r'^(\s*)[*•]\s+'),
      (m) => '${m[1]}- ',
    );
    buffer.writeln(line);
  }
  return buffer
      .toString()
      .replaceAll('**', '')
      .replaceAll('__', '')
      .replaceAll('*', '')
      .trim();
}

/// Mappt einen [Failure] auf einen kurzen, freundlichen Deutsch-Text.
/// Stacktraces und Library-Praefixe sind hier nicht erwuenscht.
String _humanize(Failure failure) {
  final raw = failure.message.toLowerCase();
  if (failure is NetworkFailure) {
    if (raw.contains('failed to fetch') ||
        raw.contains('clientexception') ||
        raw.contains('xmlhttprequest')) {
      return 'Der KI-Berater ist gerade nicht erreichbar. '
          'Pruefe deine Internet-Verbindung und versuche es erneut.';
    }
    if (raw.contains('timeout') || raw.contains('timed out')) {
      return 'Die Antwort hat zu lange gedauert. Versuche es bitte erneut.';
    }
    if (raw.contains('http 4')) {
      return 'Der KI-Berater hat die Anfrage abgelehnt. '
          'Bitte formuliere die Frage anders oder versuche es spaeter.';
    }
    if (raw.contains('http 5')) {
      return 'Der KI-Berater ist gerade ueberlastet. '
          'Bitte versuche es in einer Minute erneut.';
    }
    return 'Verbindung zum KI-Berater fehlgeschlagen. '
        'Bitte versuche es erneut.';
  }
  if (failure is CacheFailure) {
    return 'Lokale Daten konnten nicht geladen werden. App neu starten hilft meist.';
  }
  return 'Da ist etwas schiefgelaufen. Bitte erneut versuchen.';
}

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);
