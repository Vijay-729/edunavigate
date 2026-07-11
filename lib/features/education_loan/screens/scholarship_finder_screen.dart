import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../scholarships/data/bookmark_repository.dart';
import '../../scholarships/models/scholarship.dart';
import '../../scholarships/providers/scholarship_providers.dart'
    show bookmarkIdsProvider;
import '../providers/loan_providers.dart';

/// Scholarship Finder — searches the existing Scholarships dataset with
/// extra facets (course/gender/minority/disability) layered on top.
class ScholarshipFinderScreen extends ConsumerStatefulWidget {
  const ScholarshipFinderScreen({super.key});

  @override
  ConsumerState<ScholarshipFinderScreen> createState() =>
      _ScholarshipFinderScreenState();
}

class _ScholarshipFinderScreenState
    extends ConsumerState<ScholarshipFinderScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(scholarshipFinderResultsProvider);
    final filter = ref.watch(scholarshipFinderFilterProvider);
    final bookmarks = ref.watch(bookmarkIdsProvider).asData?.value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Finder'),
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
                onChanged: (v) => ref
                    .read(scholarshipFinderFilterProvider.notifier)
                    .state = filter.copyWith(query: v),
                decoration: InputDecoration(
                  hintText: 'Search scholarships…',
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
                    label: 'Government',
                    selected: filter.provider == ScholarshipProvider.government,
                    onTap: () => ref
                            .read(scholarshipFinderFilterProvider.notifier)
                            .state =
                        filter.provider == ScholarshipProvider.government
                            ? filter.copyWith(clearProvider: true)
                            : filter.copyWith(
                                provider: ScholarshipProvider.government),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Private',
                    selected: filter.provider == ScholarshipProvider.private,
                    onTap: () => ref
                            .read(scholarshipFinderFilterProvider.notifier)
                            .state =
                        filter.provider == ScholarshipProvider.private
                            ? filter.copyWith(clearProvider: true)
                            : filter.copyWith(
                                provider: ScholarshipProvider.private),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Minority',
                    selected: filter.minorityOnly,
                    onTap: () => ref
                            .read(scholarshipFinderFilterProvider.notifier)
                            .state =
                        filter.copyWith(minorityOnly: !filter.minorityOnly),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Disability',
                    selected: filter.disabilityOnly,
                    onTap: () => ref
                            .read(scholarshipFinderFilterProvider.notifier)
                            .state =
                        filter.copyWith(disabilityOnly: !filter.disabilityOnly),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'For Girls',
                    selected:
                        filter.gender == 'girls' || filter.gender == 'women',
                    onTap: () => ref
                            .read(scholarshipFinderFilterProvider.notifier)
                            .state =
                        (filter.gender == 'girls' || filter.gender == 'women')
                            ? filter.copyWith(clearGender: true)
                            : filter.copyWith(gender: 'girls'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: results.isEmpty
                  ? const EmptyStateView(
                      title: 'No matching scholarships',
                      message: 'Try a different keyword or clear your filters.')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final s = results[index];
                        final isBookmarked = bookmarks.contains(s.id);
                        return _ScholarshipTile(
                          scholarship: s,
                          isBookmarked: isBookmarked,
                          onBookmark: () => ref
                              .read(bookmarkRepositoryProvider)
                              .toggle(s.id, isBookmarked),
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

class _ScholarshipTile extends StatelessWidget {
  const _ScholarshipTile(
      {required this.scholarship,
      required this.isBookmarked,
      required this.onBookmark});

  final Scholarship scholarship;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(scholarship.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
              IconButton(
                onPressed: onBookmark,
                tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.accent : Colors.white54),
              ),
            ],
          ),
          Text(scholarship.organization,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
          const SizedBox(height: 10),
          Text(scholarship.eligibility,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12.5, height: 1.4)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Text('Amount: ${scholarship.amount}',
                      style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700))),
              TextButton(
                onPressed: () async {
                  final uri = Uri.tryParse(scholarship.applyUrl);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
