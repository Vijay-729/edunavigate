import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/models/user_profile.dart';
import '../../profile/providers/profile_providers.dart';
import '../../profile/screens/profile_screen.dart';
import '../../vault/screens/vault_gate_screen.dart';

/// Shared shell for every stage dashboard. Resolves the signed-in profile once
/// and renders a consistent header (greeting, avatar, logout), the persistent
/// AI Mentor FAB, and the stage-specific [slivers] supplied by each dashboard.
class DashboardScaffold extends ConsumerWidget {
  const DashboardScaffold({
    super.key,
    required this.badge,
    required this.slivers,
  });

  /// Short stage label shown under the greeting, e.g. "Class 8–10".
  final String badge;

  /// Stage-specific content slivers, built once the profile is available.
  final List<Widget> Function(BuildContext context, UserProfile profile)
      slivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => const _DashboardMessage(loading: true),
      error: (_, __) => _DashboardMessage(
        message: 'Could not load your dashboard. Please try again.',
        onRetry: () => ref.invalidate(currentProfileProvider),
      ),
      data: (profile) {
        if (profile == null || !profile.isComplete) {
          return const _IncompleteProfilePrompt();
        }
        return Scaffold(
          extendBody: true,
          floatingActionButton: AiMentorFab(profile: profile),
          body: GradientBackground(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.bgBottom,
              onRefresh: () async => ref.invalidate(currentProfileProvider),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: _Header(profile: profile, badge: badge),
                  ),
                  ...slivers(context, profile),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.profile, required this.badge});

  final UserProfile profile;
  final String badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final first = profile.name.trim().isEmpty
        ? 'there'
        : profile.name.trim().split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openProfile(context),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              backgroundImage:
                  (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                      ? NetworkImage(profile.photoUrl!)
                      : null,
              child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.white70)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () => _openProfile(context),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $first 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'EduVault',
            icon: const Icon(Icons.lock_outline_rounded, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const VaultGateScreen()),
            ),
          ),
          IconButton(
            tooltip: 'My profile',
            icon: const Icon(Icons.account_circle_outlined,
                color: Colors.white70),
            onPressed: () => _openProfile(context),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go(Routes.welcome);
            },
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }
}

class _DashboardMessage extends StatelessWidget {
  const _DashboardMessage({
    this.message,
    this.loading = false,
    this.onRetry,
  });

  final String? message;
  final bool loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: AppColors.primary)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message ?? 'Something went wrong.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _IncompleteProfilePrompt extends StatelessWidget {
  const _IncompleteProfilePrompt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle_outlined,
                    color: Colors.white70, size: 72),
                const SizedBox(height: 20),
                const Text(
                  'Finish setting up your profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We need a few details to personalize your dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 15),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => context.go(Routes.photo),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Complete Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
