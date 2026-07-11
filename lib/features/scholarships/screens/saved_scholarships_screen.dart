import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/share_service.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/bookmark_repository.dart';
import '../data/scholarship_data.dart';
import '../models/scholarship.dart';
import '../providers/scholarship_providers.dart';
import '../widgets/scholarship_card.dart';
import 'scholarship_detail_screen.dart';

/// "My Saved Scholarships" — every bookmarked scholarship in one place,
/// reusing the same [ScholarshipCard] and bookmark plumbing as the main
/// Scholarship Explorer list.
class SavedScholarshipsScreen extends ConsumerWidget {
  const SavedScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkIds =
        ref.watch(bookmarkIdsProvider).asData?.value ?? const {};
    final recommendedIds =
        ref.watch(recommendedScholarshipsProvider).map((s) => s.id).toSet();
    final saved =
        ScholarshipData.all.where((s) => bookmarkIds.contains(s.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Saved Scholarships'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: saved.isEmpty
            ? const EmptyStateView(
                icon: Icons.bookmark_border_rounded,
                title: 'No saved scholarships yet',
                message:
                    'Tap the bookmark icon on any scholarship to save it here '
                    'for quick access later.',
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final s = saved[index];
                  return ScholarshipCard(
                    scholarship: s,
                    isBookmarked: true,
                    isRecommended: recommendedIds.contains(s.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ScholarshipDetailScreen(scholarship: s),
                      ),
                    ),
                    onBookmark: () =>
                        ref.read(bookmarkRepositoryProvider).toggle(s.id, true),
                    onShare: () => _share(s),
                  );
                },
              ),
      ),
    );
  }

  void _share(Scholarship s) {
    ShareService.shareText(
      '${s.title} — ${s.organization}\n${s.eligibility}\n'
      'Amount: ${s.amount}\nDeadline: ${s.deadline}\n\n${s.applyUrl}',
      subject: s.title,
    );
  }
}
