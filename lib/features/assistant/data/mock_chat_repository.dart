import 'package:dogmatch_ai/core/utils/result.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_message.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_repository.dart';

/// Lokaler Mock-Berater. Erkennt einige Schluesselwoerter in der letzten
/// Nutzer-Nachricht und antwortet mit vorgefertigten, sinnvollen Texten.
/// Wird in Phase 4 durch die echte Claude-API-Implementierung ersetzt.
class MockChatRepository implements ChatRepository {
  const MockChatRepository();

  static const _thinkingDelay = Duration(milliseconds: 700);

  @override
  Future<Result<ChatMessage>> reply(List<ChatMessage> history) async {
    await Future<void>.delayed(_thinkingDelay);

    final lastText = history.last.content.toLowerCase();
    final answer = _answerFor(lastText);

    return Success(
      ChatMessage(
        id: 'a-${DateTime.now().microsecondsSinceEpoch}',
        role: ChatRole.assistant,
        content: answer,
        timestamp: DateTime.now(),
      ),
    );
  }

  String _answerFor(String text) {
    if (text.contains('anfaenger') ||
        text.contains('anfänger') ||
        text.contains('einstieg') ||
        text.contains('erster hund')) {
      return 'Fuer Anfaenger sind vor allem Labrador Retriever, Golden '
          'Retriever und die Franzoesische Bulldogge gut geeignet: '
          'lernfreudig, geduldig und nicht zu eigenwillig. Wichtig ist eine '
          'fruehe Hundeschule und genug Zeit am Anfang.';
    }
    if (text.contains('kinder') || text.contains('familie')) {
      return 'Familienfreundliche Rassen sind z.B. Labrador, Golden '
          'Retriever und Beagle - geduldig, robust und gerne bei Trubel '
          'dabei. Kleine, sehr empfindliche Rassen sind mit kleinen '
          'Kindern oft schwieriger.';
    }
    if (text.contains('wohnung')) {
      return 'In einer Wohnung fuehlen sich kleinere, ruhigere Rassen wohl: '
          'Franzoesische Bulldogge, Mops oder Cavalier King Charles Spaniel. '
          'Wichtig sind trotzdem 2-3 ordentliche Spaziergaenge taeglich.';
    }
    if (text.contains('haaren') ||
        text.contains('allergi') ||
        text.contains('haar')) {
      return 'Wenig haarende Rassen sind z.B. Pudel, Bichon Frise und '
          'Portugiesischer Wasserhund. 100% allergikerfreundlich gibt es '
          'nicht - aber diese werden oft besser vertragen.';
    }
    if (text.contains('husky')) {
      return 'Husky ist fuer Anfaenger NICHT gut geeignet: sehr '
          'energiegeladen, eigensinnig und braucht viel Auslauf - am liebsten '
          'bei kuehleren Temperaturen. Eher etwas fuer erfahrene, sportliche '
          'Halter.';
    }
    if (text.contains('quiz') || text.contains('matching')) {
      return 'Probier gerne das Matching-Quiz im zweiten Tab - dort '
          'beantwortest du fuenf Fragen und bekommst eine Top-Liste der '
          'passendsten Rassen.';
    }
    if (text.contains('kosten') || text.contains('teuer')) {
      return 'Die monatlichen Kosten fuer einen Hund liegen ueblicherweise '
          'bei 60-120 EUR (Futter, Versicherung, Steuer, Tierarzt). Dazu '
          'kommen einmalige Anschaffungskosten und unerwartete '
          'Tierarztrechnungen.';
    }
    return 'Gerne! Frag mich z.B. "Welche Rasse passt zu Anfaengern?", '
        '"Welche Hunde sind familienfreundlich?" oder "Wie viel kostet ein '
        'Hund im Monat?" - ich helfe dir, eine passende Rasse zu finden.';
  }
}
