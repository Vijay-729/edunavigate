import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/saved_college_repository.dart';
import '../providers/college_providers.dart';
import '../services/college_query_service.dart';
import '../widgets/college_card.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/quick_filter_chip.dart';
import '../widgets/sort_sheet.dart';
import 'college_compare_screen.dart';
import 'college_details_screen.dart';

/// Full search + filter + sort experience. Reused for "See all" links from
/// the explorer home, quick filters, and the top search bar.
class CollegeSearchResultsScreen extends ConsumerStatefulWidget {
  const CollegeSearchResultsScreen({
    super.key,
    this.initialQuery = '',
    this.displayText,
    this.autofocusSearch = false,
  });

  final String initialQuery;

  /// Text to show in the search field without feeding it into the free-text
  /// search pipeline — used by "Popular Searches" chips (e.g. "JEE Colleges")
  /// whose results are driven by [collegeFilterProvider], not [collegeSearchQueryProvider].
  final String? displayText;
  final bool autofocusSearch;

  @override
  ConsumerState<CollegeSearchResultsScreen> createState() =>
      _CollegeSearchResultsScreenState();
}

class _CollegeSearchResultsScreenState
    extends ConsumerState<CollegeSearchResultsScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.displayText ?? widget.initialQuery);

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(collegeSearchQueryProvider.notifier).state =
            widget.initialQuery;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredCollegesProvider);
    final allStreamColleges = ref.watch(streamCollegesProvider);
    final filter = ref.watch(collegeFilterProvider);
    final sortOrder = ref.watch(collegeSortOrderProvider);
    final matchScores = ref.watch(collegeMatchScoresProvider);
    final savedIds =
        ref.watch(savedCollegeIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(compareListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Colleges'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _controller,
                autofocus: widget.autofocusSearch,
                style: const TextStyle(color: Colors.white),
                onChanged: (v) =>
                    ref.read(collegeSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'College, course, city, state or exam…',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            ref
                                .read(collegeSearchQueryProvider.notifier)
                                .state = '';
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        _quickChip(
                            'Government',
                            filter.governmentOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(governmentOnly: v))),
                        _quickChip(
                            'Private',
                            filter.privateOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(privateOnly: v))),
                        _quickChip(
                            'Hostel',
                            filter.hostelOnly,
                            (v) =>
                                _patchFilter((f) => f.copyWith(hostelOnly: v))),
                        _quickChip(
                            'Scholarship',
                            filter.scholarshipOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(scholarshipOnly: v))),
                        _quickChip(
                            'Low Fees',
                            filter.lowFeesOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(lowFeesOnly: v))),
                        _quickChip(
                            'High Placement',
                            filter.highPlacementOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(highPlacementOnly: v))),
                        _quickChip(
                            'AI Recommended',
                            filter.aiRecommendedOnly,
                            (v) => _patchFilter(
                                (f) => f.copyWith(aiRecommendedOnly: v))),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('${results.length} colleges',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => showCollegeFilterSheet(
                      context,
                      current: filter,
                      availableStates:
                          CollegeQueryService.distinctStates(allStreamColleges),
                      availableCategories: allStreamColleges
                          .expand((c) => c.categories)
                          .toSet()
                          .toList(),
                      onApply: (f) =>
                          ref.read(collegeFilterProvider.notifier).state = f,
                    ),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Filter'),
                  ),
                  TextButton.icon(
                    onPressed: () => showSortSheet(
                      context,
                      current: sortOrder,
                      onSelected: (o) =>
                          ref.read(collegeSortOrderProvider.notifier).state = o,
                    ),
                    icon: const Icon(Icons.swap_vert, size: 18),
                    label: const Text('Sort'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? SingleChildScrollView(
                      child: EmptyStateView(
                        title: 'No exact match found',
                        message:
                            'Try a nearby college, a similar course, or a different state/exam.',
                        suggestions: const [
                          'Clear filters',
                          'Nearby states',
                          'Similar courses'
                        ],
                        onSuggestionTap: (s) {
                          if (s == 'Clear filters') {
                            ref.read(collegeFilterProvider.notifier).state =
                                const CollegeFilter();
                            ref
                                .read(collegeSearchQueryProvider.notifier)
                                .state = '';
                            _controller.clear();
                          }
                        },
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final college = results[index];
                        return CollegeCard(
                          college: college,
                          matchPercent: matchScores[college.id],
                          isSaved: savedIds.contains(college.id),
                          isComparing: compareIds.contains(college.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => CollegeDetailsScreen(
                                    collegeId: college.id)),
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
                                    content: Text(
                                        'You can compare up to 4 colleges.')),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: compareIds.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const CollegeCompareScreen()),
              ),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${compareIds.length})'),
            )
          : null,
    );
  }

  Widget _quickChip(String label, bool selected, ValueChanged<bool> onToggle) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: QuickFilterChip(
          label: label, selected: selected, onTap: () => onToggle(!selected)),
    );
  }

  void _patchFilter(CollegeFilter Function(CollegeFilter) transform) {
    final current = ref.read(collegeFilterProvider);
    ref.read(collegeFilterProvider.notifier).state = transform(current);
  }
}
