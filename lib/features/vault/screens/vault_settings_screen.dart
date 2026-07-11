import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/vault_auth_service.dart';
import '../data/vault_encryption_service.dart';
import '../data/vault_offline_cache_service.dart';
import '../data/vault_repository.dart';
import '../data/vault_settings_repository.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_pin_pad.dart';
import 'vault_onboarding_screen.dart';

/// EduVault Settings: Change PIN, biometrics, auto backup/sync, storage
/// usage, delete vault, export vault.
class VaultSettingsScreen extends ConsumerStatefulWidget {
  const VaultSettingsScreen({super.key});

  @override
  ConsumerState<VaultSettingsScreen> createState() =>
      _VaultSettingsScreenState();
}

class _VaultSettingsScreenState extends ConsumerState<VaultSettingsScreen> {
  bool _exporting = false;
  bool _deleting = false;

  Future<void> _changePin() async {
    final oldPinController = VaultPinPadController();
    final verified = await showDialog<bool>(
      context: context,
      builder: (ctx) => _PinDialog(
        title: 'Enter current PIN',
        controller: oldPinController,
        onComplete: (pin) async {
          final ok = await ref.read(vaultAuthServiceProvider).verifyPin(pin);
          if (ok) {
            if (ctx.mounted) Navigator.of(ctx).pop(true);
          } else {
            oldPinController.shake();
            if (ctx.mounted) showAppSnack(ctx, 'Incorrect PIN.');
          }
        },
      ),
    );
    if (verified != true || !mounted) return;

    final newPinController = VaultPinPadController();
    String? firstEntry;
    final newPin = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => _PinDialog(
          title: firstEntry == null ? 'Enter new PIN' : 'Confirm new PIN',
          controller: newPinController,
          onComplete: (pin) async {
            if (firstEntry == null) {
              firstEntry = pin;
              newPinController.clear();
              setDialogState(() {});
            } else if (pin == firstEntry) {
              if (ctx.mounted) Navigator.of(ctx).pop(pin);
            } else {
              newPinController.shake();
              firstEntry = null;
              setDialogState(() {});
              if (ctx.mounted) {
                showAppSnack(ctx, "PINs didn't match. Start over.");
              }
            }
          },
        ),
      ),
    );
    if (newPin != null && mounted) {
      await ref.read(vaultAuthServiceProvider).setPin(newPin);
      if (mounted) showAppSnack(context, 'PIN updated.', error: false);
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    final auth = ref.read(vaultAuthServiceProvider);
    if (value) {
      final result = await auth.authenticateWithBiometrics();
      if (result != VaultBiometricResult.success) {
        if (mounted) {
          showAppSnack(context,
              'Could not verify your fingerprint/face. Biometrics not enabled.');
        }
        return;
      }
    }
    await auth.setBiometricEnabled(value);
    ref.invalidate(vaultBiometricEnabledProvider);
  }

  Future<void> _exportVault() async {
    setState(() => _exporting = true);
    try {
      final docs = ref.read(vaultDocumentsProvider).valueOrNull ?? const [];
      final manifest = {
        'exportedAt': DateTime.now().toIso8601String(),
        'fileCount': docs.length,
        'documents': docs
            .map((d) => {
                  'name': d.name,
                  'folderId': d.folderId,
                  'documentType': d.documentType,
                  'sizeBytes': d.sizeBytes,
                  'createdAt': d.createdAt.toIso8601String(),
                  'tags': d.tags,
                })
            .toList(),
      };
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/eduvault_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file
          .writeAsString(const JsonEncoder.withIndent('  ').convert(manifest));
      if (!mounted) return;
      await ShareService.shareFile(file, text: 'EduVault document list export');
    } catch (_) {
      if (mounted) showAppSnack(context, 'Could not export your vault.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _deleteVault() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF102040),
        title:
            const Text('Delete Vault?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This permanently deletes every document, folder, and your PIN/biometric setup. This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Everything',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await ref.read(vaultRepositoryProvider).deleteEverything();
      await ref.read(vaultAuthServiceProvider).resetSecurity();
      await ref.read(vaultOfflineCacheServiceProvider).clearAll();
      ref.read(vaultEncryptionServiceProvider).clearCache();
      ref.read(vaultUnlockedProvider.notifier).state = false;
      ref.invalidate(vaultSetupCompleteProvider);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const VaultOnboardingScreen()),
        (route) => false,
      );
    } catch (_) {
      if (mounted) {
        showAppSnack(context, 'Could not delete your vault. Try again.');
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(vaultStatsProvider);
    final biometricsAvailable =
        ref.watch(vaultBiometricsAvailableProvider).valueOrNull ?? false;
    final biometricEnabled =
        ref.watch(vaultBiometricEnabledProvider).valueOrNull ?? false;
    final autoBackup =
        ref.watch(vaultAutoBackupEnabledProvider).valueOrNull ?? true;
    final autoSync =
        ref.watch(vaultAutoSyncEnabledProvider).valueOrNull ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduVault Settings'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _SectionCard(
                title: 'Security',
                children: [
                  _SettingsTile(
                    icon: Icons.pin_rounded,
                    label: 'Change PIN',
                    onTap: _changePin,
                  ),
                  if (biometricsAvailable)
                    _SettingsSwitchTile(
                      icon: Icons.fingerprint_rounded,
                      label: 'Enable Biometrics',
                      value: biometricEnabled,
                      onChanged: _toggleBiometrics,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Backup & Sync',
                children: [
                  _SettingsSwitchTile(
                    icon: Icons.cloud_upload_outlined,
                    label: 'Auto Backup',
                    subtitle:
                        'Cache new uploads on this device for offline access',
                    value: autoBackup,
                    onChanged: (v) async {
                      await ref
                          .read(vaultSettingsRepositoryProvider)
                          .setAutoBackupEnabled(v);
                      ref.invalidate(vaultAutoBackupEnabledProvider);
                    },
                  ),
                  _SettingsSwitchTile(
                    icon: Icons.sync_rounded,
                    label: 'Auto Sync',
                    subtitle:
                        'Always fetch the latest copy when opening a document',
                    value: autoSync,
                    onChanged: (v) async {
                      await ref
                          .read(vaultSettingsRepositoryProvider)
                          .setAutoSyncEnabled(v);
                      ref.invalidate(vaultAutoSyncEnabledProvider);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Storage',
                children: [
                  _InfoTile(
                      icon: Icons.description_outlined,
                      label: 'Total Files',
                      value: '${stats.fileCount}'),
                  _InfoTile(
                      icon: Icons.sd_storage_outlined,
                      label: 'Storage Used',
                      value: stats.storageUsedLabel),
                  _SettingsTile(
                    icon: Icons.ios_share_rounded,
                    label: _exporting ? 'Exporting…' : 'Export Vault',
                    onTap: _exporting ? null : _exportVault,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Danger Zone',
                borderColor: Colors.red.withValues(alpha: 0.3),
                children: [
                  _SettingsTile(
                    icon: Icons.delete_forever_rounded,
                    label: _deleting ? 'Deleting…' : 'Delete Vault',
                    labelColor: Colors.redAccent,
                    onTap: _deleting ? null : _deleteVault,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDialog extends StatelessWidget {
  const _PinDialog(
      {required this.title,
      required this.controller,
      required this.onComplete});

  final String title;
  final VaultPinPadController controller;
  final ValueChanged<String> onComplete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF102040),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            VaultPinPad(controller: controller, onComplete: onComplete),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard(
      {required this.title, required this.children, this.borderColor});

  final String title;
  final List<Widget> children;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.labelColor});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: labelColor ?? AppColors.accent),
      title: Text(label,
          style: TextStyle(
              color: labelColor ?? Colors.white, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white30),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      secondary: Icon(icon, color: AppColors.accent),
      title: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent),
      title: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      trailing: Text(value,
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w600)),
    );
  }
}
