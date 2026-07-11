import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/career_roadmap_providers.dart';
import '../widgets/career_card.dart';
import 'career_detail_screen.dart';

class SavedCareersScreen extends ConsumerWidget {
  const SavedCareersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCareersProvider);
    final scores = ref.watch(careerMatchScoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Careers'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: saved.isEmpty
            ? const EmptyStateView(
                icon: Icons.bookmark_border,
                title: 'No saved careers',
                message: 'Tap the bookmark icon on any career to save it here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final c = saved[i];
                  return CareerCard(
                    career: c,
                    matchPercent: scores[c.id],
                    isSaved: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => CareerDetailScreen(careerId: c.id)),
                    ),
                    onSave: () => ref
                        .read(careerRoadmapBookmarkRepositoryProvider)
                        .toggle(c.id, true),
                  );
                },
              ),
      ),
    );
  }
}
