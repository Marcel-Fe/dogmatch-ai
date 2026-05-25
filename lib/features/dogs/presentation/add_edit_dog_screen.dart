import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/data/photo_picker.dart' as picker;
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Anlegen oder Bearbeiten eines Hundes. [dogId] = null heisst "Neuer Hund".
class AddEditDogScreen extends ConsumerStatefulWidget {
  const AddEditDogScreen({super.key, this.dogId});

  final String? dogId;

  @override
  ConsumerState<AddEditDogScreen> createState() => _AddEditDogScreenState();
}

class _AddEditDogScreenState extends ConsumerState<AddEditDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _birthday;
  String? _photoBase64;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _weightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _hydrateFrom(Dog dog) {
    if (_initialized) return;
    _nameCtrl.text = dog.name;
    _breedCtrl.text = dog.breed ?? '';
    _weightCtrl.text = dog.weightKg?.toString() ?? '';
    _notesCtrl.text = dog.notes ?? '';
    _birthday = dog.birthday;
    _photoBase64 = dog.photoBase64;
    _initialized = true;
  }

  Future<void> _pickPhoto() async {
    try {
      final result = await picker.pickImageAsDataUrl();
      if (result != null && mounted) {
        setState(() => _photoBase64 = result);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 3),
      firstDate: DateTime(now.year - 25),
      lastDate: now,
      helpText: 'Geburtstag waehlen',
    );
    if (picked != null) {
      setState(() => _birthday = picked);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final notifier = ref.read(dogsProvider.notifier);
    final existing = widget.dogId == null
        ? null
        : ref.read(dogsProvider).value?.dogs.firstWhere(
              (d) => d.id == widget.dogId,
              orElse: () => Dog(id: widget.dogId!, name: ''),
            );

    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    final dog = (existing ??
            Dog(
              id: 'dog-${DateTime.now().microsecondsSinceEpoch}',
              name: '',
            ))
        .copyWith(
      name: _nameCtrl.text.trim(),
      breed: _breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim(),
      clearBreed: _breedCtrl.text.trim().isEmpty,
      birthday: _birthday,
      clearBirthday: _birthday == null,
      weightKg: weight,
      clearWeight: weight == null,
      photoBase64: _photoBase64,
      clearPhoto: _photoBase64 == null,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      clearNotes: _notesCtrl.text.trim().isEmpty,
    );

    if (existing == null) {
      await notifier.addDog(dog);
    } else {
      await notifier.updateDog(dog);
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final dogsAsync = ref.watch(dogsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dogId == null ? 'Neuer Hund' : 'Hund bearbeiten'),
      ),
      body: dogsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (state) {
          if (widget.dogId != null) {
            final existing = state.dogs.firstWhere(
              (d) => d.id == widget.dogId,
              orElse: () => Dog(id: widget.dogId!, name: ''),
            );
            _hydrateFrom(existing);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Center(
                  child: Stack(
                    children: [
                      DogAvatar(size: 120, photoBase64: _photoBase64),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: theme.colorScheme.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _pickPhoto,
                            child: const Padding(
                              padding: EdgeInsets.all(AppSpacing.sm),
                              child: Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name *'),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name fehlt' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _breedCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Rasse (optional)',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: _pickBirthday,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Geburtstag (optional)',
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _birthday == null
                          ? 'Tippen zum waehlen'
                          : DateFormat.yMMMMd('de').format(_birthday!),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Gewicht in kg (optional)',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notizen (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Speichern'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
