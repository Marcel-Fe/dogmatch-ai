import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:dogmatch_ai/features/profile/domain/user_preferences.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Bearbeitbarer Profil-Screen. Aenderungen werden sofort persistiert,
/// wenn der Nutzer "Speichern" tippt.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  TextEditingController? _name;
  Country? _country;
  DogSize? _size;
  ActivityLevel? _activity;
  bool _initialized = false;

  void _ensureInit(UserPreferences prefs) {
    if (_initialized) return;
    _name = TextEditingController(text: prefs.displayName ?? '');
    _country = prefs.country;
    _size = prefs.preferredSize;
    _activity = prefs.preferredActivity;
    _initialized = true;
  }

  @override
  void dispose() {
    _name?.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final trimmed = _name!.text.trim();
    final next = UserPreferences(
      displayName: trimmed.isEmpty ? null : trimmed,
      country: _country ?? Country.germany,
      preferredSize: _size,
      preferredActivity: _activity,
    );
    await ref.read(userPreferencesProvider.notifier).save(next);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil bearbeiten')),
      body: prefsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => const Center(child: Text('Profil nicht ladbar.')),
        data: (prefs) {
          _ensureInit(prefs);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _SectionLabel('Dein Name'),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: 'Wie sollen wir dich nennen?',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Land'),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<Country>(
                initialValue: _country,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final c in Country.values)
                    DropdownMenuItem(value: c, child: Text(c.label)),
                ],
                onChanged: (c) => setState(() => _country = c),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Wir zeigen dir Hinweise (z.B. Listenhund-Status, Reisen) '
                'passend zu deinem Land an.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Bevorzugte Groesse (optional)'),
              const SizedBox(height: AppSpacing.sm),
              _SizeSelector(
                value: _size,
                onChanged: (v) => setState(() => _size = v),
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Bevorzugtes Aktivitaetsniveau (optional)'),
              const SizedBox(height: AppSpacing.sm),
              _ActivitySelector(
                value: _activity,
                onChanged: (v) => setState(() => _activity = v),
              ),
              const SizedBox(height: AppSpacing.xxl),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Speichern'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.value, required this.onChanged});

  final DogSize? value;
  final ValueChanged<DogSize?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _ChoicePill(
          label: 'Egal',
          selected: value == null,
          onTap: () => onChanged(null),
        ),
        for (final s in DogSize.values)
          _ChoicePill(
            label: s.label,
            selected: value == s,
            onTap: () => onChanged(s),
          ),
      ],
    );
  }
}

class _ActivitySelector extends StatelessWidget {
  const _ActivitySelector({required this.value, required this.onChanged});

  final ActivityLevel? value;
  final ValueChanged<ActivityLevel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _ChoicePill(
          label: 'Egal',
          selected: value == null,
          onTap: () => onChanged(null),
        ),
        for (final a in ActivityLevel.values)
          _ChoicePill(
            label: a.label,
            selected: value == a,
            onTap: () => onChanged(a),
          ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
