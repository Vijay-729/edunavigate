import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/saved_college_repository.dart';
import '../models/college_model.dart';
import '../providers/college_providers.dart';
import '../widgets/college_card.dart';
import '../widgets/college_card_skeleton.dart';
import '../widgets/empty_state_view.dart';
import 'college_details_screen.dart';

/// "Save Colleges / Favourite Colleges / Recently Viewed" (spec §Save
/// Feature) — two tabs backed by Firestore-persisted sets.
class SavedCollegesScreen extends ConsumerStatefulWidget {
  const SavedCollegesScreen({super.key});

  @override
  ConsumerState<SavedCollegesScreen> createState() =>
      _SavedCollegesScreenState();
}

class _SavedCollegesScreenState extends ConsumerState<SavedCollegesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Colleges'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Saved'),
            Tab(text: 'Recently Viewed'),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: TabBarView(
          controller: _tabController,
          children: const [
            _SavedTab(),
            _RecentlyViewedTab(),
          ],
        ),
      ),
    );
  }
}

class _SavedTab extends ConsumerWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedCollegeIdsProvider);

    return savedAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CollegeListSkeleton(),
      ),
      error: (_, __) => const EmptyStateView(
        icon: Icons.error_outline,
        title: 'Could not load saved colleges',
        message: 'Please check your connection and try again.',
      ),
      data: (ids) {
        if (ids.isEmpty) {
          return const EmptyStateView(
            icon: Icons.bookmark_border,
            title: 'No saved colleges yet',
            message:
                'Tap the bookmark icon on any college card to save it here.',
          );
        }
        return Consumer(builder: (context, ref, _) {
          final colleges = ids
              .map((id) => ref.watch(collegeByIdProvider(id)))
              .whereType<CollegeModel>()
              .toList();
          final scores = ref.watch(collegeMatchScoresProvider);
          final compareIds = ref.watch(compareListProvider);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: colleges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = colleges[i];
              return CollegeCard(
                college: c,
                matchPercent: scores[c.id],
                isSaved: true,
                isComparing: compareIds.contains(c.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => CollegeDetailsScreen(collegeId: c.id)),
                ),
                onSave: () => ref
                    .read(savedCollegeRepositoryProvider)
                    .toggleSaved(c.id, true),
                onCompareToggle: () =>
                    ref.read(compareListProvider.notifier).toggle(c.id),
              );
            },
          );
        });
      },
    );
  }
}

class _RecentlyViewedTab extends ConsumerWidget {
  const _RecentlyViewedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentlyViewedCollegeIdsProvider);

    return recentAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CollegeListSkeleton(),
      ),
      error: (_, __) => const EmptyStateView(
        icon: Icons.error_outline,
        title: 'Could not load recently viewed colleges',
        message: 'Please check your connection and try again.',
      ),
      data: (ids) {
        if (ids.isEmpty) {
          return const EmptyStateView(
            icon: Icons.history,
            title: 'Nothing viewed yet',
            message: 'Colleges you open will show up here automatically.',
          );
        }
        return Consumer(builder: (context, ref, _) {
          final colleges = ids
              .map((id) => ref.watch(collegeByIdProvider(id)))
              .whereType<CollegeModel>()
              .toList();
          final scores = ref.watch(collegeMatchScoresProvider);
          final savedIds =
              ref.watch(savedCollegeIdsProvider).asData?.value ?? const {};
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: colleges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = colleges[i];
              return CollegeCard(
                college: c,
                matchPercent: scores[c.id],
                isSaved: savedIds.contains(c.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => CollegeDetailsScreen(collegeId: c.id)),
                ),
                onSave: () => ref
                    .read(savedCollegeRepositoryProvider)
                    .toggleSaved(c.id, savedIds.contains(c.id)),
              );
            },
          );
        });
      },
    );
  }
}
