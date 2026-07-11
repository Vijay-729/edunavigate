import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/vault_auth_service.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_pin_pad.dart';
import 'vault_home_screen.dart';

/// Shown every time EduVault is opened (after first-time setup) until the
/// student authenticates for this app session — PIN always available,
/// fingerprint/Face unlock offered when the device supports it.
class VaultLockScreen extends ConsumerStatefulWidget {
  const VaultLockScreen({super.key, this.onUnlocked});

  /// When provided, called instead of navigating to [VaultHomeScreen] once
  /// unlocked — used by the "Choose from EduVault" picker entry point, which
  /// wants to show its own picker screen after unlock rather than the home
  /// dashboard.
  final VoidCallback? onUnlocked;

  @override
  ConsumerState<VaultLockScreen> createState() => _VaultLockScreenState();
}

class _VaultLockScreenState extends ConsumerState<VaultLockScreen> {
  final _controller = VaultPinPadController();
  bool _checking = false;
  bool _biometricEnabled = false;
  bool _triedAutoBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricFlag();
  }

  Future<void> _loadBiometricFlag() async {
    final enabled =
        await ref.read(vaultAuthServiceProvider).isBiometricEnabled();
    if (!mounted) return;
    setState(() => _biometricEnabled = enabled);
    if (enabled && !_triedAutoBiometric) {
      _triedAutoBiometric = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
    }
  }

  Future<void> _tryBiometric() async {
    if (_checking) return;
    setState(() => _checking = true);
    final result =
        await ref.read(vaultAuthServiceProvider).authenticateWithBiometrics();
    if (!mounted) return;
    setState(() => _checking = false);
    if (result == VaultBiometricResult.success) {
      _unlock();
    } else if (result == VaultBiometricResult.lockedOut) {
      showAppSnack(context, 'Too many attempts. Use your PIN instead.');
    }
  }

  Future<void> _onPinEntered(String pin) async {
    setState(() => _checking = true);
    final ok = await ref.read(vaultAuthServiceProvider).verifyPin(pin);
    if (!mounted) return;
    setState(() => _checking = false);
    if (ok) {
      _unlock();
    } else {
      showAppSnack(context, 'Incorrect PIN.');
      _controller.shake();
    }
  }

  void _unlock() {
    ref.read(vaultUnlockedProvider.notifier).state = true;
    if (widget.onUnlocked != null) {
      widget.onUnlocked!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const VaultHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: const Icon(Icons.lock_rounded,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Unlock EduVault',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your PIN to continue',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                ),
                const SizedBox(height: 36),
                if (_checking)
                  const CircularProgressIndicator(color: AppColors.primary)
                else
                  VaultPinPad(
                    controller: _controller,
                    onComplete: _onPinEntered,
                    showBiometricButton: _biometricEnabled,
                    onBiometricTap: _tryBiometric,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
