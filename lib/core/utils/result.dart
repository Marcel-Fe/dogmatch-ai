import 'package:dogmatch_ai/core/error/failures.dart';

/// Ergebnis-Typ: entweder ein Erfolg ([Success]) mit Wert oder ein
/// Fehler ([FailureResult]). So muss die UI keine try/catch-Bloecke kennen -
/// sie unterscheidet nur die beiden Faelle. `sealed` erzwingt vollstaendiges
/// Behandeln beider Faelle im `switch`.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;
}
