import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/counselling_providers.dart';
import '../widgets/counselling_card.dart';
import 'counselling_detail_screen.dart';

class SavedCounsellingScreen extends ConsumerWidget {
  const SavedCounsellingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCounsellingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Counselling'),
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
                title: 'No saved counselling programmes',
                message:
                    'Tap the bookmark icon on any programme to save it here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final p = saved[i];
                  return CounsellingCard(
                    program: p,
                    isSaved: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              CounsellingDetailScreen(programId: p.id)),
                    ),
                    onSave: () => ref
                        .read(counsellingBookmarkRepositoryProvider)
                        .toggle(p.id, true),
                  );
                },
              ),
      ),
    );
  }
}
