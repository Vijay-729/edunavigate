import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header_row.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/counselling_model.dart';
import '../providers/counselling_providers.dart';
import '../widgets/counselling_card.dart';
import 'counselling_detail_screen.dart';
import 'counselling_list_screen.dart';
import 'saved_counselling_screen.dart';

/// Counselling Guide home dashboard (spec §Feature 1) — search, upcoming /
/// recent / saved rails, category grid, and an AI recommendations CTA.
class CounsellingHomeScreen extends ConsumerWidget {
  const CounsellingHomeScreen({super.key});

  /// Best-effort category recommendation from the student's free-text
  /// profile branch — mirrors the stream-gating heuristic used elsewhere in
  /// the app without coupling this module to the colleges feature.
  static List<CounsellingCategory> _recommendedCategories(String branch) {
    final b = branch.trim().toLowerCase();
    if (b.contains('pcb') || b.contains('bio') || b.contains('medical')) {
      return [
        CounsellingCategory.medical,
        CounsellingCategory.biotechnology,
        CounsellingCategory.agriculture
      ];
    }
    if (b.contains('pcm') || (b.contains('physics') && b.contains('math'))) {
      return [
        CounsellingCategory.engineering,
        CounsellingCategory.architecture,
        CounsellingCategory.cuet
      ];
    }
    if (b.contains('commerce')) {
      return [CounsellingCategory.management, CounsellingCategory.cuet];
    }
    if (b.contains('humanities') || b.contains('arts')) {
      return [
        CounsellingCategory.law,
        CounsellingCategory.cuet,
        CounsellingCategory.design
      ];
    }
    return [
      CounsellingCategory.engineering,
      CounsellingCategory.medical,
      CounsellingCategory.cuet
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingCounsellingProvider);
    final recent = ref.watch(recentCounsellingProvider);
    final saved = ref.watch(savedCounsellingProvider);
    final matchScores =
        ref.watch(counsellingBookmarkIdsProvider).asData?.value ?? const {};
    final profile = ref.watch(currentProfileProvider).asData?.value;
    final recommendedCats = _recommendedCategories(profile?.branch ?? '');
    final all = ref.watch(allCounsellingProgramsProvider);
    final recommended =
        all.where((p) => recommendedCats.contains(p.category)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counselling Guide'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Saved counselling',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const SavedCounsellingScreen()),
            ),
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
                            builder: (_) => const CounsellingListScreen()),
                      ),
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
                          Text('Search JoSAA, NEET, CUET, CLAT…',
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
                            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('AI Counselling Assistant',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(
                                    'Ask "What should I do after AIR 23,000?" or "Freeze or Float?"',
                                    style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white),
                            onPressed: () {
                              if (profile != null) {
                                showAiMentorSheet(context, profile,
                                    contextHint:
                                        'admission counselling strategy (freeze/float, choice filling, CSAB)');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Counselling Categories',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _CategoryGrid(
                      onTap: (cat) => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) =>
                                CounsellingListScreen(initialCategory: cat)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (recommended.isNotEmpty)
              _rail(context, 'Recommended For You', 'Matched to your stream',
                  recommended, matchScores),
            if (upcoming.isNotEmpty)
              _rail(context, 'Upcoming Counselling', 'Next 30 days', upcoming,
                  matchScores),
            if (recent.isNotEmpty)
              _rail(context, 'Recent Counselling', 'Currently active', recent,
                  matchScores),
            if (saved.isNotEmpty)
              _rail(context, 'Saved Counselling', null, saved, matchScores),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _rail(BuildContext context, String title, String? subtitle,
      List<CounsellingProgram> items, Set<String> savedIds) {
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
                      builder: (_) => const CounsellingListScreen()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final program = items[i];
                  return SizedBox(
                    width: 290,
                    child: Consumer(builder: (context, ref, _) {
                      final saved = ref
                              .watch(counsellingBookmarkIdsProvider)
                              .asData
                              ?.value ??
                          const {};
                      return CounsellingCard(
                        program: program,
                        isSaved: saved.contains(program.id),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => CounsellingDetailScreen(
                                  programId: program.id)),
                        ),
                        onSave: () => ref
                            .read(counsellingBookmarkRepositoryProvider)
                            .toggle(program.id, saved.contains(program.id)),
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

  final ValueChanged<CounsellingCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CounsellingCategory.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final cat = CounsellingCategory.values[i];
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
                Icon(cat.icon, color: AppColors.accent, size: 22),
                const SizedBox(height: 6),
                Text(cat.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}
