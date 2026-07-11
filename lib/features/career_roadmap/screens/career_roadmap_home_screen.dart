import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header_row.dart';
import '../models/career_roadmap_model.dart';
import '../providers/career_roadmap_providers.dart';
import '../widgets/career_card.dart';
import 'career_assessment_screen.dart';
import 'career_compare_screen.dart';
import 'career_detail_screen.dart';
import 'career_list_screen.dart';
import 'saved_careers_screen.dart';

/// Career Roadmap entry point (spec §Feature 3) — assessment CTA, trending
/// careers, browse-all, and saved careers.
class CareerRoadmapHomeScreen extends ConsumerWidget {
  const CareerRoadmapHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allCareersProvider);
    final trending = List<CareerRoadmapModel>.from(all)
      ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    final saved = ref.watch(savedCareersProvider);
    final hasAssessment = ref.watch(careerAssessmentAnswersProvider).isNotEmpty;
    final scores = ref.watch(careerMatchScoresProvider);
    final compareCount = ref.watch(careerCompareListProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Roadmap'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.compare_arrows),
                tooltip: 'Compare careers',
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const CareerCompareScreen())),
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
            tooltip: 'Saved careers',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const SavedCareersScreen())),
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
                              builder: (_) => const CareerListScreen())),
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
                          Text('Search careers, domains, recruiters…',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 14)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    const CareerAssessmentScreen())),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.psychology_alt_outlined,
                                  color: Colors.white, size: 28),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        hasAssessment
                                            ? 'Retake Career Assessment'
                                            : 'Take the Career Assessment',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    const Text(
                                        '8 quick questions → AI-ranked career matches for you',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _rail(context, 'Trending Careers', 'Most explored by students',
                trending, scores),
            if (saved.isNotEmpty)
              _rail(context, 'Saved Careers', null, saved, scores),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _rail(BuildContext context, String title, String? subtitle,
      List<CareerRoadmapModel> items, Map<String, double> scores) {
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
                        builder: (_) => const CareerListScreen())),
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
                  final career = items[i];
                  return SizedBox(
                    width: 290,
                    child: Consumer(builder: (context, ref, _) {
                      final saved =
                          ref.watch(careerBookmarkIdsProvider).asData?.value ??
                              const {};
                      final compareIds = ref.watch(careerCompareListProvider);
                      return CareerCard(
                        career: career,
                        matchPercent: scores[career.id],
                        isSaved: saved.contains(career.id),
                        isComparing: compareIds.contains(career.id),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    CareerDetailScreen(careerId: career.id))),
                        onSave: () => ref
                            .read(careerRoadmapBookmarkRepositoryProvider)
                            .toggle(career.id, saved.contains(career.id)),
                        onCompareToggle: () {
                          final ok = ref
                              .read(careerCompareListProvider.notifier)
                              .toggle(career.id);
                          if (!ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You can compare up to 3 careers.')));
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
