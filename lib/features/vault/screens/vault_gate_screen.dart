import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/vault_providers.dart';
import 'vault_home_screen.dart';
import 'vault_lock_screen.dart';
import 'vault_onboarding_screen.dart';

/// Single entry point for EduVault — reached from the AppBar vault icon on
/// every dashboard and from the "EduVault" row on the Profile screen. Decides
/// between first-run onboarding, the PIN/biometric lock screen, or the vault
/// home dashboard depending on setup + this session's unlock state.
class VaultGateScreen extends ConsumerWidget {
  const VaultGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupComplete = ref.watch(vaultSetupCompleteProvider);
    final unlocked = ref.watch(vaultUnlockedProvider);

    return setupComplete.when(
      loading: () => const _Loading(),
      error: (_, __) => const _Loading(),
      data: (isSetup) {
        if (!isSetup) return const VaultOnboardingScreen();
        if (!unlocked) return const VaultLockScreen();
        return const VaultHomeScreen();
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
