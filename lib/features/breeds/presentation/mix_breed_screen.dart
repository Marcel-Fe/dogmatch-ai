import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/breed_card.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Mischlings-Wesensrechner. Der Nutzer waehlt die vermuteten Rassen
/// seines Mischlings; die App mittelt die Wesens-Eigenschaften und bietet
/// eine KI-Einschaetzung an.
class MixBreedScreen extends ConsumerStatefulWidget {
  const MixBreedScreen({super.key});

  @override
  ConsumerState<MixBreedScreen> createState() => _MixBreedScreenState();
}

class _MixBreedScreenState extends ConsumerState<MixBreedScreen> {
  final List<DogBreed> _selected = [];
  static const _maxBreeds = 3;

  void _addBreed(DogBreed b) {
    if (_selected.any((x) => x.id == b.id)) return;
    if (_selected.length >= _maxBreeds) return;
    setState(() => _selected.add(b));
  }

  void _removeBreed(String id) {
    setState(() => _selected.removeWhere((x) => x.id == id));
  }

  int _avg(int Function(DogBreed) sel) {
    if (_selected.isEmpty) return 0;
    final sum = _selected.map(sel).reduce((a, b) => a + b);
    return (sum / _selected.length).round();
  }

  Future<void> _pickBreed(List<DogBreed> all) async {
    final taken = _selected.map((b) => b.id).toSet();
    final pool = all.where((b) => !taken.contains(b.id)).toList();
    final picked = await showModalBottomSheet<DogBreed>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _BreedPickerSheet(breeds: pool),
    );
    if (picked != null) _addBreed(picked);
  }

  void _discussWithAi() {
    final names = _selected.map((b) => b.name).join(' x ');
    final prompt =
        'Mein Hund ist vermutlich ein Mischling aus diesen Rassen: $names. '
        'Was kann ich ueber sein Wesen, seinen Bewegungsbedarf, seine '
        'Erziehung und moegliche gesundheitliche Themen erwarten? Bitte '
        'erklaere, dass bei Mischlingen die Eigenschaften stark variieren '
        'koennen, und gib mir praktische Tipps fuer den Alltag.';
    ref.read(assistantHandoffProvider.notifier).queue(
          AssistantHandoff(
            prompt: prompt,
            mode: ChatMode.advisor,
            origin: AppRoutes.mixBreed,
          ),
        );
    context.go(AppRoutes.assistant);
  }

  @override
  Widget build(BuildContext context) {
    final breedsAsync = ref.watch(breedsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mischling-Wesensrechner')),
      body: breedsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Rassen konnten nicht geladen werden.',
          onRetry: () => ref.invalidate(breedsProvider),
        ),
        data: (all) => _buildContent(context, all),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<DogBreed> all) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.merge_type_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Kein reinrassiger Hund? Waehle die Rassen, die in deinem '
                  'Mischling stecken koennten. Die App schaetzt daraus ein '
                  'gemischtes Wesensprofil. Bei Mischlingen kann das echte '
                  'Wesen aber stark abweichen.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text('Vermutete Rassen (${_selected.length}/$_maxBreeds)',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        for (final b in _selected)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                BreedThumbnail(breed: b, size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(b.name, style: theme.textTheme.titleSmall)),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Entfernen',
                  onPressed: () => _removeBreed(b.id),
                ),
              ],
            ),
          ),
        if (_selected.length < _maxBreeds)
          OutlinedButton.icon(
            onPressed: () => _pickBreed(all),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Rasse hinzufuegen'),
          ),
        const SizedBox(height: AppSpacing.lg),

        if (_selected.length < 2)
          Text(
            'Waehle mindestens 2 Rassen, um ein gemischtes Profil zu sehen.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else ...[
          Text('Geschaetztes Wesensprofil', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _FactRow(
            label: 'Gewicht (Spanne)',
            value: '${_minWeight().round()} - ${_maxWeight().round()} kg',
          ),
          _FactRow(
            label: 'Lebenserwartung',
            value: '~${_avgLife()} Jahre',
          ),
          const SizedBox(height: AppSpacing.md),
          RatingBar(
              label: 'Anfaengerfreundlich',
              value: _avg((b) => b.beginnerFriendliness)),
          RatingBar(
              label: 'Kinderfreundlich',
              value: _avg((b) => b.childFriendliness)),
          RatingBar(label: 'Trainierbarkeit', value: _avg((b) => b.trainability)),
          RatingBar(label: 'Bewegungsbedarf', value: _avg((b) => b.exerciseNeed)),
          RatingBar(label: 'Pflegeaufwand', value: _avg((b) => b.grooming)),
          RatingBar(label: 'Fellverlust', value: _avg((b) => b.shedding)),
          const SizedBox(height: AppSpacing.md),
          if (_combinedTraits().isNotEmpty) ...[
            Text('Moegliche Eigenschaften', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [for (final t in _combinedTraits()) _Chip(text: t)],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_combinedHealth().isNotEmpty) ...[
            Text('Moegliche Gesundheitsthemen',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [for (final h in _combinedHealth()) _Chip(text: h)],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          FilledButton.icon(
            onPressed: _discussWithAi,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('Mischling mit dem KI-Berater besprechen'),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Das Profil ist ein gemittelter Richtwert. Jeder Mischling ist '
            'individuell - das echte Wesen zeigt sich erst im Alltag.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  double _minWeight() =>
      _selected.map((b) => b.weightKgMin).reduce((a, b) => a < b ? a : b);
  double _maxWeight() =>
      _selected.map((b) => b.weightKgMax).reduce((a, b) => a > b ? a : b);
  int _avgLife() =>
      (_selected.map((b) => b.lifeExpectancyYears).reduce((a, b) => a + b) /
              _selected.length)
          .round();

  /// Vereint die Eigenschaften aller gewaehlten Rassen (ohne Duplikate),
  /// hoechstens zehn, damit die Anzeige nicht ausufert.
  List<String> _combinedTraits() {
    final set = <String>{};
    for (final b in _selected) {
      set.addAll(b.traits);
    }
    return set.take(10).toList();
  }

  List<String> _combinedHealth() {
    final set = <String>{};
    for (final b in _selected) {
      set.addAll(b.commonHealthIssues);
    }
    return set.take(10).toList();
  }
}

/// Bottom-Sheet zur Rassen-Auswahl mit Suchfeld.
class _BreedPickerSheet extends StatefulWidget {
  const _BreedPickerSheet({required this.breeds});

  final List<DogBreed> breeds;

  @override
  State<_BreedPickerSheet> createState() => _BreedPickerSheetState();
}

class _BreedPickerSheetState extends State<_BreedPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? widget.breeds
        : widget.breeds
            .where((b) => b.name.toLowerCase().contains(q))
            .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rasse suchen ...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final b = filtered[index];
                  return ListTile(
                    leading: BreedThumbnail(breed: b, size: 40),
                    title: Text(b.name),
                    subtitle: Text(b.origin),
                    onTap: () => Navigator.of(context).pop(b),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }
}
