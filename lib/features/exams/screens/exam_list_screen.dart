import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/exam_category.dart';
import '../providers/exam_providers.dart';
import '../services/exam_query_service.dart';
import '../widgets/exam_card.dart';
import 'exam_compare_screen.dart';
import 'exam_detail_screen.dart';

/// Search + filter + sort results across the entire exam database.
class ExamListScreen extends ConsumerStatefulWidget {
  const ExamListScreen(
      {super.key, this.initialCategory, this.initialQuery = ''});

  final ExamCategory? initialCategory;
  final String initialQuery;

  @override
  ConsumerState<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends ConsumerState<ExamListScreen> {
  late final _controller = TextEditingController(text: widget.initialQuery);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialCategory != null) {
        ref.read(examFilterProvider.notifier).state = ref
            .read(examFilterProvider)
            .copyWith(category: widget.initialCategory);
      }
      if (widget.initialQuery.isNotEmpty) {
        ref.read(examSearchQueryProvider.notifier).state = widget.initialQuery;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredExamsProvider);
    final filter = ref.watch(examFilterProvider);
    final savedIds =
        ref.watch(examBookmarkIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(examCompareListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Universe'),
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
                style: const TextStyle(color: Colors.white),
                onChanged: (v) =>
                    ref.read(examSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search exam, course, career, college, state…',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterChipPill(
                    label: 'All',
                    selected: filter.isEmpty,
                    onTap: () => ref.read(examFilterProvider.notifier).state =
                        const ExamFilter(),
                  ),
                  const SizedBox(width: 8),
                  ...ExamCategory.values.map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChipPill(
                          label: cat.label,
                          selected: filter.category == cat,
                          onTap: () =>
                              ref.read(examFilterProvider.notifier).state =
                                  filter.category == cat
                                      ? filter.copyWith(clearCategory: true)
                                      : filter.copyWith(category: cat),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('${results.length} exams',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showFilterSheet(context, filter),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Filter'),
                  ),
                  TextButton.icon(
                    onPressed: () => _showSortSheet(context),
                    icon: const Icon(Icons.swap_vert, size: 18),
                    label: const Text('Sort'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const EmptyStateView(
                      title: 'No matching exams',
                      message: 'Try a different keyword or clear your filters.')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final exam = results[index];
                        return ExamCard(
                          exam: exam,
                          isSaved: savedIds.contains(exam.id),
                          isComparing: compareIds.contains(exam.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    ExamDetailScreen(examId: exam.id)),
                          ),
                          onSave: () => ref
                              .read(examBookmarkRepositoryProvider)
                              .toggle(exam.id, savedIds.contains(exam.id)),
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
                      builder: (_) => const ExamCompareScreen())),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${compareIds.length})'),
            )
          : null,
    );
  }

  void _showFilterSheet(BuildContext context, ExamFilter current) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _FilterSheet(current: current),
    );
  }

  void _showSortSheet(BuildContext context) {
    final current = ref.read(examSortOrderProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0D2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort by',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...ExamSortOrder.values.map((order) {
              final selected = order == current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected ? AppColors.primary : Colors.white38),
                title: Text(order.label,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  ref.read(examSortOrderProvider.notifier).state = order;
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet({required this.current});
  final ExamFilter current;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late ExamFilter _draft = widget.current;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              TextButton(
                  onPressed: () => setState(() => _draft = const ExamFilter()),
                  child: const Text('Reset')),
            ],
          ),
          const SizedBox(height: 8),
          _label('Difficulty'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExamDifficulty.values
                .map((d) => FilterChipPill(
                      label: d.label,
                      selected: _draft.difficulty == d,
                      onTap: () => setState(() => _draft =
                          _draft.difficulty == d
                              ? _draft.copyWith(clearDifficulty: true)
                              : _draft.copyWith(difficulty: d)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _label('Application Status'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExamApplicationStatus.values
                .map((s) => FilterChipPill(
                      label: s.label,
                      selected: _draft.status == s,
                      onTap: () => setState(() => _draft = _draft.status == s
                          ? _draft.copyWith(clearStatus: true)
                          : _draft.copyWith(status: s)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _label('Mode'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExamMode.values
                .map((m) => FilterChipPill(
                      label: m.label,
                      selected: _draft.mode == m,
                      onTap: () => setState(() => _draft = _draft.mode == m
                          ? _draft.copyWith(clearMode: true)
                          : _draft.copyWith(mode: m)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _label('State'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (ref
                    .watch(allExamsProvider)
                    .map((e) => e.state)
                    .whereType<String>()
                    .toSet()
                    .toList()
                  ..sort())
                .map((s) => FilterChipPill(
                      label: s,
                      selected: _draft.state == s,
                      onTap: () => setState(() => _draft = _draft.state == s
                          ? _draft.copyWith(clearState: true)
                          : _draft.copyWith(state: s)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _label('Exam Month'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(12, (i) => i + 1)
                .map((m) => FilterChipPill(
                      label: _months[m - 1],
                      selected: _draft.month == m,
                      onTap: () => setState(() => _draft = _draft.month == m
                          ? _draft.copyWith(clearMonth: true)
                          : _draft.copyWith(month: m)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(examFilterProvider.notifier).state = _draft;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      );
}
