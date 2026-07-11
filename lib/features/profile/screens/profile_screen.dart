import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/education/education_stage.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../auth/data/auth_repository.dart';
import '../../vault/screens/vault_gate_screen.dart';
import '../models/user_profile.dart';
import '../providers/profile_providers.dart';

/// Read-only view of the signed-in student's saved profile. Reached by tapping
/// the avatar in any dashboard header.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _stageLabels = {
    EducationStage.class8to10: 'Class 8–10',
    EducationStage.class11: 'Class 11',
    EducationStage.class12: 'Class 12',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: profileAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load your profile.',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(currentProfileProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (profile) {
            if (profile == null) {
              return const Center(
                child: Text('No profile found.',
                    style: TextStyle(color: Colors.white70)),
              );
            }
            return _ProfileBody(profile: profile);
          },
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = EducationClassifier.classify(
      classOrYear: profile.classOrYear,
      educationLevel: profile.educationLevel,
    );
    final stageLabel = ProfileScreen._stageLabels[stage] ?? '';
    final hasPhoto = profile.photoUrl != null && profile.photoUrl!.isNotEmpty;

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                    image: hasPhoto
                        ? DecorationImage(
                            image: NetworkImage(profile.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasPhoto
                      ? null
                      : const Icon(Icons.person,
                          size: 64, color: Colors.white54),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: const TextStyle(color: Colors.white60, fontSize: 14.5),
                ),
                const SizedBox(height: 12),
                if (stageLabel.isNotEmpty) _StageBadge(label: stageLabel),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _Section(title: 'Personal', rows: [
            _Field(Icons.phone_outlined, 'Phone', profile.phone),
            _Field(Icons.cake_outlined, 'Date of Birth', profile.dob),
            _Field(Icons.wc_outlined, 'Gender', profile.gender),
            _Field(Icons.location_on_outlined, 'State / UT', profile.state),
          ]),
          const SizedBox(height: 18),
          _Section(title: 'Education', rows: [
            _Field(Icons.menu_book_outlined, 'Class', profile.classOrYear),
            _Field(Icons.apartment_outlined, 'School', profile.schoolOrCollege),
            if (profile.branch.trim().isNotEmpty)
              _Field(Icons.account_tree_outlined, 'Stream', profile.branch),
          ]),
          const SizedBox(height: 18),
          _Section(title: 'Goals', rows: [
            _Field(Icons.flag_outlined, 'Career Goal', profile.careerGoal),
            _Field(
              Icons.task_alt_outlined,
              'Assessment',
              profile.assessmentCompleted ? 'Completed' : 'Not taken yet',
            ),
          ]),
          const SizedBox(height: 18),
          _EduVaultTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const VaultGateScreen()),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.go(Routes.welcome);
              },
              icon: const Icon(Icons.logout, color: Color(0xFFF87171)),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFFF87171),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0x55F87171)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EduVaultTile extends StatelessWidget {
  const _EduVaultTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.22),
              AppColors.accent.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.lock_rounded,
                  color: AppColors.accent, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EduVault',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('Secure Student Digital Locker',
                      style: TextStyle(color: Colors.white60, fontSize: 12.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

class _StageBadge extends StatelessWidget {
  const _StageBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<_Field> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                rows[i],
                if (i != rows.length - 1)
                  Divider(
                    color: Colors.white.withValues(alpha: 0.07),
                    height: 1,
                    indent: 54,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final display = value.trim().isEmpty ? 'Not provided' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(
                  display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
