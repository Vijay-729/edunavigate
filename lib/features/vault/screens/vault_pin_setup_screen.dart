import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/vault_auth_service.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_pin_pad.dart';
import 'vault_home_screen.dart';

/// Set-a-6-digit-PIN step of "Setup EduVault", followed by an optional
/// biometric opt-in when the device supports it.
class VaultPinSetupScreen extends ConsumerStatefulWidget {
  const VaultPinSetupScreen({super.key});

  @override
  ConsumerState<VaultPinSetupScreen> createState() =>
      _VaultPinSetupScreenState();
}

enum _Step { enter, confirm, biometric }

class _VaultPinSetupScreenState extends ConsumerState<VaultPinSetupScreen> {
  final _controller = VaultPinPadController();
  _Step _step = _Step.enter;
  String _firstPin = '';
  bool _saving = false;

  void _onDigitsEntered(String value) {
    if (_step == _Step.enter) {
      setState(() {
        _firstPin = value;
        _step = _Step.confirm;
      });
      _controller.clear();
      return;
    }
    if (_step == _Step.confirm) {
      if (value != _firstPin) {
        showAppSnack(context, "PINs didn't match. Try again.");
        setState(() {
          _step = _Step.enter;
          _firstPin = '';
        });
        _controller.shake();
        return;
      }
      _finishPinSetup(value);
    }
  }

  Future<void> _finishPinSetup(String pin) async {
    setState(() => _saving = true);
    try {
      await ref.read(vaultAuthServiceProvider).setPin(pin);
      final biometricsAvailable =
          await ref.read(vaultAuthServiceProvider).biometricsAvailable;
      if (!mounted) return;
      if (biometricsAvailable) {
        setState(() {
          _step = _Step.biometric;
          _saving = false;
        });
      } else {
        _enterVault();
      }
    } catch (_) {
      if (mounted) {
        showAppSnack(context, 'Could not save your PIN. Try again.');
        setState(() {
          _saving = false;
          _step = _Step.enter;
          _firstPin = '';
        });
      }
    }
  }

  Future<void> _enableBiometricsAndEnter() async {
    setState(() => _saving = true);
    await ref.read(vaultAuthServiceProvider).setBiometricEnabled(true);
    _enterVault();
  }

  void _enterVault() {
    ref.read(vaultUnlockedProvider.notifier).state = true;
    ref.invalidate(vaultSetupCompleteProvider);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const VaultHomeScreen()),
      (route) => route.settings.name == '/dashboard' || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _step == _Step.confirm
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _step = _Step.enter;
                  _firstPin = '';
                  _controller.clear();
                }),
              )
            : null,
        automaticallyImplyLeading: _step != _Step.biometric,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: _step == _Step.biometric
              ? _buildBiometricStep()
              : _buildPinStep(),
        ),
      ),
    );
  }

  Widget _buildPinStep() {
    final title =
        _step == _Step.enter ? 'Create your EduVault PIN' : 'Confirm your PIN';
    final subtitle = _step == _Step.enter
        ? 'Choose a 6-digit PIN to protect your documents.'
        : 'Enter the same PIN again to confirm.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pin_rounded, color: AppColors.accent, size: 48),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
          ),
          const SizedBox(height: 36),
          if (_saving)
            const CircularProgressIndicator(color: AppColors.primary)
          else
            VaultPinPad(controller: _controller, onComplete: _onDigitsEntered),
        ],
      ),
    );
  }

  Widget _buildBiometricStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.fingerprint_rounded,
                color: AppColors.accent, size: 52),
          ),
          const SizedBox(height: 28),
          const Text(
            'Enable biometric unlock?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            'Use your fingerprint or face to open EduVault faster next time. '
            'You can always change this later in Settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.4),
          ),
          const SizedBox(height: 32),
          if (_saving)
            const CircularProgressIndicator(color: AppColors.primary)
          else ...[
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _enableBiometricsAndEnter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Enable Biometric Unlock',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _enterVault,
              child: const Text('Not now',
                  style: TextStyle(color: Colors.white60)),
            ),
          ],
        ],
      ),
    );
  }
}
