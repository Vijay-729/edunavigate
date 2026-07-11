import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/exam_providers.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

class SavedExamsScreen extends ConsumerWidget {
  const SavedExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedExamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Exams'),
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
                title: 'No saved exams',
                message: 'Tap the bookmark icon on any exam to save it here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = saved[i];
                  return ExamCard(
                    exam: e,
                    isSaved: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => ExamDetailScreen(examId: e.id)),
                    ),
                    onSave: () => ref
                        .read(examBookmarkRepositoryProvider)
                        .toggle(e.id, true),
                  );
                },
              ),
      ),
    );
  }
}
