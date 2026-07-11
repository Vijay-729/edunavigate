import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../profile/data/profile_repository.dart';
import '../provider/assessment_controller.dart';
import '../provider/assessment_providers.dart';
import '../service/assessment_scorer.dart';
import '../widgets/score_bar.dart';

class AssessmentResultScreen extends ConsumerStatefulWidget {
  const AssessmentResultScreen({super.key});

  @override
  ConsumerState<AssessmentResultScreen> createState() =>
      _AssessmentResultScreenState();
}

class _AssessmentResultScreenState
    extends ConsumerState<AssessmentResultScreen> {
  @override
  void initState() {
    super.initState();
    // Persist completion flag + strengths (non-blocking).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (uid == null) return;
      final result = ref.read(assessmentResultProvider);
      final topCategories =
          result.ranked.take(5).map((c) => c.category).toList();
      try {
        await ref
            .read(profileRepositoryProvider)
            .saveAssessmentStrengths(uid, topCategories);
      } catch (_) {
        // Non-critical; dashboard still works without the flag.
      }
    });
  }

  void _continue() {
    ref.read(assessmentControllerProvider.notifier).reset();
    context.go(Routes.congratulations);
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(assessmentResultProvider);
    final insight = ref.watch(assessmentAiInsightProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: result.isEmpty
              ? _EmptyState(onContinue: _continue)
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Icon(Icons.emoji_events,
                            size: 90, color: Colors.amber),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          '🎉 Congratulations!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          result.summary,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Your Strength Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...result.ranked.take(5).map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ScoreBar(
                                label: AssessmentScorer.label(c.category),
                                percentage: c.score,
                                color: _accentFor(c.category),
                              ),
                            ),
                          ),
                      const SizedBox(height: 14),
                      _AiInsightCard(insight: insight),
                      const SizedBox(height: 20),
                      const Text(
                        '🚀 Recommended Paths',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final rec in result.recommendations)
                            _RecommendationChip(label: rec),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _continue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Continue To Dashboard 🚀',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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

Color _accentFor(String category) {
  const colors = [
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF97316),
    Color(0xFFA855F7),
    Color(0xFF06B6D4),
  ];
  return colors[category.hashCode.abs() % colors.length];
}

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard({required this.insight});

  final AsyncValue<String?> insight;

  @override
  Widget build(BuildContext context) {
    return insight.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (text) {
        if (text == null || text.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'AI Mentor Insight',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecommendationChip extends StatelessWidget {
  const _RecommendationChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined,
                color: Colors.white70, size: 72),
            const SizedBox(height: 20),
            const Text(
              'No assessment answers yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('Go to Dashboard',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
