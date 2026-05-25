import 'package:dogmatch_ai/features/auth/data/firebase_auth_repository.dart';
import 'package:dogmatch_ai/features/auth/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(fb.FirebaseAuth.instance);
});

/// Streamt den aktuellen Auth-Zustand. Beim ersten Start kein Nutzer, nach
/// `signInAnonymously` ein anonymer User.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
