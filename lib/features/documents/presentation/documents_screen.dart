import 'dart:convert';

import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/app_card.dart';
import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:dogmatch_ai/features/documents/domain/document.dart';
import 'package:dogmatch_ai/features/documents/presentation/documents_controller.dart';
import 'package:dogmatch_ai/features/dogs/data/photo_picker.dart' as picker;
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Digitale Dokumentenablage. Hochladen, ansehen, loeschen.
/// Max. 2 MB pro Datei in Phase A (SharedPreferences-Limit).
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsProvider);
    final dogsState = ref.watch(dogsProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Dokumente')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickAndAdd(context, ref),
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Hochladen'),
      ),
      body: docsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (docs) {
          if (docs.isEmpty) {
            return EmptyView(
              icon: Icons.folder_open_outlined,
              title: 'Noch keine Dokumente',
              message:
                  'Speichere Impfpass, Tierarzt-Berichte oder Versicherungs-'
                  'unterlagen. Aktuell PDF/JPG bis 2 MB pro Datei.',
              action: FilledButton.icon(
                onPressed: () => _pickAndAdd(context, ref),
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Erstes Dokument hochladen'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: docs.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final dogName = dogsState?.dogs
                      .where((d) => d.id == doc.dogId)
                      .map((d) => d.name)
                      .firstOrNull ??
                  'Unbekannt';
              return _DocTile(
                doc: doc,
                dogName: dogName,
                onOpen: () => _openDoc(context, doc),
                onDelete: () =>
                    ref.read(documentsProvider.notifier).removeDocument(doc.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _pickAndAdd(BuildContext context, WidgetRef ref) async {
    final dogs = ref.read(dogsProvider).value?.dogs ?? const [];
    if (dogs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lege zuerst einen Hund an.')),
      );
      return;
    }

    try {
      final result = await picker.pickDocument();
      if (result == null) return;
      final activeDogId =
          ref.read(dogsProvider).value?.activeDog?.id ?? dogs.first.id;
      final doc = DogDocument(
        id: 'doc-${DateTime.now().microsecondsSinceEpoch}',
        dogId: activeDogId,
        name: result.name,
        mimeType: result.mimeType,
        dataUrl: result.dataUrl,
        sizeBytes: result.sizeBytes,
        addedAt: DateTime.now(),
      );
      await ref.read(documentsProvider.notifier).addDocument(doc);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  void _openDoc(BuildContext context, DogDocument doc) {
    if (doc.isImage) {
      showDialog<void>(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: _DocumentImageView(doc: doc),
          ),
        ),
      );
    } else {
      try {
        picker.openDataUrl(doc.dataUrl);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vorschau hier nicht unterstuetzt.'),
          ),
        );
      }
    }
  }
}

bool _isRemoteUrl(String url) =>
    url.startsWith('http://') || url.startsWith('https://');

class _DocumentImageView extends StatelessWidget {
  const _DocumentImageView({required this.doc});

  final DogDocument doc;

  @override
  Widget build(BuildContext context) {
    if (_isRemoteUrl(doc.dataUrl)) {
      return InteractiveViewer(
        child: Image.network(
          doc.dataUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Center(
            child: Text(
              'Bild kann nicht geladen werden.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    final base64Part =
        doc.dataUrl.contains(',') ? doc.dataUrl.split(',').last : doc.dataUrl;
    Uint8List bytes;
    try {
      bytes = base64Decode(base64Part);
    } catch (_) {
      return const Center(
        child: Text('Bild kann nicht angezeigt werden.',
            style: TextStyle(color: Colors.white)),
      );
    }
    return InteractiveViewer(
      child: Image.memory(bytes, fit: BoxFit.contain),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({
    required this.doc,
    required this.dogName,
    required this.onOpen,
    required this.onDelete,
  });

  final DogDocument doc;
  final String dogName;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  String get _sizeLabel {
    final kb = doc.sizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = doc.isPdf
        ? Icons.picture_as_pdf_outlined
        : doc.isImage
            ? Icons.image_outlined
            : Icons.insert_drive_file_outlined;
    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            alignment: Alignment.center,
            child: Icon(iconData, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  '$dogName · $_sizeLabel · '
                  '${DateFormat.yMd('de').format(doc.addedAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Loeschen',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
