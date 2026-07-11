import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/vault_document.dart';
import '../models/vault_folder.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_document_card.dart';
import '../widgets/vault_folder_card.dart';
import '../widgets/vault_skeleton.dart';
import '../widgets/vault_upload_sheet.dart';
import 'vault_document_detail_screen.dart';
import 'vault_expiry_screen.dart';
import 'vault_folder_screen.dart';
import 'vault_folders_screen.dart';
import 'vault_scanner_screen.dart';
import 'vault_search_screen.dart';
import 'vault_settings_screen.dart';

/// EduVault home — storage stats, quick actions, recent/favourite rails and
/// the folder grid. Reached only after PIN/biometric unlock ([VaultGateScreen]).
class VaultHomeScreen extends ConsumerWidget {
  const VaultHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(vaultDocumentsProvider);
    final loading = documentsAsync.isLoading && !documentsAsync.hasValue;
    final stats = ref.watch(vaultStatsProvider);
    final folders = ref.watch(vaultAllFoldersProvider);
    final recent = ref.watch(vaultRecentUploadsProvider);
    final recentlyUsed = ref.watch(vaultRecentlyUsedProvider);
    final favorites = ref.watch(vaultFavoritesProvider);
    final expiring = ref.watch(vaultExpiringDocumentsProvider);
    final isEmpty = !loading && stats.fileCount == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduVault'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const VaultSearchScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const VaultSettingsScreen()),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.bgBottom,
            onRefresh: () async {
              ref.invalidate(vaultDocumentsProvider);
              ref.invalidate(vaultCustomFoldersProvider);
            },
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
              children: [
                if (expiring.isNotEmpty) ...[
                  _ExpiryBanner(count: expiring.length),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.sd_storage_rounded,
                        label: 'Storage Used',
                        value: stats.storageUsedLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.description_rounded,
                        label: 'Files Uploaded',
                        value: '${stats.fileCount}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _QuickActions(
                  onUpload: () => showVaultUploadSheet(context,
                      folderId: VaultFolders.other.id),
                  onScan: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          VaultScannerScreen(folderId: VaultFolders.other.id),
                    ),
                  ),
                  onSearch: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const VaultSearchScreen()),
                  ),
                  onFolders: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const VaultFoldersScreen()),
                  ),
                ),
                const SizedBox(height: 28),
                if (isEmpty) ...[
                  _GetStartedCard(
                    onUpload: () => showVaultUploadSheet(context,
                        folderId: VaultFolders.other.id),
                  ),
                ] else ...[
                  if (loading)
                    const VaultDocumentRailSkeleton()
                  else if (recent.isNotEmpty)
                    _DocumentRail(
                      title: 'Recent Uploads',
                      documents: recent,
                    ),
                  if (recentlyUsed.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _DocumentRail(
                        title: 'Recently Used', documents: recentlyUsed),
                  ],
                  if (favorites.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _DocumentRail(
                        title: 'Favourite Documents', documents: favorites),
                  ],
                ],
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Folders',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const VaultFoldersScreen()),
                      ),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (loading)
                  const VaultFolderGridSkeleton()
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: folders.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    itemBuilder: (context, i) {
                      final folder = folders[i];
                      return VaultFolderCard(
                        folder: folder,
                        count: stats.folderCounts[folder.id] ?? 0,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VaultFolderScreen(folder: folder),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpiryBanner extends StatelessWidget {
  const _ExpiryBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const VaultExpiryScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                count == 1
                    ? '1 document is expiring soon'
                    : '$count documents need your attention',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onUpload,
    required this.onScan,
    required this.onSearch,
    required this.onFolders,
  });

  final VoidCallback onUpload;
  final VoidCallback onScan;
  final VoidCallback onSearch;
  final VoidCallback onFolders;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _ActionButton(
                icon: Icons.upload_rounded, label: 'Upload', onTap: onUpload)),
        const SizedBox(width: 10),
        Expanded(
            child: _ActionButton(
                icon: Icons.document_scanner_rounded,
                label: 'Scan',
                onTap: onScan)),
        const SizedBox(width: 10),
        Expanded(
            child: _ActionButton(
                icon: Icons.search_rounded, label: 'Search', onTap: onSearch)),
        const SizedBox(width: 10),
        Expanded(
            child: _ActionButton(
                icon: Icons.folder_rounded,
                label: 'Folders',
                onTap: onFolders)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DocumentRail extends StatelessWidget {
  const _DocumentRail({required this.title, required this.documents});

  final String title;
  final List<VaultDocument> documents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final doc = documents[i];
              return VaultDocumentCard(
                document: doc,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => VaultDocumentDetailScreen(document: doc)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GetStartedCard extends StatelessWidget {
  const _GetStartedCard({required this.onUpload});

  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: AppColors.primaryGradient),
            child: const Icon(Icons.cloud_upload_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your vault is ready',
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload your first document — Aadhaar, marksheet, admit card — and EduVault will organize it for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                height: 1.4),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('Upload Document',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
