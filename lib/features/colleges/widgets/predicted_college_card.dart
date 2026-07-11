import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/prediction_model.dart';
import '../utils/college_formatters.dart';
import 'college_visuals.dart';
import 'stat_chip.dart';

/// One predicted college+course card inside the Dream/Target/Safe sections
/// of the College Predictor result screen.
class PredictedCollegeCard extends StatelessWidget {
  const PredictedCollegeCard({
    super.key,
    required this.predicted,
    this.onApply,
    this.onExplore,
  });

  final PredictedCollege predicted;
  final VoidCallback? onApply;
  final VoidCallback? onExplore;

  Color get _tierColor {
    switch (predicted.tier) {
      case PredictionTier.safe:
        return const Color(0xFF22C55E);
      case PredictionTier.target:
        return const Color(0xFFF59E0B);
      case PredictionTier.dream:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = collegeAccentColor(predicted.collegeId);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _tierColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  predicted.collegeName.substring(0, 1),
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      predicted.collegeName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      predicted.courseName,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _tierColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${predicted.probability.round()}%',
                  style: TextStyle(
                      color: _tierColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              StatChip(
                icon: Icons.flag_outlined,
                label:
                    'Cutoff ~${CollegeFormatters.rank(predicted.expectedCutoffRank)}',
              ),
              StatChip(
                icon: Icons.history,
                label:
                    'Prev. ${CollegeFormatters.rank(predicted.previousClosingRank)}',
              ),
              StatChip(
                icon: Icons.currency_rupee,
                label:
                    '${CollegeFormatters.rupeesShort(predicted.feesPerYear)}/yr',
              ),
              StatChip(
                icon: Icons.payments_outlined,
                label: CollegeFormatters.lpa(predicted.averagePackageLpa),
              ),
              if (predicted.hostelAvailable)
                const StatChip(
                    icon: Icons.hotel_outlined,
                    label: 'Hostel',
                    color: Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome,
                    size: 15, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    predicted.aiReason,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12.5,
                        height: 1.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onExplore,
                  child: const Text('Explore'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApply,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
