import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/vault_offline_cache_service.dart';
import '../data/vault_repository.dart';
import '../data/vault_settings_repository.dart';
import '../models/vault_document.dart';
import '../models/vault_folder.dart';
import '../providers/vault_providers.dart';

/// Full document view: preview, download, rename, move, copy, delete, share,
/// favourite, notes, tags and expiry — everything the spec's "Document Page"
/// calls for.
class VaultDocumentDetailScreen extends ConsumerStatefulWidget {
  const VaultDocumentDetailScreen({super.key, required this.document});

  final VaultDocument document;

  @override
  ConsumerState<VaultDocumentDetailScreen> createState() =>
      _VaultDocumentDetailScreenState();
}

class _VaultDocumentDetailScreenState
    extends ConsumerState<VaultDocumentDetailScreen> {
  Uint8List? _bytes;
  bool _loading = true;
  bool _failed = false;
  late VaultDocument _document;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _document = widget.document;
    _notesController.text = _document.notes;
    _load();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final cache = ref.read(vaultOfflineCacheServiceProvider);
    final autoSync =
        await ref.read(vaultSettingsRepositoryProvider).autoSyncEnabled();

    if (!autoSync) {
      final cached = await cache.read(_document.id);
      if (cached != null) {
        if (!mounted) return;
        setState(() {
          _bytes = cached;
          _loading = false;
        });
        unawaited(ref.read(vaultRepositoryProvider).recordViewed(_document.id));
        return;
      }
    }

    try {
      final bytes = await ref
          .read(vaultRepositoryProvider)
          .downloadDecryptedBytes(_document);
      await ref.read(vaultRepositoryProvider).recordViewed(_document.id);
      unawaited(cache.write(_document.id, bytes));
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        _loading = false;
      });
    } catch (_) {
      final cached = await cache.read(_document.id);
      if (cached != null && mounted) {
        setState(() {
          _bytes = cached;
          _loading = false;
        });
        return;
      }
      if (mounted) {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    }
  }

  VaultDocument _refreshFromStream() {
    final all = ref.watch(vaultDocumentsProvider).valueOrNull;
    final latest =
        all?.firstWhere((d) => d.id == _document.id, orElse: () => _document);
    if (latest != null) _document = latest;
    return _document;
  }

  Future<void> _toggleFavorite() async {
    await ref
        .read(vaultRepositoryProvider)
        .toggleFavorite(_document.id, _document.favorite);
  }

  Future<void> _togglePinned() async {
    await ref
        .read(vaultRepositoryProvider)
        .togglePinned(_document.id, _document.pinned);
  }

  Future<void> _rename() async {
    final controller = TextEditingController(text: _document.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF102040),
        title: const Text('Rename document',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty && mounted) {
      await ref
          .read(vaultRepositoryProvider)
          .renameDocument(_document.id, newName);
    }
  }

  Future<void> _pickFolder({required String title}) async {
    final folders = ref.read(vaultAllFoldersProvider);
    final selected = await showModalBottomSheet<VaultFolder>(
      context: context,
      backgroundColor: AppColors.dropdownSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: folders.length,
                  itemBuilder: (context, i) {
                    final folder = folders[i];
                    return ListTile(
                      leading: Icon(folder.icon, color: folder.color),
                      title: Text(folder.name,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () => Navigator.pop(ctx, folder),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected == null || !mounted) return;
    if (title.startsWith('Move')) {
      await ref
          .read(vaultRepositoryProvider)
          .moveDocument(_document.id, selected.id);
    } else {
      await ref
          .read(vaultRepositoryProvider)
          .copyDocument(_document, toFolderId: selected.id);
      if (mounted) {
        showAppSnack(context, 'Copied to ${selected.name}', error: false);
      }
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF102040),
        title: const Text('Delete document?',
            style: TextStyle(color: Colors.white)),
        content: Text(
            '"${_document.name}" will be permanently removed from your vault.',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(vaultRepositoryProvider).deleteDocument(_document);
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _share() async {
    final bytes = _bytes;
    if (bytes == null) return;
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${_document.name}');
      await file.writeAsBytes(bytes);
      await ShareService.shareFile(file, text: _document.name);
    } catch (_) {
      if (mounted) showAppSnack(context, 'Could not share this document.');
    }
  }

  Future<void> _download() async {
    final bytes = _bytes;
    if (bytes == null) return;
    try {
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      final target = dir ?? await getApplicationDocumentsDirectory();
      final file = File('${target.path}/${_document.name}');
      await file.writeAsBytes(bytes);
      if (mounted) {
        showAppSnack(context, 'Saved to device storage.', error: false);
      }
    } catch (_) {
      if (mounted) showAppSnack(context, 'Download failed.');
    }
  }

  Future<void> _editTags() async {
    final controller = TextEditingController(text: _document.tags.join(', '));
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF102040),
        title: const Text('Edit tags', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'comma, separated, tags',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Save')),
        ],
      ),
    );
    if (result != null && mounted) {
      final tags = result
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      await ref.read(vaultRepositoryProvider).updateTags(_document.id, tags);
    }
  }

  Future<void> _editExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _document.expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      await ref
          .read(vaultRepositoryProvider)
          .updateExpiryDate(_document.id, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = _refreshFromStream();
    final folder = ref.watch(vaultFolderByIdProvider(doc.folderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(doc.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: doc.favorite ? 'Unfavourite' : 'Favourite',
            icon: Icon(
                doc.favorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: doc.favorite ? const Color(0xFFFBBF24) : Colors.white70),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: _bytes == null ? null : _share,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
            color: const Color(0xFF102040),
            onSelected: (value) {
              switch (value) {
                case 'rename':
                  _rename();
                case 'move':
                  _pickFolder(title: 'Move to…');
                case 'copy':
                  _pickFolder(title: 'Copy to…');
                case 'pin':
                  _togglePinned();
                case 'tags':
                  _editTags();
                case 'expiry':
                  _editExpiry();
                case 'delete':
                  _delete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(value: 'move', child: Text('Move')),
              const PopupMenuItem(value: 'copy', child: Text('Copy')),
              PopupMenuItem(
                  value: 'pin', child: Text(doc.pinned ? 'Unpin' : 'Pin')),
              const PopupMenuItem(value: 'tags', child: Text('Edit Tags')),
              const PopupMenuItem(
                  value: 'expiry', child: Text('Set Expiry Date')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete',
                      style: TextStyle(color: Colors.redAccent))),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _buildPreview(doc),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _bytes == null ? null : _download,
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.white70, size: 18),
                      label: const Text('Download',
                          style: TextStyle(color: Colors.white70)),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _togglePinned,
                      icon: Icon(
                          doc.pinned
                              ? Icons.push_pin_rounded
                              : Icons.push_pin_outlined,
                          color: Colors.white70,
                          size: 18),
                      label: Text(doc.pinned ? 'Pinned' : 'Pin',
                          style: const TextStyle(color: Colors.white70)),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _InfoSection(document: doc, folder: folder),
              if (doc.aiSummary != null && doc.aiSummary!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _AiSummaryCard(
                    summary: doc.aiSummary!, blurDetected: doc.blurDetected),
              ],
              if (doc.detectedFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                _DetectedFieldsCard(fields: doc.detectedFields),
              ],
              const SizedBox(height: 16),
              _NotesCard(
                controller: _notesController,
                onSave: (value) => ref
                    .read(vaultRepositoryProvider)
                    .updateNotes(doc.id, value),
              ),
              const SizedBox(height: 16),
              _TagsCard(tags: doc.tags, onEdit: _editTags),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(VaultDocument doc) {
    if (_loading) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_failed || _bytes == null) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: Colors.white38, size: 36),
            const SizedBox(height: 12),
            const Text('Could not load this document',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (doc.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            Image.memory(_bytes!, fit: BoxFit.contain, width: double.infinity),
      );
    }
    if (doc.isPdf) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 480,
          child: SfPdfViewer.memory(_bytes!, enableDoubleTapZooming: true),
        ),
      );
    }
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(doc.typeIcon, color: AppColors.accent, size: 40),
          const SizedBox(height: 12),
          const Text('No inline preview for this file type',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text('Use Share or Download to open it in another app.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.document, required this.folder});

  final VaultDocument document;
  final VaultFolder folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(Icons.folder_rounded, 'Folder', folder.name),
          _row(Icons.description_outlined, 'Type',
              document.documentType ?? document.extension.toUpperCase()),
          _row(Icons.sd_storage_outlined, 'Size', document.sizeLabel),
          _row(Icons.event_outlined, 'Uploaded',
              _formatDate(document.createdAt)),
          if (document.expiryDate != null)
            _row(
              Icons.event_busy_outlined,
              'Expires',
              _formatDate(document.expiryDate!),
              valueColor: document.isExpired
                  ? Colors.redAccent
                  : document.isExpiringSoon
                      ? Colors.orangeAccent
                      : null,
            ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.summary, required this.blurDetected});

  final String summary;
  final bool blurDetected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  color: AppColors.accent, size: 18),
              SizedBox(width: 8),
              Text('AI Summary',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text(summary,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.4)),
          if (blurDetected) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 6),
                Text('This scan looks blurry — consider retaking it.',
                    style: TextStyle(
                        color: Colors.orangeAccent.withValues(alpha: 0.9),
                        fontSize: 12)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetectedFieldsCard extends StatelessWidget {
  const _DetectedFieldsCard({required this.fields});

  final Map<String, String> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detected Details',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fields.entries.map((e) {
              final label = VaultFieldKeys.labels[e.key] ?? e.key;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$label: ${e.value}',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatefulWidget {
  const _NotesCard({required this.controller, required this.onSave});

  final TextEditingController controller;
  final ValueChanged<String> onSave;

  @override
  State<_NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<_NotesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notes',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          TextField(
            controller: widget.controller,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
            decoration: InputDecoration(
              hintText: 'Add a note about this document…',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onEditingComplete: () => widget.onSave(widget.controller.text),
            onTapOutside: (_) => widget.onSave(widget.controller.text),
          ),
        ],
      ),
    );
  }
}

class _TagsCard extends StatelessWidget {
  const _TagsCard({required this.tags, required this.onEdit});

  final List<String> tags;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tags',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              TextButton(onPressed: onEdit, child: const Text('Edit')),
            ],
          ),
          if (tags.isEmpty)
            Text('No tags yet.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5), fontSize: 12.5))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                color: AppColors.accent, fontSize: 12)),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
