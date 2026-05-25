import 'package:dogmatch_ai/features/auth/presentation/auth_controller.dart';
import 'package:dogmatch_ai/features/dogs/data/firestore_dog_repository.dart';
import 'package:dogmatch_ai/features/dogs/data/local_dog_repository.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Liefert Firestore-Repo wenn ein User eingeloggt ist, sonst lokal.
/// Bei Auth-Wechsel rebuildet Riverpod den Provider automatisch.
final dogRepositoryProvider = Provider<DogRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return FirestoreDogRepository(userId: user.id);
  }
  return const LocalDogRepository();
});

/// Gesamtzustand der Hunde: alle Hunde + aktive Auswahl.
class DogsState extends Equatable {
  const DogsState({this.dogs = const [], this.activeDogId});

  final List<Dog> dogs;
  final String? activeDogId;

  Dog? get activeDog {
    if (dogs.isEmpty) return null;
    if (activeDogId == null) return dogs.first;
    return dogs.firstWhere(
      (d) => d.id == activeDogId,
      orElse: () => dogs.first,
    );
  }

  bool get hasDog => dogs.isNotEmpty;

  DogsState copyWith({List<Dog>? dogs, String? activeDogId}) {
    return DogsState(
      dogs: dogs ?? this.dogs,
      activeDogId: activeDogId ?? this.activeDogId,
    );
  }

  @override
  List<Object?> get props => [dogs, activeDogId];
}

/// Steuert die Hunde-Liste: anlegen, bearbeiten, loeschen, aktivieren.
/// Persistiert nach jeder Aenderung sofort. Bewusst keine `update`-Methode -
/// der Name ist in Riverpod 3 von AsyncNotifier belegt.
class DogsNotifier extends AsyncNotifier<DogsState> {
  @override
  Future<DogsState> build() async {
    final repo = ref.read(dogRepositoryProvider);
    final dogs = await repo.loadDogs();
    final active = await repo.loadActiveDogId();
    return DogsState(dogs: dogs, activeDogId: active);
  }

  Future<void> _persistDogs(List<Dog> dogs) async {
    await ref.read(dogRepositoryProvider).saveDogs(dogs);
  }

  Future<void> addDog(Dog dog) async {
    final current = state.value ?? const DogsState();
    final next = [...current.dogs, dog];
    state = AsyncData(
      current.copyWith(
        dogs: next,
        activeDogId: current.activeDogId ?? dog.id,
      ),
    );
    await _persistDogs(next);
    if (current.activeDogId == null) {
      await ref.read(dogRepositoryProvider).saveActiveDogId(dog.id);
    }
  }

  Future<void> updateDog(Dog updated) async {
    final current = state.value ?? const DogsState();
    final next = [
      for (final d in current.dogs) if (d.id == updated.id) updated else d,
    ];
    state = AsyncData(current.copyWith(dogs: next));
    await _persistDogs(next);
  }

  Future<void> removeDog(String id) async {
    final current = state.value ?? const DogsState();
    final next = current.dogs.where((d) => d.id != id).toList();
    final newActive = current.activeDogId == id
        ? (next.isEmpty ? null : next.first.id)
        : current.activeDogId;
    state = AsyncData(DogsState(dogs: next, activeDogId: newActive));
    await _persistDogs(next);
    await ref.read(dogRepositoryProvider).saveActiveDogId(newActive);
  }

  Future<void> setActive(String id) async {
    final current = state.value ?? const DogsState();
    state = AsyncData(current.copyWith(activeDogId: id));
    await ref.read(dogRepositoryProvider).saveActiveDogId(id);
  }
}

final dogsProvider = AsyncNotifierProvider<DogsNotifier, DogsState>(
  DogsNotifier.new,
);
