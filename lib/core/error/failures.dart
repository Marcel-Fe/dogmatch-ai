import 'package:equatable/equatable.dart';

/// Fehler-Typen der domain-Schicht. Bewusst getrennt von Exceptions:
/// Ein [Failure] wird als Wert weitergereicht (siehe `Result`), nicht geworfen.
/// `sealed` erzwingt, dass beim Auswerten alle Fehlerarten behandelt werden.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Lokale Daten (Assets, Cache) konnten nicht gelesen werden.
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Lokale Daten konnten nicht geladen werden.',
  ]);
}

/// Netzwerk-/Serverproblem (relevant ab der Backend-Phase).
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Keine Verbindung zum Server.',
  ]);
}

/// Unerwarteter, nicht naeher klassifizierter Fehler.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Ein unerwarteter Fehler ist aufgetreten.',
  ]);
}
