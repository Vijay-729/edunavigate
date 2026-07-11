import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/counselling_model.dart';

/// List-item card for a counselling programme — used across the home
/// dashboard rails, search results, and saved list.
class CounsellingCard extends StatelessWidget {
  const CounsellingCard({
    super.key,
    required this.program,
    this.isSaved = false,
    this.onTap,
    this.onSave,
  });

  final CounsellingProgram program;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSave;

  static const _months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final upcoming = program.nextUpcomingEvent;
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
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(program.category.icon, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(program.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(program.conductingBody,
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
                    tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppColors.accent : Colors.white54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                program.about,
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
                  StatChip(
                      icon: Icons.category_outlined,
                      label: program.category.label),
                  const SizedBox(width: 14),
                  if (upcoming != null)
                    StatChip(
                      icon: Icons.event_outlined,
                      label:
                          '${upcoming.label} • ${upcoming.date.day} ${_months[upcoming.date.month]}',
                      color: const Color(0xFFF59E0B),
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
