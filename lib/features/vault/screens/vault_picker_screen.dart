import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/vault_document.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_document_card.dart';
import '../widgets/vault_skeleton.dart';
import 'vault_lock_screen.dart';
import 'vault_onboarding_screen.dart';

/// Entry point for other features to reuse EduVault as a document source —
/// "Choose from EduVault" instead of a bare file upload. Standalone for now
/// (per product decision): no other module calls this yet, but it's ready to
/// be wired in without any EduVault-side changes once that integration pass
/// happens.
///
/// Returns the documents the student selected, or `null` if they backed out.
Future<List<VaultDocument>?> pickFromVault(
  BuildContext context, {
  bool allowMultiple = false,
}) {
  return Navigator.of(context).push<List<VaultDocument>>(
    MaterialPageRoute(
      builder: (_) => VaultPickerEntryScreen(allowMultiple: allowMultiple),
    ),
  );
}

/// Gate shown when [pickFromVault] is invoked: routes to onboarding/lock if
/// needed, then to [VaultPickerScreen] once authenticated.
class VaultPickerEntryScreen extends ConsumerWidget {
  const VaultPickerEntryScreen({super.key, required this.allowMultiple});

  final bool allowMultiple;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupComplete = ref.watch(vaultSetupCompleteProvider);
    final unlocked = ref.watch(vaultUnlockedProvider);

    return setupComplete.when(
      loading: () => const _PickerLoading(),
      error: (_, __) => const _PickerLoading(),
      data: (isSetup) {
        if (!isSetup) {
          return _NeedsSetupPrompt(
            onSetup: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const VaultOnboardingScreen()),
            ),
          );
        }
        if (!unlocked) {
          return VaultLockScreen(
            onUnlocked: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => VaultPickerScreen(allowMultiple: allowMultiple),
              ),
            ),
          );
        }
        return VaultPickerScreen(allowMultiple: allowMultiple);
      },
    );
  }
}

class _PickerLoading extends StatelessWidget {
  const _PickerLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        child:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
    );
  }
}

class _NeedsSetupPrompt extends StatelessWidget {
  const _NeedsSetupPrompt({required this.onSetup});

  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      color: Colors.white54, size: 48),
                  const SizedBox(height: 18),
                  const Text('Set up EduVault first',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    'Create your secure vault to store and choose documents from here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13.5),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    child: const Text('Setup EduVault',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Search + folder-filtered grid the student picks one or more documents
/// from.
class VaultPickerScreen extends ConsumerStatefulWidget {
  const VaultPickerScreen({super.key, required this.allowMultiple});

  final bool allowMultiple;

  @override
  ConsumerState<VaultPickerScreen> createState() => _VaultPickerScreenState();
}

class _VaultPickerScreenState extends ConsumerState<VaultPickerScreen> {
  String? _folderFilter;
  final _selected = <VaultDocument>{};
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(VaultDocument doc) {
    if (!widget.allowMultiple) {
      Navigator.of(context).pop([doc]);
      return;
    }
    setState(() {
      if (_selected.contains(doc)) {
        _selected.remove(doc);
      } else {
        _selected.add(doc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(vaultDocumentsProvider);
    final loading = documentsAsync.isLoading && !documentsAsync.hasValue;
    final allDocs = documentsAsync.valueOrNull ?? const [];
    final folders = ref.watch(vaultAllFoldersProvider);

    var docs = _folderFilter == null
        ? allDocs
        : allDocs.where((d) => d.folderId == _folderFilter).toList();
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      docs = docs
          .where((d) =>
              d.name.toLowerCase().contains(q) ||
              (d.documentType ?? '').toLowerCase().contains(q))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose from EduVault'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: widget.allowMultiple
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: ElevatedButton(
                  onPressed: _selected.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_selected.toList()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _selected.isEmpty
                        ? 'Select documents'
                        : 'Use ${_selected.length} document${_selected.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search your documents…',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _FolderChip(
                        label: 'All',
                        selected: _folderFilter == null,
                        onTap: () => setState(() => _folderFilter = null)),
                    const SizedBox(width: 8),
                    for (final folder in folders) ...[
                      _FolderChip(
                        label: folder.name,
                        selected: _folderFilter == folder.id,
                        onTap: () => setState(() => _folderFilter = folder.id),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: loading
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: VaultFolderGridSkeleton(count: 6),
                      )
                    : docs.isEmpty
                        ? Center(
                            child: Text('No documents here yet.',
                                style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.55))),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 160,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.86,
                            ),
                            itemBuilder: (context, i) {
                              final doc = docs[i];
                              return VaultDocumentCard(
                                document: doc,
                                width: double.infinity,
                                selected: _selected.contains(doc),
                                onTap: () => _toggle(doc),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderChip extends StatelessWidget {
  const _FolderChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? AppColors.accent : Colors.white70,
                fontSize: 12.5,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
