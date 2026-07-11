import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../models/college_model.dart';
import '../providers/college_providers.dart';
import '../utils/college_formatters.dart';
import '../widgets/college_visuals.dart';
import '../widgets/empty_state_view.dart';

/// Side-by-side comparison of up to 4 colleges (spec: fees, placement,
/// hostel, campus, faculty, cutoff, scholarship, facilities, package, rank).
class CollegeCompareScreen extends ConsumerWidget {
  const CollegeCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(compareListProvider);
    final colleges = ids
        .map((id) => ref.watch(collegeByIdProvider(id)))
        .whereType<CollegeModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Colleges'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (colleges.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(compareListProvider.notifier).clear(),
              child: const Text('Clear all'),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: colleges.isEmpty
            ? const EmptyStateView(
                icon: Icons.compare_arrows,
                title: 'Nothing to compare yet',
                message:
                    'Add up to 4 colleges from the explorer using the "Compare" button on each card.',
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RowLabels(colleges: colleges),
                    ...colleges.map((c) => _CollegeColumn(
                          college: c,
                          onRemove: () => ref
                              .read(compareListProvider.notifier)
                              .toggle(c.id),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

const _rowLabels = [
  'Ranking',
  'Type',
  'Fees / year',
  'Avg. Package',
  'Highest Package',
  'Placement %',
  'Hostel',
  'Scholarship',
  'Facilities',
  'Faculty',
  'Cutoff (General)',
];

class _RowLabels extends StatelessWidget {
  const _RowLabels({required this.colleges});

  final List<CollegeModel> colleges;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 168),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _rowLabels
            .map((l) => Container(
                  width: 110,
                  height: 56,
                  alignment: Alignment.centerLeft,
                  child: Text(l,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ))
            .toList(),
      ),
    );
  }
}

class _CollegeColumn extends StatelessWidget {
  const _CollegeColumn({required this.college, required this.onRemove});

  final CollegeModel college;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = collegeAccentColor(college.id);
    final generalCutoff =
        college.cutoffs.where((c) => c.category == 'general').toList();
    final cutoffText = generalCutoff.isEmpty
        ? '—'
        : (generalCutoff.first.closingRank != null
            ? 'Rank ${CollegeFormatters.rank(generalCutoff.first.closingRank)}'
            : 'Score ${generalCutoff.first.closingScore}');

    return Container(
      width: 170,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(college.logoInitials,
                      style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 16, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: Text(
              college.name,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3),
            ),
          ),
          _cell(college.nirfRank != null ? '#${college.nirfRank}' : '—'),
          _cell(college.type.label),
          _cell(CollegeFormatters.rupeesShort(college.startingFeePerYear)),
          _cell(CollegeFormatters.lpa(college.placement.averagePackageLpa)),
          _cell(CollegeFormatters.lpa(college.placement.highestPackageLpa)),
          _cell(college.placement.placementPercentage > 0
              ? '${college.placement.placementPercentage.round()}%'
              : '—'),
          _cell(college.hasHostel ? 'Yes' : 'No',
              color:
                  college.hasHostel ? const Color(0xFF22C55E) : Colors.white38),
          _cell(college.scholarshipsAvailable ? 'Yes' : 'No',
              color: college.scholarshipsAvailable
                  ? const Color(0xFF22C55E)
                  : Colors.white38),
          _cell('${college.facilities.length} facilities'),
          _cell(college.facultyInfo, maxLines: 3),
          _cell(cutoffText),
        ],
      ),
    );
  }

  Widget _cell(String text, {Color color = Colors.white, int maxLines = 2}) {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.3),
      ),
    );
  }
}
