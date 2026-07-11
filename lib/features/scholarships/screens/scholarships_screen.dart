import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/bookmark_repository.dart';
import '../models/scholarship.dart';
import '../providers/scholarship_providers.dart';
import '../widgets/scholarship_card.dart';
import '../widgets/scholarship_filter_sheet.dart';
import '../widgets/scholarship_personalize_sheet.dart';
import '../widgets/scholarship_sort_sheet.dart';
import 'saved_scholarships_screen.dart';
import 'scholarship_detail_screen.dart';

class ScholarshipsScreen extends ConsumerWidget {
  const ScholarshipsScreen({super.key});

  bool _isDefaultView(ScholarshipFilter filter) =>
      filter.query.trim().isEmpty &&
      filter.provider == null &&
      !filter.onlyBookmarked &&
      !filter.onlyClosingSoon &&
      !filter.onlyRecommended &&
      filter.state == null &&
      !filter.hasAdvancedFilters;

  void _share(Scholarship s) {
    ShareService.shareText(
      '${s.title} — ${s.organization}\n${s.eligibility}\n'
      'Amount: ${s.amount}\nDeadline: ${s.deadline}\n\n${s.applyUrl}',
      subject: s.title,
    );
  }

  void _openDetail(BuildContext context, Scholarship s) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ScholarshipDetailScreen(scholarship: s),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scholarships = ref.watch(filteredScholarshipsProvider);
    final filter = ref.watch(scholarshipFilterProvider);
    final sortOrder = ref.watch(scholarshipSortOrderProvider);
    final bookmarks = ref.watch(bookmarkIdsProvider).asData?.value ?? const {};
    final profile = ref.watch(currentProfileProvider).asData?.value;
    final notifier = ref.read(scholarshipFilterProvider.notifier);
    final recommended = ref.watch(recommendedScholarshipsProvider);
    final recommendedIds = recommended.map((s) => s.id).toSet();
    final closingSoonCount = ref.watch(closingSoonScholarshipsProvider).length;
    final isDefaultView = _isDefaultView(filter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarships'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Personalize recommendations',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              final prefs = ref.read(scholarshipPreferencesProvider);
              showScholarshipPersonalizeSheet(
                context,
                current: prefs,
                onSave: (updated) => ref
                    .read(scholarshipPreferencesProvider.notifier)
                    .update((_) => updated),
              );
            },
          ),
          IconButton(
            tooltip: 'My Saved Scholarships',
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => const SavedScholarshipsScreen()),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => notifier.update((s) => s.copyWith(query: v)),
                decoration: InputDecoration(
                  hintText: 'Search by name, provider, state, category…',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
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
                    selected: isDefaultView,
                    onTap: () => notifier.state = const ScholarshipFilter(),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Government',
                    selected: filter.provider == ScholarshipProvider.government,
                    onTap: () => notifier.update(
                      (s) => s.provider == ScholarshipProvider.government
                          ? s.copyWith(clearProvider: true)
                          : s.copyWith(
                              provider: ScholarshipProvider.government),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Private',
                    selected: filter.provider == ScholarshipProvider.private,
                    onTap: () => notifier.update(
                      (s) => s.provider == ScholarshipProvider.private
                          ? s.copyWith(clearProvider: true)
                          : s.copyWith(provider: ScholarshipProvider.private),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: '⭐ Recommended',
                    selected: filter.onlyRecommended,
                    onTap: () => notifier.update(
                        (s) => s.copyWith(onlyRecommended: !s.onlyRecommended)),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: closingSoonCount > 0
                        ? '🔥 Closing Soon ($closingSoonCount)'
                        : '🔥 Closing Soon',
                    selected: filter.onlyClosingSoon,
                    onTap: () => notifier.update(
                        (s) => s.copyWith(onlyClosingSoon: !s.onlyClosingSoon)),
                  ),
                  const SizedBox(width: 8),
                  if (profile != null && profile.state.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChipPill(
                        label: 'My State',
                        selected: filter.state != null,
                        onTap: () => notifier.update(
                          (s) => s.state == null
                              ? s.copyWith(state: profile.state)
                              : s.copyWith(clearState: true),
                        ),
                      ),
                    ),
                  FilterChipPill(
                    label: '★ Bookmarked',
                    selected: filter.onlyBookmarked,
                    onTap: () => notifier.update(
                        (s) => s.copyWith(onlyBookmarked: !s.onlyBookmarked)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => showScholarshipFilterSheet(
                        context,
                        current: filter,
                        onApply: (updated) => notifier.state = updated,
                      ),
                      icon: const Icon(Icons.filter_list_rounded, size: 18),
                      label: Text(filter.activeFilterCount > 0
                          ? 'Filters (${filter.activeFilterCount})'
                          : 'Filters'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        foregroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => showScholarshipSortSheet(
                        context,
                        current: sortOrder,
                        onSelected: (order) => ref
                            .read(scholarshipSortOrderProvider.notifier)
                            .state = order,
                      ),
                      icon: const Icon(Icons.sort_rounded, size: 18),
                      label: Text('Sort: ${sortOrder.label}',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: scholarships.isEmpty
                  ? const EmptyStateView(
                      icon: Icons.search_off,
                      title: 'No scholarships match your filters',
                      message: 'Try a different keyword, or clear a filter.',
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                      children: [
                        if (isDefaultView && recommended.isNotEmpty) ...[
                          const _SectionLabel('Recommended For You ⭐'),
                          const SizedBox(height: 10),
                          ...recommended.take(5).map((s) {
                            final isBookmarked = bookmarks.contains(s.id);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ScholarshipCard(
                                scholarship: s,
                                isBookmarked: isBookmarked,
                                isRecommended: true,
                                onTap: () => _openDetail(context, s),
                                onBookmark: () => ref
                                    .read(bookmarkRepositoryProvider)
                                    .toggle(s.id, isBookmarked),
                                onShare: () => _share(s),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          const _SectionLabel('All Scholarships'),
                          const SizedBox(height: 10),
                        ],
                        ...scholarships.map((s) {
                          final isBookmarked = bookmarks.contains(s.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ScholarshipCard(
                              scholarship: s,
                              isBookmarked: isBookmarked,
                              isRecommended: recommendedIds.contains(s.id),
                              onTap: () => _openDetail(context, s),
                              onBookmark: () => ref
                                  .read(bookmarkRepositoryProvider)
                                  .toggle(s.id, isBookmarked),
                              onShare: () => _share(s),
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
      ),
    );
  }
}
