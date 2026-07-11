import 'package:flutter/material.dart';

/// Displays a roadmap's title, current completion status (as a chip),
/// and the immediate next milestone the student should focus on.
class RoadmapCard extends StatelessWidget {
  final String roadmapTitle;
  final String completionStatus; // e.g. "32% Complete", "Not Started"
  final String nextMilestone;
  final Color accentColor;
  final IconData icon;
  final VoidCallback? onTap;

  const RoadmapCard({
    super.key,
    required this.roadmapTitle,
    required this.completionStatus,
    required this.nextMilestone,
    this.accentColor = const Color(0xFF3B82F6),
    this.icon = Icons.map_outlined,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accentColor.withValues(alpha: 0.2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            roadmapTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            completionStatus,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Next: $nextMilestone',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
