import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local (per-device) EduVault preferences — not synced, since they only
/// affect this device's own caching/refresh behavior.
class VaultSettingsRepository {
  static const _autoBackupKey = 'vault_auto_backup_enabled';
  static const _autoSyncKey = 'vault_auto_sync_enabled';

  Future<bool> autoBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoBackupKey) ?? true;
  }

  Future<void> setAutoBackupEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoBackupKey, value);
  }

  /// When on, opening a document always re-fetches from the network first
  /// (freshest copy, then refreshes the offline cache). When off, a cached
  /// copy is served instantly if one exists, favoring speed/offline-first.
  Future<bool> autoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSyncKey) ?? true;
  }

  Future<void> setAutoSyncEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSyncKey, value);
  }
}

final vaultSettingsRepositoryProvider = Provider<VaultSettingsRepository>(
  (ref) => VaultSettingsRepository(),
);

final vaultAutoBackupEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(vaultSettingsRepositoryProvider).autoBackupEnabled(),
);

final vaultAutoSyncEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(vaultSettingsRepositoryProvider).autoSyncEnabled(),
);
