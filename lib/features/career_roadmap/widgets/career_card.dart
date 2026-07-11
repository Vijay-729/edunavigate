import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/career_roadmap_model.dart';

/// List-item card for a career — used across recommended rails, browse-all
/// search results, and the saved list.
class CareerCard extends StatelessWidget {
  const CareerCard({
    super.key,
    required this.career,
    this.matchPercent,
    this.isSaved = false,
    this.isComparing = false,
    this.onTap,
    this.onSave,
    this.onCompareToggle,
  });

  final CareerRoadmapModel career;
  final double? matchPercent;
  final bool isSaved;
  final bool isComparing;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onCompareToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: career.accent.withValues(alpha: 0.25)),
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
                      color: career.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: career.accent.withValues(alpha: 0.4)),
                    ),
                    child: Icon(career.icon, color: career.accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(career.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(career.domain,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onSave,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? AppColors.accent : Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                career.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12.5,
                    height: 1.4),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: StatChip(
                          icon: Icons.payments_outlined,
                          label: career.indiaSalaryRange)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (matchPercent != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('${matchPercent!.round()}% Match',
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  const Spacer(),
                  if (onCompareToggle != null)
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
                                  : Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                isComparing
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 13,
                                color: isComparing
                                    ? AppColors.accent
                                    : Colors.white60),
                            const SizedBox(width: 4),
                            Text('Compare',
                                style: TextStyle(
                                    color: isComparing
                                        ? AppColors.accent
                                        : Colors.white60,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600)),
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
}
