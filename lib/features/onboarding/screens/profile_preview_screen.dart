import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/cache/local_profile_cache.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../../assessment/provider/assessment_controller.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/models/user_profile.dart';
import '../providers/onboarding_controller.dart';

class ProfilePreviewScreen extends ConsumerStatefulWidget {
  const ProfilePreviewScreen({super.key});

  @override
  ConsumerState<ProfilePreviewScreen> createState() =>
      _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends ConsumerState<ProfilePreviewScreen> {
  bool _saving = false;

  Future<void> _finishSetup() async {
    final draft = ref.read(onboardingControllerProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;
    final uid = user?.uid;
    if (uid == null) {
      return showAppSnack(context, 'Session expired. Please sign up again.');
    }

    // Never persist an empty name — it would make the profile look incomplete
    // and bounce the user back into onboarding.
    final name = draft.name.trim().isNotEmpty
        ? draft.name.trim()
        : (user?.displayName?.trim().isNotEmpty ?? false)
            ? user!.displayName!.trim()
            : (user?.email?.split('@').first ?? 'Student');
    final email = draft.email.trim().isNotEmpty
        ? draft.email.trim()
        : (user?.email ?? '');

    setState(() => _saving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);

      String? photoUrl;
      if (draft.photo != null) {
        // A failed upload returns null and must not block saving the profile.
        photoUrl = await repo.uploadProfilePhoto(uid, draft.photo!);
      }

      final profile = UserProfile(
        uid: uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        phone: draft.phone,
        dob: draft.dob,
        gender: draft.gender ?? '',
        state: draft.state ?? '',
        schoolOrCollege: draft.schoolOrCollege,
        educationLevel: draft.educationLevel ?? '',
        classOrYear: draft.classOrYear ?? '',
        branch: draft.branch,
        careerGoal: draft.careerGoal ?? '',
      );

      await repo.saveProfile(profile);

      // Also persist locally so the dashboard loads even when Firestore rules
      // have not yet been deployed (offline-persistence rolls back writes and
      // the Firestore stream emits null until rules are live).
      await LocalProfileCache.save(profile);

      // Profile is now persisted; later screens read it from Firestore / local
      // cache, so the in-memory draft and prior assessment answers can be cleared.
      ref.read(onboardingControllerProvider.notifier).reset();
      ref.read(assessmentControllerProvider.notifier).reset();
      if (!mounted) return;
      context.go(Routes.assessmentIntro);
    } on ProfileException catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } catch (_) {
      if (mounted) {
        showAppSnack(context, 'Could not save your profile. Try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Profile Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Review your profile information.',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 35,
                      spreadRadius: 2,
                    ),
                  ],
                  image: draft.photo != null
                      ? DecorationImage(
                          image: FileImage(draft.photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: draft.photo == null
                    ? const Icon(Icons.person, size: 80, color: Colors.white54)
                    : null,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    _row(Icons.person_outline, 'Full Name', draft.name),
                    _divider(),
                    _row(Icons.email_outlined, 'Email', draft.email),
                    _divider(),
                    _row(Icons.phone_outlined, 'Phone', draft.phone),
                    _divider(),
                    _row(Icons.cake_outlined, 'Date of Birth', draft.dob),
                    _divider(),
                    _row(Icons.wc_outlined, 'Gender', draft.gender ?? ''),
                    _divider(),
                    _row(Icons.location_on_outlined, 'State / UT',
                        draft.state ?? ''),
                    _divider(),
                    _row(Icons.school_outlined, 'Education Level',
                        draft.educationLevel ?? ''),
                    _divider(),
                    _row(Icons.school, 'School / College',
                        draft.schoolOrCollege),
                    _divider(),
                    _row(Icons.menu_book, 'Class / Year',
                        draft.classOrYear ?? ''),
                    _divider(),
                    _row(Icons.account_tree_outlined, 'Stream / Branch',
                        draft.branch),
                    _divider(),
                    _row(Icons.flag_outlined, 'Career Goal',
                        draft.careerGoal ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TextButton.icon(
                onPressed: _saving ? null : () => context.pop(),
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.accent),
                label: const Text(
                  'Edit Details',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Finish Setup',
                loading: _saving,
                onPressed: _finishSetup,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    final display = value.trim().isEmpty ? 'Not provided' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(color: Colors.white.withValues(alpha: 0.08), height: 1);
}
