import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_folder_card.dart';
import '../widgets/vault_new_folder_sheet.dart';
import '../widgets/vault_skeleton.dart';
import 'vault_folder_screen.dart';

/// Every folder — the 7 curated presets plus any custom folders — with a way
/// to create more.
class VaultFoldersScreen extends ConsumerWidget {
  const VaultFoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(vaultAllFoldersProvider);
    final stats = ref.watch(vaultStatsProvider);
    final loading = ref.watch(vaultDocumentsProvider).isLoading &&
        !ref.watch(vaultDocumentsProvider).hasValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showVaultNewFolderSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.create_new_folder_rounded, color: Colors.white),
        label: const Text('New Folder',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
            child: loading
                ? const VaultFolderGridSkeleton(count: 8)
                : GridView.builder(
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
                              builder: (_) =>
                                  VaultFolderScreen(folder: folder)),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
