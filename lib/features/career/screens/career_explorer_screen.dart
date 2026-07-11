import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../assessment/provider/assessment_providers.dart';
import '../../assessment/service/assessment_scorer.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/career_data.dart';
import '../models/career_path.dart';

class CareerExplorerScreen extends ConsumerWidget {
  const CareerExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(assessmentResultProvider);

    // Prefer live result; fall back to persisted strengths when controller
    // was disposed (e.g. user navigates here after restarting the session).
    final Set<String> topCategories;
    if (!result.isEmpty) {
      topCategories = result.ranked.take(5).map((c) => c.category).toSet();
    } else {
      final saved = ref
              .watch(currentProfileProvider)
              .asData
              ?.value
              ?.assessmentStrengths ??
          const [];
      topCategories = saved.toSet();
    }

    // Sort careers: matched to assessed strengths come first.
    final sorted = [...CareerData.all]..sort((a, b) {
        final aScore = a.relatedCategories.where(topCategories.contains).length;
        final bScore = b.relatedCategories.where(topCategories.contains).length;
        return bScore.compareTo(aScore);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Explorer'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (topCategories.isNotEmpty) ...[
              _StrengthBanner(
                strengths: result.ranked
                    .take(3)
                    .map((c) => AssessmentScorer.label(c.category))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'Matched Career Paths',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sorted by your assessed strengths',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...sorted.map(
              (career) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CareerCard(
                  career: career,
                  matched: career.relatedCategories.any(topCategories.contains),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrengthBanner extends StatelessWidget {
  const _StrengthBanner({required this.strengths});

  final List<String> strengths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.accent.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 18),
              SizedBox(width: 8),
              Text(
                'Your Top Strengths',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: strengths
                .map(
                  (s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      s,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  const _CareerCard({required this.career, required this.matched});

  final CareerPath career;
  final bool matched;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: matched
                ? career.accent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: matched ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: career.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(career.icon, color: career.accent, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          career.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (matched)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: career.accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Match',
                            style: TextStyle(
                                color: career.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    career.domain,
                    style: TextStyle(
                        color: career.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    career.shortDescription,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee,
                          size: 14, color: Colors.white38),
                      const SizedBox(width: 2),
                      Text(
                        career.salaryRange,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white30, size: 22),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CareerDetailSheet(career: career),
    );
  }
}

class _CareerDetailSheet extends StatelessWidget {
  const _CareerDetailSheet({required this.career});

  final CareerPath career;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.bgGradient,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: career.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(career.icon, color: career.accent, size: 34),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          career.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          career.domain,
                          style: TextStyle(
                              color: career.accent,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                career.fullDescription,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 20),
              _DetailSection(
                title: 'Key Skills',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: career.keySkills
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: career.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: career.accent.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                                color: career.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              _DetailRow(
                  icon: Icons.school_outlined,
                  label: 'Minimum Qualification',
                  value: career.minimumQualification),
              _DetailRow(
                  icon: Icons.route_outlined,
                  label: 'Path / Exams',
                  value: career.topExamsOrPaths),
              _DetailRow(
                  icon: Icons.currency_rupee,
                  label: 'Salary Range',
                  value: career.salaryRange),
              const SizedBox(height: 16),
              _DetailSection(
                title: 'Top Recruiters',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: career.topRecruiters
                      .map(
                        (r) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            r,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 4),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
