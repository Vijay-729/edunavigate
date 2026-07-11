import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/career_roadmap_providers.dart';
import '../widgets/career_card.dart';
import 'career_assessment_screen.dart';
import 'career_detail_screen.dart';

/// Shows careers ranked by overlap with the student's assessment answers.
class CareerRecommendationResultScreen extends ConsumerWidget {
  const CareerRecommendationResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommended = ref.watch(recommendedCareersProvider);
    final scores = ref.watch(careerMatchScoresProvider);
    final savedIds =
        ref.watch(careerBookmarkIdsProvider).asData?.value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Career Matches'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Retake assessment',
            onPressed: () {
              ref.read(careerAssessmentAnswersProvider.notifier).reset();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                    builder: (_) => const CareerAssessmentScreen()),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: recommended.isEmpty
            ? const EmptyStateView(
                title: 'No matches yet',
                message: 'Complete the assessment to see recommendations.')
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: recommended.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Based on your answers, here are the careers that fit you best:',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13.5, height: 1.4),
                      ),
                    );
                  }
                  final career = recommended[index - 1];
                  return CareerCard(
                    career: career,
                    matchPercent: scores[career.id],
                    isSaved: savedIds.contains(career.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              CareerDetailScreen(careerId: career.id)),
                    ),
                    onSave: () => ref
                        .read(careerRoadmapBookmarkRepositoryProvider)
                        .toggle(career.id, savedIds.contains(career.id)),
                  );
                },
              ),
      ),
    );
  }
}
