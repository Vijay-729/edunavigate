import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/stream_exam.dart';
import '../widgets/sample_data_notice.dart';
import '../widgets/stream_ui_kit.dart';

class ExamDetailScreen extends ConsumerWidget {
  const ExamDetailScreen({super.key, required this.exam, required this.accent});

  final StreamExam exam;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(exam.name,
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
          children: [
            Text(
              exam.fullName,
              style: TextStyle(
                  color: accent, fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed_rounded,
                      size: 14, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text('Difficulty: ${exam.difficulty}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(exam.description,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.6)),
            if (exam.officialNote != null) ...[
              const SizedBox(height: 16),
              StreamInfoCard(
                accent: Colors.redAccent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        exam.officialNote!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const StreamSectionHeader(
                title: 'Eligibility', icon: Icons.checklist_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(exam.eligibility,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Syllabus Highlights', icon: Icons.menu_book_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: StreamBulletList(
                    items: exam.syllabusHighlights, color: accent)),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Registration', icon: Icons.how_to_reg_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(exam.registration,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Timeline', icon: Icons.schedule_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: Text(exam.timeline,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.6))),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Previous Year Cutoffs', icon: Icons.bar_chart_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
              accent: const Color(0xFFF97316),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exam.previousYearCutoffs,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13.5, height: 1.6)),
                  const SizedBox(height: 10),
                  const SampleDataNotice(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Preparation Tips',
                icon: Icons.tips_and_updates_rounded),
            const SizedBox(height: 10),
            StreamInfoCard(
                child: StreamBulletList(
                    items: exam.preparationTips,
                    color: accent,
                    icon: Icons.arrow_right_rounded)),
            const SizedBox(height: 20),
            const StreamSectionHeader(
                title: 'Best Books', icon: Icons.library_books_rounded),
            const SizedBox(height: 10),
            StreamChipList(items: exam.bestBooks, color: accent),
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
                          contextHint: 'the ${exam.name} entrance exam',
                        ),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Ask AI Mentor about this exam',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
