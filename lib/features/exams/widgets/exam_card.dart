import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/stat_chip.dart';
import '../../explore/screens/place_card_widgets.dart';
import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';

/// List-item card for an exam — used across the home dashboard rails,
/// search results, calendar agenda, and saved list.
class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    this.isSaved = false,
    this.isComparing = false,
    this.onTap,
    this.onSave,
    this.onCompareToggle,
  });

  final ExamProfileModel exam;
  final bool isSaved;
  final bool isComparing;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onCompareToggle;

  Color get _statusColor {
    switch (exam.applicationStatus) {
      case ExamApplicationStatus.ongoing:
        return const Color(0xFF22C55E);
      case ExamApplicationStatus.upcoming:
        return const Color(0xFFF59E0B);
      case ExamApplicationStatus.closed:
        return const Color(0xFFEF4444);
      case ExamApplicationStatus.completed:
        return Colors.white38;
    }
  }

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
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  exam.wikipediaTitle == null
                      ? Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child:
                              Icon(exam.category.icon, color: AppColors.accent),
                        )
                      : InstitutionLogoAvatar(
                          wikidataId: null,
                          wikipediaTitle: exam.wikipediaTitle,
                          fallbackIcon: exam.category.icon,
                          size: 44,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exam.shortName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(exam.conductingBody,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(exam.applicationStatus.label,
                        style: TextStyle(
                            color: _statusColor,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(exam.difficulty.label,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700)),
                  ),
                  if (exam.state != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(exam.state!,
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatChip(
                      icon: Icons.category_outlined,
                      label: exam.category.label),
                  const SizedBox(width: 14),
                  if (exam.nextUpcomingEvent != null)
                    Expanded(
                      child: StatChip(
                        icon: Icons.event_outlined,
                        label: exam.nextUpcomingEvent!.label,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                ],
              ),
              if (onCompareToggle != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
