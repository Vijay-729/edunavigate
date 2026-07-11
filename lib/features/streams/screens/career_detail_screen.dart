import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/stream_exams_data.dart';
import '../models/stream_career.dart';
import '../models/stream_exam.dart';
import '../widgets/sample_data_notice.dart';
import '../widgets/stream_ui_kit.dart';
import 'exam_detail_screen.dart';

class CareerDetailScreen extends ConsumerWidget {
  const CareerDetailScreen(
      {super.key, required this.career, required this.accent});

  final StreamCareer career;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final resolvedExams = career.entranceExamIds
        .map(StreamExamsData.byId)
        .whereType<StreamExam>()
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          career.name,
          style: const TextStyle(fontWeight: FontWeight.w800),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(career.icon, color: accent, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(career.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800)),
                      if (career.isEmerging) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF43F5E).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('🔥 Emerging Career',
                              style: TextStyle(
                                  color: Color(0xFFF43F5E),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(career.overview,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.6)),
            const SizedBox(height: 24),
            const StreamSectionHeader(
                title: 'Eligibility', icon: Icons.checklist_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(career.eligibility,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Required Skills', icon: Icons.psychology_outlined),
            const SizedBox(height: 10),
            StreamChipList(items: career.requiredSkills, color: accent),
            if (resolvedExams.isNotEmpty) ...[
              const SizedBox(height: 20),
              const StreamSectionHeader(
                  title: 'Entrance Exams', icon: Icons.edit_document),
              const SizedBox(height: 10),
              ...resolvedExams.map((e) => ExamLinkTile(
                    exam: e,
                    accent: accent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ExamDetailScreen(exam: e, accent: accent),
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Best Colleges', icon: Icons.apartment_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBulletList(
                      items: career.bestColleges,
                      color: accent,
                      icon: Icons.school_rounded),
                  const SizedBox(height: 4),
                  const Text(
                    'A curated starting list — see the Best Colleges section for detailed rankings and fees.',
                    style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Course & Fees', icon: Icons.school_outlined),
            const SizedBox(height: 10),
            StreamInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamKeyValueRow(
                      icon: Icons.schedule_rounded,
                      label: 'Course Duration',
                      value: career.courseDuration),
                  StreamKeyValueRow(
                      icon: Icons.currency_rupee_rounded,
                      label: 'Expected Fees',
                      value: career.expectedFees),
                  StreamKeyValueRow(
                      icon: Icons.workspace_premium_outlined,
                      label: 'Scholarships',
                      value: career.scholarships),
                  const SampleDataNotice(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Salary Outlook', icon: Icons.payments_outlined),
            const SizedBox(height: 10),
            StreamInfoCard(
              accent: const Color(0xFF22C55E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamKeyValueRow(
                      icon: Icons.trending_flat_rounded,
                      label: 'Average Salary',
                      value: career.averageSalary,
                      iconColor: const Color(0xFF22C55E)),
                  StreamKeyValueRow(
                      icon: Icons.trending_up_rounded,
                      label: 'Highest Salary',
                      value: career.highestSalary,
                      iconColor: const Color(0xFF22C55E)),
                  const SampleDataNotice(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Future Scope', icon: Icons.rocket_launch_outlined),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(career.futureScope,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Top Recruiters', icon: Icons.business_center_outlined),
            const SizedBox(height: 10),
            StreamChipList(items: career.topRecruiters, color: Colors.white70),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Work-Life Balance',
                icon: Icons.self_improvement_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(career.workLifeBalance,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Government & Private Opportunities',
                icon: Icons.account_balance_outlined),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(career.govtPrivateOpportunities,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Higher Study Options',
                icon: Icons.auto_stories_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: StreamBulletList(
                    items: career.higherStudyOptions, color: accent)),
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
                          contextHint: 'the ${career.name} career',
                        ),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Ask AI Mentor about this career',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
