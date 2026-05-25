import 'package:dogmatch_ai/features/health/domain/health_event.dart';

abstract interface class HealthRepository {
  Future<List<HealthEvent>> loadEvents();
  Future<void> saveEvents(List<HealthEvent> events);
}
