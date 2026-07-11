import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/college_model.dart';
import '../utils/college_formatters.dart';
import 'college_visuals.dart';
import 'match_badge.dart';
import 'stat_chip.dart';

/// The primary college list-item card — used across the explorer home,
/// search results, saved, and recommended sections.
class CollegeCard extends StatelessWidget {
  const CollegeCard({
    super.key,
    required this.college,
    this.matchPercent,
    this.isSaved = false,
    this.isComparing = false,
    this.onTap,
    this.onSave,
    this.onCompareToggle,
  });

  final CollegeModel college;
  final double? matchPercent;
  final bool isSaved;
  final bool isComparing;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onCompareToggle;

  @override
  Widget build(BuildContext context) {
    final accent = collegeAccentColor(college.id);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accent.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      college.logoInitials,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          college.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 13,
                                color: Colors.white.withValues(alpha: 0.5)),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                '${college.city}, ${college.state}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onSave,
                    tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppColors.accent : Colors.white54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (college.nirfRank != null)
                    _tag('NIRF #${college.nirfRank}', const Color(0xFFF59E0B)),
                  _tag(college.type.label, accent),
                  if (college.naacGrade != null)
                    _tag('NAAC ${college.naacGrade}', const Color(0xFF22C55E)),
                  ...college.courses.take(2).map(
                      (c) => _tag(c.shortName, Colors.white38, filled: false)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatChip(
                      icon: Icons.payments_outlined,
                      label: CollegeFormatters.lpa(
                          college.placement.averagePackageLpa),
                    ),
                  ),
                  Expanded(
                    child: StatChip(
                      icon: Icons.currency_rupee,
                      label:
                          '${CollegeFormatters.rupeesShort(college.startingFeePerYear)}/yr',
                    ),
                  ),
                  if (college.hasHostel)
                    const StatChip(
                      icon: Icons.hotel_outlined,
                      label: 'Hostel',
                      color: Color(0xFF60A5FA),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (matchPercent != null)
                    MatchBadge(percent: matchPercent!, compact: true),
                  const Spacer(),
                  GestureDetector(
                    onTap: onCompareToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isComparing
                            ? AppColors.primary.withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isComparing
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isComparing
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            size: 13,
                            color:
                                isComparing ? AppColors.accent : Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Compare',
                            style: TextStyle(
                              color: isComparing
                                  ? AppColors.accent
                                  : Colors.white60,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, Color color, {bool filled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.16) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? color : Colors.white60,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
