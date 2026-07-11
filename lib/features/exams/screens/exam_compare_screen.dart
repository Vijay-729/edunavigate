import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/comparison_table.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';
import '../providers/exam_providers.dart';

const _rowLabels = [
  'Category',
  'Difficulty',
  'Application Fee',
  'Eligibility',
  'Syllabus Scope',
  'Career Scope',
  'Top Colleges',
];

/// Side-by-side comparison of up to 3 exams (spec examples: JEE vs CUET,
/// NEET vs CUET, GATE vs GAT-B).
class ExamCompareScreen extends ConsumerWidget {
  const ExamCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(examCompareListProvider);
    final exams = ids
        .map((id) => ref.watch(examByIdProvider(id)))
        .whereType<ExamProfileModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Exams'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (exams.isNotEmpty)
            TextButton(
                onPressed: () =>
                    ref.read(examCompareListProvider.notifier).clear(),
                child: const Text('Clear all')),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: exams.isEmpty
            ? const EmptyStateView(
                icon: Icons.compare_arrows,
                title: 'Nothing to compare yet',
                message:
                    'Add up to 3 exams from Exam Universe using the "Compare" button on each card.',
              )
            : ComparisonTable(
                rowLabels: _rowLabels,
                columns: exams
                    .map((e) => ComparisonColumn(
                          title: e.shortName,
                          accent: const Color(0xFF3B82F6),
                          onRemove: () => ref
                              .read(examCompareListProvider.notifier)
                              .toggle(e.id),
                          values: [
                            e.category.label,
                            e.difficulty.label,
                            e.applicationFees,
                            e.eligibility,
                            e.syllabus.isNotEmpty
                                ? '${e.syllabus.length} topics'
                                : '—',
                            e.careerOpportunities.take(2).join(', '),
                            e.topCollegesAccepting.take(2).join(', '),
                          ],
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
