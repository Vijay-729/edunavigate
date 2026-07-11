import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/saved_college_repository.dart';
import '../models/college_model.dart';
import '../models/course_model.dart';
import '../models/student_stream.dart';
import '../providers/college_providers.dart';
import '../services/college_query_service.dart';
import '../widgets/college_card.dart';
import '../widgets/college_card_skeleton.dart';
import '../widgets/quick_filter_chip.dart';
import '../widgets/section_header_row.dart';
import '../widgets/stream_picker_view.dart';
import 'college_compare_screen.dart';
import 'college_details_screen.dart';
import 'college_search_results_screen.dart';
import 'saved_colleges_screen.dart';

/// One entry per "Popular Searches" chip — maps a human-readable label onto
/// the real [CollegeFilter]/[CollegeSortOrder] that answers it, plus the
/// stream that must be active for the matching colleges to be visible at all
/// (courses are gated by [StudentStreamX.eligibleCategories]).
class _PopularSearch {
  const _PopularSearch({
    required this.label,
    this.requiredStream,
    required this.applyFilter,
    this.sortOrder,
  });

  final String label;
  final StudentStream? requiredStream;
  final CollegeFilter Function(CollegeFilter) applyFilter;
  final CollegeSortOrder? sortOrder;
}

final _popularSearches = <_PopularSearch>[
  _PopularSearch(
    label: 'JEE Colleges',
    requiredStream: StudentStream.pcm,
    applyFilter: (f) => f.copyWith(examIds: const ['jee_main', 'jee_advanced']),
  ),
  _PopularSearch(
    label: 'NEET Colleges',
    requiredStream: StudentStream.pcb,
    applyFilter: (f) => f.copyWith(examIds: const ['neet']),
  ),
  _PopularSearch(
    label: 'Top MBA Colleges',
    requiredStream: StudentStream.commerce,
    applyFilter: (f) => f.copyWith(courseCategory: CourseCategory.management),
    sortOrder: CollegeSortOrder.topRanked,
  ),
  _PopularSearch(
    label: 'Low Fee Colleges',
    applyFilter: (f) => f,
    sortOrder: CollegeSortOrder.lowestFees,
  ),
  _PopularSearch(
    label: 'Government Colleges',
    applyFilter: (f) => f.copyWith(governmentOnly: true),
  ),
  _PopularSearch(
    label: 'CUET Colleges',
    applyFilter: (f) => f.copyWith(examIds: const ['cuet']),
  ),
];

/// College Explorer entry point (spec §Feature 1). Everything below the
/// stream gate is scoped to [activeStreamProvider] so the student only ever
/// sees colleges relevant to their stream and admission route.
class CollegeExplorerHomeScreen extends ConsumerWidget {
  const CollegeExplorerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(activeStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('College Explorer'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Saved colleges',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const SavedCollegesScreen()),
            ),
          ),
          Consumer(builder: (context, ref, _) {
            final compareCount = ref.watch(compareListProvider).length;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.compare_arrows),
                  tooltip: 'Compare colleges',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const CollegeCompareScreen()),
                  ),
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
            );
          }),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: stream == null
            ? SingleChildScrollView(
                child: StreamPickerView(
                  onPicked: (s) =>
                      ref.read(streamOverrideProvider.notifier).state = s,
                ),
              )
            : _ExplorerContent(stream: stream),
      ),
    );
  }
}

class _ExplorerContent extends ConsumerWidget {
  const _ExplorerContent({required this.stream});

  final StudentStream stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colleges = ref.watch(streamCollegesProvider);
    final trending = ref.watch(trendingCollegesProvider);
    final topGovt = ref.watch(topGovernmentCollegesProvider);
    final topPrivate = ref.watch(topPrivateCollegesProvider);
    final topRanked = ref.watch(topRankedCollegesProvider);
    final recommended = ref.watch(recommendedForYouProvider);
    final matchScores = ref.watch(collegeMatchScoresProvider);
    final savedIds =
        ref.watch(savedCollegeIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(compareListProvider);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StreamBadge(stream: stream),
                const SizedBox(height: 14),
                _SearchBar(onTap: () => _openResults(context)),
                const SizedBox(height: 16),
                Text('Popular Searches',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _popularSearches
                      .map((s) => QuickFilterChip(
                            label: s.label,
                            selected: false,
                            onTap: () => _runPopularSearch(context, ref, s),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text('Quick Filters',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _quickFilter(context, ref, 'Government',
                        (f) => f.copyWith(governmentOnly: true)),
                    _quickFilter(context, ref, 'Private',
                        (f) => f.copyWith(privateOnly: true)),
                    _quickFilter(context, ref, 'Autonomous',
                        (f) => f.copyWith(autonomousOnly: true)),
                    _quickFilter(context, ref, 'NAAC A++',
                        (f) => f.copyWith(naacAPlusPlusOnly: true)),
                    _quickFilter(
                        context, ref, 'NBA', (f) => f.copyWith(nbaOnly: true)),
                    _quickFilter(context, ref, 'Hostel',
                        (f) => f.copyWith(hostelOnly: true)),
                    _quickFilter(context, ref, 'Scholarship',
                        (f) => f.copyWith(scholarshipOnly: true)),
                    _quickFilter(context, ref, 'Low Fees',
                        (f) => f.copyWith(lowFeesOnly: true)),
                    _quickFilter(context, ref, 'High Placement',
                        (f) => f.copyWith(highPlacementOnly: true)),
                    _quickFilter(context, ref, 'AI Recommended',
                        (f) => f.copyWith(aiRecommendedOnly: true)),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Browse by Course',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _CourseGrid(
                  categories: stream.eligibleCategories,
                  onTap: (cat) {
                    ref.read(collegeFilterProvider.notifier).state = ref
                        .read(collegeFilterProvider)
                        .copyWith(courseCategory: cat);
                    _openResults(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (colleges.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CollegeListSkeleton(count: 2),
            ),
          )
        else ...[
          _railSliver(
              context,
              ref,
              'Trending Colleges',
              'Popular with students like you',
              trending,
              matchScores,
              savedIds,
              compareIds),
          _railSliver(context, ref, 'Top Government Colleges', null, topGovt,
              matchScores, savedIds, compareIds),
          _railSliver(context, ref, 'Top Private Colleges', null, topPrivate,
              matchScores, savedIds, compareIds),
          _railSliver(context, ref, 'Top Ranked Colleges', 'By NIRF ranking',
              topRanked, matchScores, savedIds, compareIds),
          _railSliver(
              context,
              ref,
              'Recommended For You',
              'Matched to your profile & preferences',
              recommended,
              matchScores,
              savedIds,
              compareIds),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _quickFilter(
    BuildContext context,
    WidgetRef ref,
    String label,
    CollegeFilter Function(CollegeFilter) apply,
  ) {
    return QuickFilterChip(
      label: label,
      selected: false,
      onTap: () {
        ref.read(collegeFilterProvider.notifier).state =
            apply(const CollegeFilter());
        _openResults(context);
      },
    );
  }

  Future<void> _runPopularSearch(
      BuildContext context, WidgetRef ref, _PopularSearch search) async {
    final requiredStream = search.requiredStream;
    if (requiredStream != null &&
        ref.read(activeStreamProvider) != requiredStream) {
      final confirmed = await _confirmStreamSwitch(context, requiredStream);
      if (!confirmed) return;
      ref.read(streamOverrideProvider.notifier).state = requiredStream;
    }
    if (!context.mounted) return;

    ref.read(collegeFilterProvider.notifier).state =
        search.applyFilter(const CollegeFilter());
    ref.read(collegeSortOrderProvider.notifier).state =
        search.sortOrder ?? CollegeSortOrder.relevance;
    ref.read(collegeSearchQueryProvider.notifier).state = '';

    _openResults(context, displayText: search.label, autofocusSearch: false);
  }

  Future<bool> _confirmStreamSwitch(
      BuildContext context, StudentStream target) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D2040),
        title:
            const Text('Switch stream?', style: TextStyle(color: Colors.white)),
        content: Text(
          'These colleges are shown under the ${target.label} stream. Switch to it now?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Switch to ${target.label}'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Widget _railSliver(
    BuildContext context,
    WidgetRef ref,
    String title,
    String? subtitle,
    List<CollegeModel> items,
    Map<String, double> matchScores,
    Set<String> savedIds,
    List<String> compareIds,
  ) {
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
                onSeeAll: () => _openResults(context),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 268,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final college = items[i];
                  return SizedBox(
                    width: 290,
                    child: CollegeCard(
                      college: college,
                      matchPercent: matchScores[college.id],
                      isSaved: savedIds.contains(college.id),
                      isComparing: compareIds.contains(college.id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) =>
                                CollegeDetailsScreen(collegeId: college.id)),
                      ),
                      onSave: () => ref
                          .read(savedCollegeRepositoryProvider)
                          .toggleSaved(
                              college.id, savedIds.contains(college.id)),
                      onCompareToggle: () {
                        final ok = ref
                            .read(compareListProvider.notifier)
                            .toggle(college.id);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('You can compare up to 4 colleges.')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openResults(
    BuildContext context, {
    String query = '',
    String? displayText,
    bool? autofocusSearch,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CollegeSearchResultsScreen(
          initialQuery: query,
          displayText: displayText,
          autofocusSearch: autofocusSearch ?? query.isEmpty,
        ),
      ),
    );
  }
}

class _StreamBadge extends ConsumerWidget {
  const _StreamBadge({required this.stream});

  final StudentStream stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0xFF0D2040),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        builder: (_) => StreamPickerView(
          title: 'Switch stream',
          message: 'Colleges shown will update to match the new stream.',
          onPicked: (s) {
            ref.read(streamOverrideProvider.notifier).state = s;
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: stream.gradientColors),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(stream.icon, color: Colors.white, size: 15),
            const SizedBox(width: 6),
            Text('${stream.label} Stream',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            const Icon(Icons.expand_more, color: Colors.white, size: 15),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white54),
            const SizedBox(width: 10),
            Text('Search college, course, city, state or exam…',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _CourseGrid extends StatelessWidget {
  const _CourseGrid({required this.categories, required this.onTap});

  final List<CourseCategory> categories;
  final ValueChanged<CourseCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final cat = categories[i];
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
                Text(
                  cat.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
