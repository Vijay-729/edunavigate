import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../career/screens/career_explorer_screen.dart';
import '../../career_roadmap/screens/career_roadmap_home_screen.dart';
import '../../colleges/screens/college_explorer_home_screen.dart';
import '../../colleges/screens/college_predictor_form_screen.dart';
import '../../counselling/screens/counselling_home_screen.dart';
import '../../education_loan/screens/education_loan_home_screen.dart';
import '../../exams/screens/exam_universe_home_screen.dart';
import '../../marksheet/screens/upload_marksheet_screen.dart';
import '../../profile/models/user_profile.dart';
import '../../explore/screens/nearby_coachings_screen.dart';
import '../../explore/screens/nearby_colleges_screen.dart';
import '../../resources/data/resource_data.dart';
import '../../resources/screens/resource_hub_screen.dart';
import '../../scholarships/screens/scholarships_screen.dart';
import '../../study_planner/screens/study_planner_screen.dart';
import '../../syllabus/models/syllabus_models.dart';
import '../../syllabus/providers/syllabus_providers.dart';
import '../../syllabus/screens/board_selection_screen.dart';
import '../../syllabus/screens/subjects_screen.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/roadmap_card.dart';
import '../widgets/section_title.dart';
import '../widgets/sliver_pad.dart';

class Class12Dashboard extends StatelessWidget {
  const Class12Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      badge: 'Class 12 • College & Career Launchpad',
      slivers: (context, profile) => _slivers(context, profile),
    );
  }

  List<Widget> _slivers(BuildContext context, UserProfile profile) {
    return [
      // ─── Quick actions (all live) ────────────────────────────────────────
      const SliverPad(
        top: 24,
        child: SectionTitle(
          title: 'Your Toolkit',
          subtitle: 'AI-powered tools for Class 12',
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          delegate: SliverChildListDelegate([
            DashboardCard(
              icon: Icons.explore_outlined,
              title: 'Career Explorer',
              subtitle: 'Paths matched\nto your results',
              gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CareerExplorerScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.event_note_outlined,
              title: 'Study Planner',
              subtitle: 'Plan board prep\nsessions daily',
              gradientColors: const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const StudyPlannerScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.document_scanner_outlined,
              title: 'AI Marksheet',
              subtitle: 'Upload & analyse\nyour results',
              gradientColors: const [Color(0xFF22C55E), Color(0xFF4ADE80)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const UploadMarksheetScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.workspace_premium_outlined,
              title: 'Scholarships',
              subtitle: 'Government &\nprivate funding',
              gradientColors: const [Color(0xFFF97316), Color(0xFFFB923C)],
              onTap: () => _openScholarships(context),
            ),
          ]),
        ),
      ),

      // ─── Plan Your Next Step ─────────────────────────────────────────────
      const SliverPad(
        top: 28,
        child: SectionTitle(
          title: 'Plan Your Next Step',
          subtitle: 'Admissions, counselling, and exams',
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          delegate: SliverChildListDelegate([
            DashboardCard(
              icon: Icons.account_balance_outlined,
              title: 'College Explorer',
              subtitle: 'Browse colleges\n& courses',
              gradientColors: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CollegeExplorerHomeScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.insights_outlined,
              title: 'College Predictor',
              subtitle: 'Estimate your\nadmission chances',
              gradientColors: const [Color(0xFFA855F7), Color(0xFFC084FC)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CollegePredictorFormScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.support_agent_outlined,
              title: 'Counselling Guide',
              subtitle: 'Step-by-step\nadmission help',
              gradientColors: const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CounsellingHomeScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.public_outlined,
              title: 'Exam Universe',
              subtitle: 'All entrance exams\nin one place',
              gradientColors: const [Color(0xFFEF4444), Color(0xFFF87171)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const ExamUniverseHomeScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.route_outlined,
              title: 'Career Roadmap',
              subtitle: 'Map your path\nto your goal',
              gradientColors: const [Color(0xFF3B82F6), Color(0xFF818CF8)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CareerRoadmapHomeScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.savings_outlined,
              title: 'Education Loan',
              subtitle: 'Compare student\nloan options',
              gradientColors: const [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const EducationLoanHomeScreen()),
              ),
            ),
          ]),
        ),
      ),

      // ─── Syllabus Progress ───────────────────────────────────────────────
      const SliverPad(top: 28, child: SectionTitle(title: 'Syllabus Progress')),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverToBoxAdapter(
          child: _DashboardSyllabusCard(profile: profile),
        ),
      ),

      // ─── Explore Nearby ──────────────────────────────────────────────────
      const SliverPad(
        top: 28,
        child: SectionTitle(
          title: 'Explore Nearby',
          subtitle: 'Coaching institutes and schools near you',
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            RoadmapCard(
              roadmapTitle: 'Top Coachings Near You',
              completionStatus: 'Explore',
              nextMilestone: 'Find coaching for JEE, NEET, CUET & more',
              icon: Icons.school_outlined,
              accentColor: const Color(0xFF8B5CF6),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NearbyCoachingsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            RoadmapCard(
              roadmapTitle: 'Nearby Colleges',
              completionStatus: 'Explore',
              nextMilestone: 'Shortlist colleges offering your stream',
              icon: Icons.account_balance_outlined,
              accentColor: const Color(0xFF22C55E),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NearbyCollegesScreen(),
                ),
              ),
            ),
          ]),
        ),
      ),

      // ─── Career Readiness ────────────────────────────────────────────────
      const SliverPad(
        top: 28,
        child: SectionTitle(
          title: 'Career Readiness',
          subtitle: 'Start building skills before college begins',
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          delegate: SliverChildListDelegate([
            DashboardCard(
              icon: Icons.school_outlined,
              title: 'Higher Studies',
              subtitle: 'GATE, GRE, MBA & abroad',
              gradientColors: const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              onTap: () => openResourceHub(context, ResourceData.higherStudies),
            ),
            DashboardCard(
              icon: Icons.verified_outlined,
              title: 'Certifications',
              subtitle: 'Industry-recognized credentials',
              gradientColors: const [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
              onTap: () =>
                  openResourceHub(context, ResourceData.certifications),
            ),
            DashboardCard(
              icon: Icons.code,
              title: 'Coding & DSA',
              subtitle: 'Get a head start on tech skills',
              gradientColors: const [Color(0xFFA855F7), Color(0xFFC084FC)],
              onTap: () => openResourceHub(context, ResourceData.codingDsa),
            ),
            DashboardCard(
              icon: Icons.badge_outlined,
              title: 'Internships',
              subtitle: 'Virtual & part-time openings',
              gradientColors: const [Color(0xFF22C55E), Color(0xFF4ADE80)],
              onTap: () => openResourceHub(context, ResourceData.internships),
            ),
          ]),
        ),
      ),

      SliverPad(
        top: 26,
        bottom: 8,
        child: RecommendationCard(
          title: 'Need help choosing a college?',
          description:
              'Ask your AI Mentor about cut-offs, courses, and career fit for '
              'your goal of "${profile.careerGoal}".',
          actionLabel: 'Ask AI Mentor',
          icon: Icons.auto_awesome,
          onActionPressed: () => showAiMentorSheet(context, profile),
        ),
      ),
    ];
  }

  void _openScholarships(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScholarshipsScreen()),
    );
  }
}

// ─── Live syllabus progress card ──────────────────────────────────────────────

class _DashboardSyllabusCard extends ConsumerWidget {
  const _DashboardSyllabusCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classCode = classCodeFromProfile(profile.classOrYear);
    final progressAsync = ref.watch(classSyllabusProgressProvider(classCode));
    final savedBoard = ref.watch(boardPreferenceProvider);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => savedBoard != null
              ? SubjectsScreen(
                  classCode: classCode,
                  className: profile.classOrYear,
                  board: savedBoard,
                )
              : BoardSelectionScreen(
                  classCode: classCode,
                  className: profile.classOrYear,
                ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF102846),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: progressAsync.when(
          loading: () => const _SyllabusCardContent(
              fraction: 0, done: 0, total: 0, isLoading: true),
          error: (_, __) =>
              const _SyllabusCardContent(fraction: 0, done: 0, total: 0),
          data: (prog) => _SyllabusCardContent(
            fraction: prog.fraction,
            done: prog.done,
            total: prog.total,
          ),
        ),
      ),
    );
  }
}

class _SyllabusCardContent extends StatelessWidget {
  const _SyllabusCardContent({
    required this.fraction,
    required this.done,
    required this.total,
    this.isLoading = false,
  });

  final double fraction;
  final int done;
  final int total;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final pct = (fraction * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_outlined,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Syllabus Completion',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary),
              )
            else
              Text('$pct%',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              total == 0 ? 'Tap to start' : '$done of $total topics completed',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 12.5),
            ),
            Row(
              children: [
                Text('Continue',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded,
                    size: 14, color: AppColors.accent),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
