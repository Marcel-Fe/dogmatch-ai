import 'package:equatable/equatable.dart';

/// Stufe der Premium-Mitgliedschaft. Aktuell zwei Werte, kann spaeter
/// um Familien-/Trainer-Tarife erweitert werden.
enum PremiumTier { free, premium }

/// Zustand der Premium-Mitgliedschaft. Wird lokal persistiert
/// (SharedPreferences); kein echter Zahlungs-Anbieter angebunden.
class PremiumStatus extends Equatable {
  const PremiumStatus({
    this.tier = PremiumTier.free,
    this.activatedAt,
  });

  final PremiumTier tier;
  final DateTime? activatedAt;

  bool get isPremium => tier == PremiumTier.premium;

  PremiumStatus copyWith({PremiumTier? tier, DateTime? activatedAt}) {
    return PremiumStatus(
      tier: tier ?? this.tier,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }

  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    final tierName = json['tier'] as String?;
    final activatedRaw = json['activatedAt'] as String?;
    return PremiumStatus(
      tier: tierName == null
          ? PremiumTier.free
          : PremiumTier.values.firstWhere(
              (t) => t.name == tierName,
              orElse: () => PremiumTier.free,
            ),
      activatedAt:
          activatedRaw == null ? null : DateTime.tryParse(activatedRaw),
    );
  }

  Map<String, dynamic> toJson() => {
        'tier': tier.name,
        'activatedAt': activatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [tier, activatedAt];
}
