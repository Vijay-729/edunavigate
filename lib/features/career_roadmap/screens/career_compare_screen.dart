import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/comparison_table.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/career_roadmap_model.dart';
import '../providers/career_roadmap_providers.dart';

const _rowLabels = [
  'Domain',
  'India Salary',
  'Growth Rate',
  'Demand',
  'Remote-Friendly',
  'Work-Life Balance',
  'Best Degree',
];

/// Side-by-side comparison of up to 3 careers (spec examples: MBBS vs BDS,
/// CSE vs AI, Law vs UPSC).
class CareerCompareScreen extends ConsumerWidget {
  const CareerCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(careerCompareListProvider);
    final careers = ids
        .map((id) => ref.watch(careerByIdProvider(id)))
        .whereType<CareerRoadmapModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Careers'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (careers.isNotEmpty)
            TextButton(
                onPressed: () =>
                    ref.read(careerCompareListProvider.notifier).clear(),
                child: const Text('Clear all')),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: careers.isEmpty
            ? const EmptyStateView(
                icon: Icons.compare_arrows,
                title: 'Nothing to compare yet',
                message:
                    'Add up to 3 careers using the "Compare" button on each card.',
              )
            : ComparisonTable(
                rowLabels: _rowLabels,
                columns: careers
                    .map((c) => ComparisonColumn(
                          title: c.title,
                          accent: c.accent,
                          onRemove: () => ref
                              .read(careerCompareListProvider.notifier)
                              .toggle(c.id),
                          values: [
                            c.domain,
                            c.indiaSalaryRange,
                            c.growthRate,
                            c.demandLevel.label,
                            c.remoteWorkFriendly ? 'Yes' : 'No',
                            '${c.workLifeBalanceRating}/5',
                            c.bestDegrees.isNotEmpty
                                ? c.bestDegrees.first
                                : '—',
                          ],
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
