import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/vault_folder.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_document_card.dart';
import '../widgets/vault_skeleton.dart';
import '../widgets/vault_upload_sheet.dart';
import 'vault_document_detail_screen.dart';

/// Documents inside a single folder (preset or custom) — with the folder's
/// suggested document types offered as quick upload shortcuts.
class VaultFolderScreen extends ConsumerWidget {
  const VaultFolderScreen({super.key, required this.folder});

  final VaultFolder folder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(vaultDocumentsProvider);
    final loading = documentsAsync.isLoading && !documentsAsync.hasValue;
    final documents = ref.watch(vaultDocumentsByFolderProvider(folder.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showVaultUploadSheet(context, folderId: folder.id),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Upload',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
            children: [
              if (folder.suggestedTypes.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: folder.suggestedTypes
                      .map((type) => GestureDetector(
                            onTap: () => showVaultUploadSheet(
                              context,
                              folderId: folder.id,
                              documentTypeHint: type,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: folder.color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        folder.color.withValues(alpha: 0.35)),
                              ),
                              child: Text(type,
                                  style: TextStyle(
                                      color: folder.color,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
              if (loading)
                const VaultDocumentRailSkeleton(count: 4)
              else if (documents.isEmpty)
                _EmptyFolder(folder: folder)
              else
                ...documents.map(
                  (doc) => VaultDocumentListTile(
                    document: doc,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              VaultDocumentDetailScreen(document: doc)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFolder extends StatelessWidget {
  const _EmptyFolder({required this.folder});

  final VaultFolder folder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: folder.color.withValues(alpha: 0.15)),
            child: Icon(folder.icon, color: folder.color, size: 32),
          ),
          const SizedBox(height: 18),
          Text('Nothing in ${folder.name} yet',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Tap Upload to add your first document here.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 12.5)),
        ],
      ),
    );
  }
}
