import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header_row.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';
import '../providers/exam_providers.dart';
import '../widgets/exam_card.dart';
import 'ai_exam_finder_screen.dart';
import 'exam_calendar_screen.dart';
import 'exam_compare_screen.dart';
import 'exam_detail_screen.dart';
import 'exam_list_screen.dart';
import 'saved_exams_screen.dart';

const _aiFinderPrompts = [
  'I am a PCB student. Which exams can I give except NEET?',
  'I have 82% in Commerce. What exams suit me?',
  'Best entrance exams for Biotechnology.',
];

/// Exam Universe entry point (spec §Feature 2) — global search, categories,
/// upcoming exams, AI Exam Finder, calendar, and compare.
class ExamUniverseHomeScreen extends ConsumerWidget {
  const ExamUniverseHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingExamsProvider);
    final trending = ref.watch(trendingExamsProvider);
    final saved = ref.watch(savedExamsProvider);
    final profile = ref.watch(currentProfileProvider).asData?.value;
    final compareCount = ref.watch(examCompareListProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Universe'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Exam calendar',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const ExamCalendarScreen())),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.compare_arrows),
                tooltip: 'Compare exams',
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const ExamCompareScreen())),
              ),
              if (compareCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('$compareCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Saved exams',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const SavedExamsScreen())),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const ExamListScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.search, color: Colors.white54),
                          const SizedBox(width: 10),
                          Text('Search exam, course, career, college, state…',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 14)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: Colors.white, size: 26),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text('AI Exam Finder',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _aiFinderPrompts
                                .map((p) => GestureDetector(
                                      onTap: () {
                                        if (profile != null) {
                                          showAiMentorSheet(context, profile,
                                              contextHint:
                                                  'finding the right entrance exams',
                                              initialQuestion: p);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.18),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Text(p,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.5)),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Categories',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _CategoryGrid(
                      onTap: (cat) => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) =>
                                  ExamListScreen(initialCategory: cat))),
                    ),
                  ],
                ),
              ),
            ),
            if (upcoming.isNotEmpty)
              _rail(context, 'Upcoming Exams', 'Next 45 days', upcoming),
            _rail(context, 'Trending Exams', 'Most searched', trending),
            if (saved.isNotEmpty) _rail(context, 'Saved Exams', null, saved),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _rail(BuildContext context, String title, String? subtitle,
      List<ExamProfileModel> items) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeaderRow(
                title: title,
                subtitle: subtitle,
                onSeeAll: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const ExamListScreen())),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final exam = items[i];
                  return SizedBox(
                    width: 290,
                    child: Consumer(builder: (context, ref, _) {
                      final saved =
                          ref.watch(examBookmarkIdsProvider).asData?.value ??
                              const {};
                      final compareIds = ref.watch(examCompareListProvider);
                      return ExamCard(
                        exam: exam,
                        isSaved: saved.contains(exam.id),
                        isComparing: compareIds.contains(exam.id),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    ExamDetailScreen(examId: exam.id))),
                        onSave: () => ref
                            .read(examBookmarkRepositoryProvider)
                            .toggle(exam.id, saved.contains(exam.id)),
                        onCompareToggle: () {
                          final ok = ref
                              .read(examCompareListProvider.notifier)
                              .toggle(exam.id);
                          if (!ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You can compare up to 3 exams.')));
                          }
                        },
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.onTap});

  final ValueChanged<ExamCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ExamCategory.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final cat = ExamCategory.values[i];
        return GestureDetector(
          onTap: () => onTap(cat),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat.icon, color: AppColors.accent, size: 20),
                const SizedBox(height: 6),
                Text(cat.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}
