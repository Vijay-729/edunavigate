import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/career_roadmap_providers.dart';
import '../services/career_query_service.dart';
import '../widgets/career_card.dart';
import 'career_compare_screen.dart';
import 'career_detail_screen.dart';

/// Browse-all / search results across every career in the database.
class CareerListScreen extends ConsumerStatefulWidget {
  const CareerListScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  ConsumerState<CareerListScreen> createState() => _CareerListScreenState();
}

class _CareerListScreenState extends ConsumerState<CareerListScreen> {
  late final _controller = TextEditingController(text: widget.initialQuery);

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(careerSearchQueryProvider.notifier).state =
              widget.initialQuery;
        }
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
    final results = ref.watch(filteredCareersProvider);
    final all = ref.watch(allCareersProvider);
    final filter = ref.watch(careerFilterProvider);
    final scores = ref.watch(careerMatchScoresProvider);
    final savedIds =
        ref.watch(careerBookmarkIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(careerCompareListProvider);
    final domains = CareerQueryService.distinctDomains(all);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Careers'),
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
                    ref.read(careerSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search career, domain, recruiter…',
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
                    selected: filter.domain == null && !filter.remoteOnly,
                    onTap: () => ref.read(careerFilterProvider.notifier).state =
                        const CareerFilter(),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Remote-Friendly',
                    selected: filter.remoteOnly,
                    onTap: () => ref.read(careerFilterProvider.notifier).state =
                        filter.copyWith(remoteOnly: !filter.remoteOnly),
                  ),
                  const SizedBox(width: 8),
                  ...domains.map((d) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChipPill(
                          label: d,
                          selected: filter.domain == d,
                          onTap: () =>
                              ref.read(careerFilterProvider.notifier).state =
                                  filter.domain == d
                                      ? filter.copyWith(clearDomain: true)
                                      : filter.copyWith(domain: d),
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
                  Text('${results.length} careers',
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
                      title: 'No matching careers',
                      message: 'Try a different keyword or clear your filters.')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final career = results[index];
                        return CareerCard(
                          career: career,
                          matchPercent: scores[career.id],
                          isSaved: savedIds.contains(career.id),
                          isComparing: compareIds.contains(career.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    CareerDetailScreen(careerId: career.id)),
                          ),
                          onSave: () => ref
                              .read(careerRoadmapBookmarkRepositoryProvider)
                              .toggle(career.id, savedIds.contains(career.id)),
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
                      builder: (_) => const CareerCompareScreen())),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${compareIds.length})'),
            )
          : null,
    );
  }

  void _showSortSheet(BuildContext context) {
    final current = ref.read(careerSortOrderProvider);
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
            ...CareerSortOrder.values.map((order) {
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
                  ref.read(careerSortOrderProvider.notifier).state = order;
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
