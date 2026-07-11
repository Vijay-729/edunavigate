import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vault_auth_service.dart';
import '../data/vault_repository.dart';
import '../models/vault_document.dart';
import '../models/vault_folder.dart';

/// Live stream of every document metadata row for the signed-in student.
final vaultDocumentsProvider = StreamProvider<List<VaultDocument>>((ref) {
  return ref.watch(vaultRepositoryProvider).watchDocuments();
});

/// Live stream of the student's custom (non-preset) folders.
final vaultCustomFoldersProvider = StreamProvider<List<VaultFolder>>((ref) {
  return ref.watch(vaultRepositoryProvider).watchCustomFolders();
});

/// The 7 curated presets followed by any custom folders the student created.
final vaultAllFoldersProvider = Provider<List<VaultFolder>>((ref) {
  final custom = ref.watch(vaultCustomFoldersProvider).valueOrNull ?? const [];
  return [...VaultFolders.presets, ...custom];
});

VaultFolder _resolveFolder(List<VaultFolder> all, String id) =>
    all.firstWhere((f) => f.id == id, orElse: () => VaultFolders.other);

/// Resolves any folder id (preset or custom) to its [VaultFolder], falling
/// back to "Other" if the folder was deleted.
final vaultFolderByIdProvider = Provider.family<VaultFolder, String>((ref, id) {
  return _resolveFolder(ref.watch(vaultAllFoldersProvider), id);
});

class VaultStats {
  const VaultStats({
    required this.fileCount,
    required this.storageUsedBytes,
    required this.folderCounts,
  });

  final int fileCount;
  final int storageUsedBytes;
  final Map<String, int> folderCounts;

  String get storageUsedLabel {
    if (storageUsedBytes < 1024 * 1024) {
      return '${(storageUsedBytes / 1024).toStringAsFixed(1)} KB';
    }
    if (storageUsedBytes < 1024 * 1024 * 1024) {
      return '${(storageUsedBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(storageUsedBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

final vaultStatsProvider = Provider<VaultStats>((ref) {
  final docs = ref.watch(vaultDocumentsProvider).valueOrNull ?? const [];
  final folderCounts = <String, int>{};
  var totalBytes = 0;
  for (final doc in docs) {
    totalBytes += doc.sizeBytes;
    folderCounts[doc.folderId] = (folderCounts[doc.folderId] ?? 0) + 1;
  }
  return VaultStats(
    fileCount: docs.length,
    storageUsedBytes: totalBytes,
    folderCounts: folderCounts,
  );
});

final vaultRecentUploadsProvider = Provider<List<VaultDocument>>((ref) {
  final docs = <VaultDocument>[
    ...ref.watch(vaultDocumentsProvider).valueOrNull ?? const []
  ];
  docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return docs.take(8).toList();
});

final vaultRecentlyUsedProvider = Provider<List<VaultDocument>>((ref) {
  final docs = (ref.watch(vaultDocumentsProvider).valueOrNull ?? const [])
      .where((d) => d.lastViewedAt != null)
      .toList();
  docs.sort((a, b) => b.lastViewedAt!.compareTo(a.lastViewedAt!));
  return docs.take(8).toList();
});

final vaultFavoritesProvider = Provider<List<VaultDocument>>((ref) {
  return (ref.watch(vaultDocumentsProvider).valueOrNull ?? const [])
      .where((d) => d.favorite)
      .toList();
});

final vaultPinnedProvider = Provider<List<VaultDocument>>((ref) {
  return (ref.watch(vaultDocumentsProvider).valueOrNull ?? const [])
      .where((d) => d.pinned)
      .toList();
});

/// Documents with an expiry date already passed or within 30 days — feeds the
/// expiry-reminder banners/badges.
final vaultExpiringDocumentsProvider = Provider<List<VaultDocument>>((ref) {
  final docs = (ref.watch(vaultDocumentsProvider).valueOrNull ?? const [])
      .where((d) => d.isExpired || d.isExpiringSoon)
      .toList();
  docs.sort((a, b) {
    final ea = a.expiryDate!;
    final eb = b.expiryDate!;
    return ea.compareTo(eb);
  });
  return docs;
});

final vaultDocumentsByFolderProvider =
    Provider.family<List<VaultDocument>, String>((ref, folderId) {
  return (ref.watch(vaultDocumentsProvider).valueOrNull ?? const [])
      .where((d) => d.folderId == folderId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

final vaultSearchQueryProvider = StateProvider<String>((ref) => '');

final vaultSearchResultsProvider = Provider<List<VaultDocument>>((ref) {
  final query = ref.watch(vaultSearchQueryProvider).trim().toLowerCase();
  final docs = ref.watch(vaultDocumentsProvider).valueOrNull ?? const [];
  if (query.isEmpty) return const [];
  final folders = ref.watch(vaultAllFoldersProvider);
  return docs.where((d) {
    final folder = _resolveFolder(folders, d.folderId);
    final haystack = [
      d.name,
      d.documentType ?? '',
      folder.name,
      d.ocrText ?? '',
      ...d.tags,
      ...d.detectedFields.values,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }).toList();
});

/// Whether the student has ever completed "Setup EduVault" on this account.
final vaultSetupCompleteProvider = FutureProvider<bool>((ref) {
  return ref.watch(vaultAuthServiceProvider).isSetupComplete();
});

/// Whether the vault has been unlocked (PIN/biometric) for the current app
/// session — reset every time the app process restarts, so the lock screen
/// always re-appears on a fresh launch.
final vaultUnlockedProvider = StateProvider<bool>((ref) => false);

final vaultBiometricsAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(vaultAuthServiceProvider).biometricsAvailable;
});

final vaultBiometricEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(vaultAuthServiceProvider).isBiometricEnabled();
});

final vaultFaceUnlockAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(vaultAuthServiceProvider).faceUnlockAvailable;
});
