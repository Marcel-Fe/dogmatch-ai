import 'package:dogmatch_ai/features/premium/data/local_premium_repository.dart';
import 'package:dogmatch_ai/features/premium/domain/premium_repository.dart';
import 'package:dogmatch_ai/features/premium/domain/premium_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  return const LocalPremiumRepository();
});

/// Haelt den Premium-Status. Aktivierung / Deaktivierung speichert sofort
/// lokal; kein Zahlungs-Anbieter angebunden (Demo-Tier).
class PremiumStatusNotifier extends AsyncNotifier<PremiumStatus> {
  @override
  Future<PremiumStatus> build() {
    return ref.read(premiumRepositoryProvider).load();
  }

  Future<void> activate() async {
    final next = PremiumStatus(
      tier: PremiumTier.premium,
      activatedAt: DateTime.now(),
    );
    state = AsyncData(next);
    await ref.read(premiumRepositoryProvider).save(next);
  }

  Future<void> deactivate() async {
    const next = PremiumStatus();
    state = const AsyncData(next);
    await ref.read(premiumRepositoryProvider).save(next);
  }
}

final premiumStatusProvider =
    AsyncNotifierProvider<PremiumStatusNotifier, PremiumStatus>(
  PremiumStatusNotifier.new,
);

/// Bequemer Getter: ist der Nutzer aktuell Premium? Default false bis
/// der Status geladen ist.
final isPremiumProvider = Provider<bool>((ref) {
  final status = ref.watch(premiumStatusProvider).value;
  return status?.isPremium ?? false;
});
