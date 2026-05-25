import 'package:dogmatch_ai/features/auth/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final fb.FirebaseAuth _auth;

  AppUser? _map(fb.User? user) => user == null
      ? null
      : AppUser(
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
          isAnonymous: user.isAnonymous,
        );

  @override
  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  AppUser? get currentUser => _map(_auth.currentUser);

  @override
  Future<AppUser> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    return _map(cred.user)!;
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _map(cred.user)!;
  }

  @override
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _map(cred.user)!;
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
