import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/data/photo_picker.dart' as picker;
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/health/domain/health_event.dart';
import 'package:dogmatch_ai/features/health/presentation/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddHealthEventScreen extends ConsumerStatefulWidget {
  const AddHealthEventScreen({super.key});

  @override
  ConsumerState<AddHealthEventScreen> createState() =>
      _AddHealthEventScreenState();
}

class _AddHealthEventScreenState extends ConsumerState<AddHealthEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _dogId;
  HealthEventType _type = HealthEventType.vaccination;
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  String? _docName;
  String? _docDataUrl;

  Future<void> _pickDoc() async {
    try {
      final result = await picker.pickDocument();
      if (result != null && mounted) {
        setState(() {
          _docName = result.name;
          _docDataUrl = result.dataUrl;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_dogId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte einen Hund waehlen.')),
      );
      return;
    }
    final event = HealthEvent(
      id: 'h-${DateTime.now().microsecondsSinceEpoch}',
      dogId: _dogId!,
      type: _type,
      date: _date,
      title: _titleCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      documentName: _docName,
      documentDataUrl: _docDataUrl,
    );
    await ref.read(healthProvider.notifier).addEvent(event);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final dogs = ref.watch(dogsProvider).value?.dogs ?? const [];
    _dogId ??= dogs.isNotEmpty
        ? (ref.read(dogsProvider).value?.activeDog?.id ?? dogs.first.id)
        : null;

    if (dogs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Termin hinzufuegen')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets_outlined, size: 64),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Du brauchst zuerst einen Hund, um Termine anzulegen.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () {
                  context.pop();
                  context.push(AppRoutes.addDog);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Hund anlegen'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Termin hinzufuegen')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _dogId,
              decoration: const InputDecoration(labelText: 'Hund'),
              items: [
                for (final d in dogs)
                  DropdownMenuItem(value: d.id, child: Text(d.name)),
              ],
              onChanged: (v) => setState(() => _dogId = v),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<HealthEventType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Typ'),
              items: [
                for (final t in HealthEventType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _type = v);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Titel *',
                hintText: 'z. B. Tollwut-Auffrischung',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Titel fehlt' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Datum',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(DateFormat.yMMMMd('de').format(_date)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notiz (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            // Dokument-Anhang (#18): PDF/Bild zum Termin (z. B. Befund, E-Mail).
            if (_docDataUrl == null)
              OutlinedButton.icon(
                onPressed: _pickDoc,
                icon: const Icon(Icons.attach_file_rounded),
                label: const Text('Dokument anhaengen (PDF/Bild)'),
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_rounded),
                title: Text(_docName ?? 'Dokument',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() {
                    _docName = null;
                    _docDataUrl = null;
                  }),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
