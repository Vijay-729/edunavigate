import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/stream_careers_data.dart';
import '../data/stream_exams_data.dart';
import '../data/streams_data.dart';
import '../models/roadmap_step.dart';
import '../models/stream_career.dart';
import '../models/stream_exam.dart';
import '../models/stream_info.dart';
import '../widgets/roadmap_timeline.dart';
import '../widgets/sample_data_notice.dart';
import '../widgets/stream_ui_kit.dart';
import 'career_detail_screen.dart';
import 'exam_detail_screen.dart';

class StreamDashboardScreen extends StatelessWidget {
  const StreamDashboardScreen({super.key, required this.streamCode});

  final String streamCode;

  @override
  Widget build(BuildContext context) {
    final stream = StreamsData.byCode(streamCode);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stream.name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800)),
              Text(stream.tagline,
                  style: TextStyle(
                      color: stream.accent,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          bottom: TabBar(
            indicatorColor: stream.accent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Careers'),
              Tab(text: 'Exams'),
              Tab(text: 'Roadmap'),
            ],
          ),
        ),
        body: GradientBackground(
          extendBehindAppBar: true,
          child: TabBarView(
            children: [
              _OverviewTab(stream: stream),
              _CareersTab(stream: stream),
              _ExamsTab(stream: stream),
              _RoadmapTab(stream: stream),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Overview Tab ───────────────────────────────────────────────────────────

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.stream});
  final StreamInfo stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final accent = stream.accent;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 110, 20, 32),
      children: [
        Text(stream.overview,
            style: const TextStyle(
                color: Colors.white70, fontSize: 14, height: 1.6)),
        const SizedBox(height: 22),
        const StreamSectionHeader(
            title: 'Subjects Taught', icon: Icons.menu_book_rounded),
        const SizedBox(height: 10),
        StreamChipList(items: stream.subjects, color: accent),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Skills Required', icon: Icons.psychology_outlined),
        const SizedBox(height: 10),
        StreamChipList(items: stream.skillsRequired, color: accent),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Who Should Choose This Stream?',
            icon: Icons.person_search_rounded),
        const SizedBox(height: 10),
        StreamInfoCard(
            child:
                StreamBulletList(items: stream.whoShouldChoose, color: accent)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: StreamInfoCard(
                accent: const Color(0xFF22C55E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pros',
                        style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    StreamBulletList(
                        items: stream.pros,
                        color: const Color(0xFF22C55E),
                        icon: Icons.add_circle_outline_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StreamInfoCard(
                accent: Colors.redAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cons',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    StreamBulletList(
                        items: stream.cons,
                        color: Colors.redAccent,
                        icon: Icons.remove_circle_outline_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Future Opportunities', icon: Icons.rocket_launch_outlined),
        const SizedBox(height: 10),
        StreamInfoCard(
            child: Text(stream.futureOpportunities,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13.5, height: 1.6))),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Salary Expectation', icon: Icons.payments_outlined),
        const SizedBox(height: 10),
        StreamInfoCard(
          accent: const Color(0xFF22C55E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stream.salaryExpectation,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13.5, height: 1.6)),
              const SizedBox(height: 10),
              const SampleDataNotice(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Growth Opportunities', icon: Icons.trending_up_rounded),
        const SizedBox(height: 10),
        StreamInfoCard(
            child: Text(stream.growthOpportunities,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13.5, height: 1.6))),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Recommended Personality Traits',
            icon: Icons.face_retouching_natural_rounded),
        const SizedBox(height: 10),
        StreamChipList(items: stream.personalityTraits, color: accent),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Industries Hiring', icon: Icons.business_center_outlined),
        const SizedBox(height: 10),
        StreamChipList(items: stream.industriesHiring, color: Colors.white70),
        const SizedBox(height: 20),
        const StreamSectionHeader(
            title: 'Skills to Build Now', icon: Icons.fitness_center_rounded),
        const SizedBox(height: 10),
        StreamChipList(items: stream.skillsToBuild, color: accent),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: accent.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: accent,
            ),
            onPressed: profileAsync.asData?.value == null
                ? null
                : () => showAiMentorSheet(
                      context,
                      profileAsync.asData!.value!,
                      contextHint: 'the ${stream.name} stream',
                    ),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text('Ask AI Mentor: Is ${stream.name} right for me?',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

// ─── Careers Tab ────────────────────────────────────────────────────────────

class _CareersTab extends StatelessWidget {
  const _CareersTab({required this.stream});
  final StreamInfo stream;

  @override
  Widget build(BuildContext context) {
    final careers = StreamCareersData.forStream(stream.code);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 110, 20, 32),
      itemCount: careers.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              '${careers.length} career paths to explore in ${stream.name}',
              style: const TextStyle(color: Colors.white54, fontSize: 12.5),
            ),
          );
        }
        final career = careers[i - 1];
        return _CareerCard(career: career, accent: stream.accent);
      },
    );
  }
}

class _CareerCard extends StatelessWidget {
  const _CareerCard({required this.career, required this.accent});
  final StreamCareer career;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => CareerDetailScreen(career: career, accent: accent),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(career.icon, color: accent, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(career.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700)),
                      ),
                      if (career.isEmerging)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text('🔥', style: TextStyle(fontSize: 13)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee_rounded,
                          size: 13, color: Colors.white38),
                      Expanded(
                        child: Text(career.averageSalary,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

// ─── Exams Tab ───────────────────────────────────────────────────────────────

class _ExamsTab extends StatelessWidget {
  const _ExamsTab({required this.stream});
  final StreamInfo stream;

  @override
  Widget build(BuildContext context) {
    final exams = stream.examIds
        .map(StreamExamsData.byId)
        .whereType<StreamExam>()
        .toList();
    if (exams.isEmpty) {
      return const Center(
        child: Text('No exams listed for this stream yet.',
            style: TextStyle(color: Colors.white38)),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 110, 20, 32),
      itemCount: exams.length,
      itemBuilder: (context, i) => ExamLinkTile(
        exam: exams[i],
        accent: stream.accent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) =>
                ExamDetailScreen(exam: exams[i], accent: stream.accent),
          ),
        ),
      ),
    );
  }
}

// ─── Roadmap Tab ─────────────────────────────────────────────────────────────

class _RoadmapTab extends StatelessWidget {
  const _RoadmapTab({required this.stream});
  final StreamInfo stream;

  List<RoadmapStep> _steps() {
    final examNames = stream.examIds
        .map(StreamExamsData.byId)
        .whereType<StreamExam>()
        .take(3)
        .map((e) => e.name)
        .join(', ');
    return [
      const RoadmapStep(
        title: 'Class 10',
        subtitle:
            'Complete your board exams and start exploring your interests.',
        icon: Icons.looks_one_rounded,
      ),
      RoadmapStep(
        title: 'Choose Stream',
        subtitle:
            'Pick ${stream.name} based on your strengths, interests, and goals.',
        icon: Icons.alt_route_rounded,
      ),
      RoadmapStep(
        title: 'Class 11–12',
        subtitle:
            'Build a strong foundation in ${stream.subjects.take(3).join(', ')}.',
        icon: Icons.menu_book_rounded,
      ),
      RoadmapStep(
        title: 'Entrance Exams',
        subtitle: examNames.isEmpty
            ? 'Prepare for exams relevant to your target career.'
            : 'Prepare for exams like $examNames.',
        icon: Icons.edit_document,
      ),
      const RoadmapStep(
        title: 'Best Colleges',
        subtitle: 'Aim for top institutes through counselling and admissions.',
        icon: Icons.apartment_rounded,
      ),
      const RoadmapStep(
        title: 'Graduation',
        subtitle:
            'Complete your degree with strong academics, projects, and skills.',
        icon: Icons.workspace_premium_rounded,
      ),
      const RoadmapStep(
        title: 'Internships',
        subtitle: 'Gain real-world experience while still studying.',
        icon: Icons.work_history_rounded,
      ),
      const RoadmapStep(
        title: 'Placements',
        subtitle: 'Land your first job through campus or off-campus hiring.',
        icon: Icons.business_center_rounded,
      ),
      const RoadmapStep(
        title: 'Higher Studies',
        subtitle:
            'Consider a Master\'s, MBA, or specialization if it fits your goals.',
        icon: Icons.auto_stories_rounded,
      ),
      const RoadmapStep(
        title: 'Career',
        subtitle:
            'Grow steadily through experience, skills, and continuous learning.',
        icon: Icons.trending_up_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 110, 20, 32),
      children: [
        RoadmapTimeline(steps: _steps(), accentColor: stream.accent),
      ],
    );
  }
}
