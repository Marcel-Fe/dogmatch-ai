import 'package:dogmatch_ai/features/health/data/local_health_repository.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/domain/health_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return const LocalHealthRepository();
});

class HealthNotifier extends AsyncNotifier<List<HealthEvent>> {
  @override
  Future<List<HealthEvent>> build() {
    return ref.read(healthRepositoryProvider).loadEvents();
  }

  Future<void> _persist(List<HealthEvent> next) async {
    state = AsyncData(next);
    await ref.read(healthRepositoryProvider).saveEvents(next);
  }

  Future<void> addEvent(HealthEvent event) async {
    final current = state.value ?? const [];
    await _persist([...current, event]);
  }

  Future<void> updateEvent(HealthEvent updated) async {
    final current = state.value ?? const [];
    final next = [
      for (final e in current) if (e.id == updated.id) updated else e,
    ];
    await _persist(next);
  }

  Future<void> removeEvent(String id) async {
    final current = state.value ?? const [];
    await _persist(current.where((e) => e.id != id).toList());
  }

  Future<void> toggleDone(String id) async {
    final current = state.value ?? const [];
    final next = [
      for (final e in current) if (e.id == id) e.copyWith(done: !e.done) else e,
    ];
    await _persist(next);
  }
}

final healthProvider =
    AsyncNotifierProvider<HealthNotifier, List<HealthEvent>>(
  HealthNotifier.new,
);

/// Liefert bevorstehende Termine sortiert nach Datum (aufsteigend).
final upcomingHealthEventsProvider = Provider<List<HealthEvent>>((ref) {
  final events = ref.watch(healthProvider).value ?? const [];
  final upcoming = events.where((e) => e.isUpcoming).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return upcoming;
});
