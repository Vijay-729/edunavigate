import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/counselling_model.dart';
import '../providers/counselling_providers.dart';
import '../services/counselling_query_service.dart';
import '../widgets/counselling_card.dart';
import 'counselling_detail_screen.dart';

/// Search + filter + sort results across every counselling programme.
class CounsellingListScreen extends ConsumerStatefulWidget {
  const CounsellingListScreen(
      {super.key, this.initialCategory, this.initialQuery = ''});

  final CounsellingCategory? initialCategory;
  final String initialQuery;

  @override
  ConsumerState<CounsellingListScreen> createState() =>
      _CounsellingListScreenState();
}

class _CounsellingListScreenState extends ConsumerState<CounsellingListScreen> {
  late final _controller = TextEditingController(text: widget.initialQuery);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialCategory != null) {
        ref.read(counsellingFilterProvider.notifier).state = ref
            .read(counsellingFilterProvider)
            .copyWith(category: widget.initialCategory);
      }
      if (widget.initialQuery.isNotEmpty) {
        ref.read(counsellingSearchQueryProvider.notifier).state =
            widget.initialQuery;
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
    final results = ref.watch(filteredCounsellingProvider);
    final filter = ref.watch(counsellingFilterProvider);
    final savedIds =
        ref.watch(counsellingBookmarkIdsProvider).asData?.value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counselling Programmes'),
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
                    ref.read(counsellingSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search JoSAA, NEET, CUET, CLAT…',
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
                    selected: filter.category == null && !filter.upcomingOnly,
                    onTap: () => ref
                        .read(counsellingFilterProvider.notifier)
                        .state = const CounsellingFilter(),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Upcoming',
                    selected: filter.upcomingOnly,
                    onTap: () =>
                        ref.read(counsellingFilterProvider.notifier).state =
                            filter.copyWith(upcomingOnly: !filter.upcomingOnly),
                  ),
                  const SizedBox(width: 8),
                  ...CounsellingCategory.values.map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChipPill(
                          label: cat.label,
                          selected: filter.category == cat,
                          onTap: () => ref
                                  .read(counsellingFilterProvider.notifier)
                                  .state =
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
                  Text('${results.length} programmes',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                  const Spacer(),
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
                      title: 'No matching programmes',
                      message: 'Try a different keyword or clear your filters.',
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final program = results[index];
                        return CounsellingCard(
                          program: program,
                          isSaved: savedIds.contains(program.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => CounsellingDetailScreen(
                                    programId: program.id)),
                          ),
                          onSave: () => ref
                              .read(counsellingBookmarkRepositoryProvider)
                              .toggle(
                                  program.id, savedIds.contains(program.id)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final current = ref.read(counsellingSortOrderProvider);
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
            ...CounsellingSortOrder.values.map((order) {
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
                  ref.read(counsellingSortOrderProvider.notifier).state = order;
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
