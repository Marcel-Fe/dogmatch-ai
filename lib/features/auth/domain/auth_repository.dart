import 'package:equatable/equatable.dart';

/// Vertrag fuer die Authentifizierung. Implementierungen koennen Firebase
/// oder ein Mock sein; UI sieht nur diese Schnittstelle.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.isAnonymous = true,
  });

  final String id;
  final String? email;
  final String? displayName;
  final bool isAnonymous;

  @override
  List<Object?> get props => [id, email, displayName, isAnonymous];
}

abstract interface class AuthRepository {
  /// Liefert den aktuell angemeldeten Nutzer (oder null).
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  /// Loggt anonym ein. Auf Firebase wird ein Anonymous-Account erzeugt.
  Future<AppUser> signInAnonymously();

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
