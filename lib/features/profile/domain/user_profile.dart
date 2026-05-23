import 'package:equatable/equatable.dart';

/// Profil des Nutzers. In Phase 1 nur lokal; spaeter mit Firebase Auth
/// verknuepft.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.displayName,
    this.email,
    this.isGuest = true,
    this.isPremium = false,
  });

  /// Erzeugt ein anonymes Gast-Profil.
  factory UserProfile.guest() {
    return const UserProfile(id: 'guest', displayName: 'Gast');
  }

  final String id;
  final String displayName;
  final String? email;
  final bool isGuest;
  final bool isPremium;

  UserProfile copyWith({
    String? displayName,
    String? email,
    bool? isGuest,
    bool? isPremium,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [id, displayName, email, isGuest, isPremium];
}
