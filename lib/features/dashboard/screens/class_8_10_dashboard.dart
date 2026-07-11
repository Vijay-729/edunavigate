import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../career/screens/career_explorer_screen.dart';
import '../../marksheet/screens/upload_marksheet_screen.dart';
import '../../profile/models/user_profile.dart';
import '../../scholarships/screens/scholarships_screen.dart';
import '../../streams/screens/stream_dashboard_screen.dart';
import '../../study_planner/screens/study_planner_screen.dart';
import '../../syllabus/models/syllabus_models.dart';
import '../../syllabus/providers/syllabus_providers.dart';
import '../../syllabus/screens/board_selection_screen.dart';
import '../../syllabus/screens/subjects_screen.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_scaffold.dart';
import '../../explore/screens/nearby_coachings_screen.dart';
import '../../explore/screens/nearby_schools_screen.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/roadmap_card.dart';
import '../widgets/section_title.dart';
import '../widgets/sliver_pad.dart';

class Class8to10Dashboard extends StatelessWidget {
  const Class8to10Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      badge: 'Class 8–10 • Stream Discovery',
      slivers: (context, profile) => _slivers(context, profile),
    );
  }

  List<Widget> _slivers(BuildContext context, UserProfile profile) {
    final isClass10 = profile.classOrYear.contains('10');

    return [
      // ─── Quick actions ───────────────────────────────────────────────────
      SliverPad(
        top: 24,
        child: SectionTitle(
          title: isClass10 ? 'Class 10 • Board Prep' : 'Quick Actions',
          subtitle: isClass10
              ? 'AI tools for your board exams'
              : 'Your personalised toolkit',
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
              subtitle: 'Discover paths\nmatched to you',
              gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CareerExplorerScreen()),
              ),
            ),
            DashboardCard(
              icon: Icons.event_note_outlined,
              title: 'Study Planner',
              subtitle: 'Plan your daily\nsessions',
              gradientColors: const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const StudyPlannerScreen()),
              ),
            ),
            if (isClass10) ...[
              DashboardCard(
                icon: Icons.document_scanner_outlined,
                title: 'AI Marksheet',
                subtitle: 'Upload & analyse\nyour result',
                gradientColors: const [Color(0xFF22C55E), Color(0xFF4ADE80)],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const UploadMarksheetScreen()),
                ),
              ),
              DashboardCard(
                icon: Icons.workspace_premium_outlined,
                title: 'Scholarships',
                subtitle: 'Find awards\nyou qualify for',
                gradientColors: const [Color(0xFFF97316), Color(0xFFFB923C)],
                onTap: () => _openScholarships(context),
              ),
            ] else ...[
              DashboardCard(
                icon: Icons.workspace_premium_outlined,
                title: 'Scholarships',
                subtitle: 'Find awards\nyou qualify for',
                gradientColors: const [Color(0xFFF97316), Color(0xFFFB923C)],
                onTap: () => _openScholarships(context),
              ),
              DashboardCard(
                icon: Icons.auto_awesome_outlined,
                title: 'AI Mentor',
                subtitle: 'Ask anything\nabout streams',
                gradientColors: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                onTap: () => showAiMentorSheet(context, profile),
              ),
            ],
          ]),
        ),
      ),

      // ─── Stream Discovery ────────────────────────────────────────────────
      const SliverPad(
        top: 28,
        child: SectionTitle(
          title: 'Explore Streams',
          subtitle: 'Choose the right path after Class 10',
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
              icon: Icons.functions,
              title: 'PCM',
              subtitle: 'Physics, Chemistry, Maths',
              gradientColors: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) =>
                        const StreamDashboardScreen(streamCode: 'pcm')),
              ),
            ),
            DashboardCard(
              icon: Icons.biotech_outlined,
              title: 'PCB',
              subtitle: 'Physics, Chemistry, Biology',
              gradientColors: const [Color(0xFF22C55E), Color(0xFF4ADE80)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) =>
                        const StreamDashboardScreen(streamCode: 'pcb')),
              ),
            ),
            DashboardCard(
              icon: Icons.show_chart,
              title: 'Commerce',
              subtitle: 'Accounts, Business, Economics',
              gradientColors: const [Color(0xFFF97316), Color(0xFFFB923C)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) =>
                        const StreamDashboardScreen(streamCode: 'commerce')),
              ),
            ),
            DashboardCard(
              icon: Icons.gavel_outlined,
              title: 'Humanities',
              subtitle: 'Psychology, History, Pol. Sci.',
              gradientColors: const [Color(0xFFA855F7), Color(0xFFC084FC)],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) =>
                        const StreamDashboardScreen(streamCode: 'humanities')),
              ),
            ),
          ]),
        ),
      ),

      // ─── Board Preparation ───────────────────────────────────────────────
      const SliverPad(top: 28, child: SectionTitle(title: 'Board Preparation')),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverToBoxAdapter(
          child: _DashboardSyllabusCard(profile: profile),
        ),
      ),

      // ─── Explore section ─────────────────────────────────────────────────
      const SliverPad(top: 28, child: SectionTitle(title: 'More to Explore')),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            RoadmapCard(
              roadmapTitle: 'Top Coachings Near You',
              completionStatus: 'Explore',
              nextMilestone: 'Find coaching for JEE, NEET, Olympiad & more',
              icon: Icons.school_outlined,
              accentColor: const Color(0xFF3B82F6),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NearbyCoachingsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            RoadmapCard(
              roadmapTitle: 'Schools for Class 11',
              completionStatus: 'Explore',
              nextMilestone: 'Shortlist schools for Class 11 admission',
              icon: Icons.apartment_outlined,
              accentColor: const Color(0xFF22C55E),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NearbySchoolsScreen(),
                ),
              ),
            ),
          ]),
        ),
      ),

      SliverPad(
        top: 24,
        bottom: 8,
        child: RecommendationCard(
          title: 'Not sure which stream fits you?',
          description:
              'Chat with your AI Mentor for a personalised recommendation '
              'based on your assessment results.',
          actionLabel: 'Ask AI Mentor',
          icon: Icons.auto_awesome,
          accentColor: const Color(0xFF3B82F6),
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
            fraction: 0,
            done: 0,
            total: 0,
            isLoading: true,
          ),
          error: (_, __) => const _SyllabusCardContent(
            fraction: 0,
            done: 0,
            total: 0,
          ),
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
              child: const Icon(
                Icons.menu_book_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Syllabus Completion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Text(
                '$pct%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12.5,
              ),
            ),
            Row(
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
