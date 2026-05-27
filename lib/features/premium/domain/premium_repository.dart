import 'package:dogmatch_ai/features/premium/domain/premium_status.dart';

abstract class PremiumRepository {
  Future<PremiumStatus> load();
  Future<void> save(PremiumStatus status);
}
