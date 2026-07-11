import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import 'vault_pin_setup_screen.dart';

/// First-run welcome screen shown before "Setup EduVault" has ever been
/// completed on this account.
class VaultOnboardingScreen extends StatelessWidget {
  const VaultOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock_rounded,
                      color: Colors.white, size: 64),
                ),
                const SizedBox(height: 36),
                const Text(
                  '🔒 Welcome to EduVault',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Your secure student digital locker.\n'
                  'Encrypted. Private. Always available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 15.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                const _FeatureRow(
                  icon: Icons.enhance_photo_translate_rounded,
                  text:
                      'Every document is encrypted before it leaves your device',
                ),
                const SizedBox(height: 14),
                const _FeatureRow(
                  icon: Icons.fingerprint_rounded,
                  text: 'Unlock with your PIN, fingerprint, or Face ID',
                ),
                const SizedBox(height: 14),
                const _FeatureRow(
                  icon: Icons.folder_special_rounded,
                  text:
                      'Aadhaar, marksheets, admit cards — all organized automatically',
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Setup EduVault',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const VaultPinSetupScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13.5,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
