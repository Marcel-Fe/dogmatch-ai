import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sortier-Optionen fuer die Rassen-Liste.
enum BreedSort {
  alphabetic('Alphabetisch'),
  beginnerFriendly('Anfaengerfreundlich'),
  smallToLarge('Klein zuerst'),
  largeToSmall('Gross zuerst');

  const BreedSort(this.label);
  final String label;
}

/// Aktuelle Filter-/Such-/Sortier-Einstellungen. Wert-Klasse,
/// equatable - so kann Riverpod unnoetige Rebuilds vermeiden.
class BreedFilter extends Equatable {
  const BreedFilter({
    this.query = '',
    this.sizes = const {},
    this.energyLevels = const {},
    this.apartmentOnly = false,
    this.beginnerOnly = false,
    this.sort = BreedSort.alphabetic,
  });

  final String query;
  final Set<DogSize> sizes;
  final Set<ActivityLevel> energyLevels;
  final bool apartmentOnly;
  final bool beginnerOnly;
  final BreedSort sort;

  bool get isActive =>
      query.isNotEmpty ||
      sizes.isNotEmpty ||
      energyLevels.isNotEmpty ||
      apartmentOnly ||
      beginnerOnly ||
      sort != BreedSort.alphabetic;

  BreedFilter copyWith({
    String? query,
    Set<DogSize>? sizes,
    Set<ActivityLevel>? energyLevels,
    bool? apartmentOnly,
    bool? beginnerOnly,
    BreedSort? sort,
  }) {
    return BreedFilter(
      query: query ?? this.query,
      sizes: sizes ?? this.sizes,
      energyLevels: energyLevels ?? this.energyLevels,
      apartmentOnly: apartmentOnly ?? this.apartmentOnly,
      beginnerOnly: beginnerOnly ?? this.beginnerOnly,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props =>
      [query, sizes, energyLevels, apartmentOnly, beginnerOnly, sort];
}

class BreedFilterNotifier extends Notifier<BreedFilter> {
  @override
  BreedFilter build() => const BreedFilter();

  void setQuery(String q) => state = state.copyWith(query: q);
  void toggleSize(DogSize s) {
    final next = {...state.sizes};
    next.contains(s) ? next.remove(s) : next.add(s);
    state = state.copyWith(sizes: next);
  }

  void toggleEnergy(ActivityLevel a) {
    final next = {...state.energyLevels};
    next.contains(a) ? next.remove(a) : next.add(a);
    state = state.copyWith(energyLevels: next);
  }

  void toggleApartment() =>
      state = state.copyWith(apartmentOnly: !state.apartmentOnly);
  void toggleBeginner() =>
      state = state.copyWith(beginnerOnly: !state.beginnerOnly);
  void setSort(BreedSort s) => state = state.copyWith(sort: s);
  void clear() => state = const BreedFilter();
}

final breedFilterProvider =
    NotifierProvider<BreedFilterNotifier, BreedFilter>(
  BreedFilterNotifier.new,
);

/// Liefert die gefilterte + sortierte Rassen-Liste basierend auf
/// [breedsProvider] und [breedFilterProvider].
final filteredBreedsProvider = Provider<List<DogBreed>>((ref) {
  final all = ref.watch(breedsProvider).value ?? const <DogBreed>[];
  final f = ref.watch(breedFilterProvider);

  Iterable<DogBreed> list = all;

  if (f.query.isNotEmpty) {
    final q = f.query.toLowerCase().trim();
    list = list.where((b) {
      if (b.name.toLowerCase().contains(q)) return true;
      if (b.origin.toLowerCase().contains(q)) return true;
      if (b.temperament.toLowerCase().contains(q)) return true;
      if (b.traits.any((t) => t.toLowerCase().contains(q))) return true;
      return false;
    });
  }

  if (f.sizes.isNotEmpty) {
    list = list.where((b) => f.sizes.contains(b.size));
  }
  if (f.energyLevels.isNotEmpty) {
    list = list.where((b) => f.energyLevels.contains(b.energyLevel));
  }
  if (f.apartmentOnly) {
    list = list.where((b) => b.apartmentSuitable == true);
  }
  if (f.beginnerOnly) {
    list = list.where((b) => b.beginnerFriendliness >= 4);
  }

  final result = list.toList();
  switch (f.sort) {
    case BreedSort.alphabetic:
      result.sort((a, b) => a.name.compareTo(b.name));
    case BreedSort.beginnerFriendly:
      result.sort((a, b) =>
          b.beginnerFriendliness.compareTo(a.beginnerFriendliness));
    case BreedSort.smallToLarge:
      result.sort((a, b) =>
          a.weightKgMax.compareTo(b.weightKgMax));
    case BreedSort.largeToSmall:
      result.sort((a, b) =>
          b.weightKgMax.compareTo(a.weightKgMax));
  }
  return result;
});
