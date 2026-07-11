import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/education/education_stage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../profile/providers/profile_providers.dart';
import 'class_8_10_dashboard.dart';
import 'class_11_dashboard.dart';
import 'class_12_dashboard.dart';

/// Entry point at `/dashboard`. Resolves the signed-in profile, classifies the
/// education stage, and renders the matching school dashboard.
class DashboardDispatcher extends ConsumerWidget {
  const DashboardDispatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => const _Loading(),
      error: (_, __) => const _Loading(),
      data: (profile) {
        if (profile == null || !profile.isComplete) {
          return const Class8to10Dashboard();
        }
        final stage = EducationClassifier.classify(
          classOrYear: profile.classOrYear,
          educationLevel: profile.educationLevel,
        );
        switch (stage) {
          case EducationStage.class8to10:
            return const Class8to10Dashboard();
          case EducationStage.class11:
            return const Class11Dashboard();
          case EducationStage.class12:
            return const Class12Dashboard();
        }
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
