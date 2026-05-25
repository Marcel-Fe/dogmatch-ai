import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Suchleiste + Filter-Icon ueber der Rassenliste. Tippt der Nutzer auf
/// das Icon, oeffnet sich ein Bottom-Sheet mit Groesse/Energie/Toggles
/// und Sortierung.
class BreedSearchBar extends ConsumerStatefulWidget {
  const BreedSearchBar({super.key});

  @override
  ConsumerState<BreedSearchBar> createState() => _BreedSearchBarState();
}

class _BreedSearchBarState extends ConsumerState<BreedSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(breedFilterProvider).query,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(breedFilterProvider);
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: ref.read(breedFilterProvider.notifier).setQuery,
            decoration: InputDecoration(
              hintText: 'Rasse suchen ...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: filter.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _controller.clear();
                        ref.read(breedFilterProvider.notifier).setQuery('');
                      },
                    )
                  : null,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: filter.isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _openFilters(context),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Icon(
                Icons.tune_rounded,
                color: filter.isActive
                    ? Colors.white
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _FiltersSheet(),
    );
  }
}

class _FiltersSheet extends ConsumerWidget {
  const _FiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(breedFilterProvider);
    final notifier = ref.read(breedFilterProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Filter', style: theme.textTheme.titleLarge),
                ),
                if (filter.isActive)
                  TextButton(
                    onPressed: () {
                      notifier.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Zuruecksetzen'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Groesse', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final s in DogSize.values)
                  FilterChip(
                    label: Text(s.label),
                    selected: filter.sizes.contains(s),
                    onSelected: (_) => notifier.toggleSize(s),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Energielevel', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final a in ActivityLevel.values)
                  FilterChip(
                    label: Text(a.label),
                    selected: filter.energyLevels.contains(a),
                    onSelected: (_) => notifier.toggleEnergy(a),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Nur wohnungstauglich'),
              value: filter.apartmentOnly,
              onChanged: (_) => notifier.toggleApartment(),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Nur fuer Anfaenger geeignet'),
              value: filter.beginnerOnly,
              onChanged: (_) => notifier.toggleBeginner(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Sortierung', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            RadioGroup<BreedSort>(
              groupValue: filter.sort,
              onChanged: (next) {
                if (next != null) notifier.setSort(next);
              },
              child: Column(
                children: [
                  for (final s in BreedSort.values)
                    RadioListTile<BreedSort>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.label),
                      value: s,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fertig'),
            ),
          ],
        ),
      ),
    );
  }
}
