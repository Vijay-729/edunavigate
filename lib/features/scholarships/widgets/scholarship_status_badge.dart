import 'package:flutter/material.dart';

import '../models/scholarship.dart';

/// Colored "Applications Open / Closing Soon / Closed / Upcoming" badge —
/// shared by [ScholarshipCard] and the details page so the two never drift.
class ScholarshipStatusBadge extends StatelessWidget {
  const ScholarshipStatusBadge({super.key, required this.status});

  final ScholarshipStatus status;

  (String, Color) get _spec {
    switch (status) {
      case ScholarshipStatus.open:
        return ('Applications Open', const Color(0xFF22C55E));
      case ScholarshipStatus.closingSoon:
        return ('Closing Soon', const Color(0xFFF97316));
      case ScholarshipStatus.closed:
        return ('Closed', const Color(0xFF64748B));
      case ScholarshipStatus.upcoming:
        return ('Upcoming', const Color(0xFF3B82F6));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _spec;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// "🔥 Closing Soon" — spec: highlight scholarships whose deadline is within
/// the next 15 days, distinct from (and layered alongside) the status badge.
class ClosingSoonTag extends StatelessWidget {
  const ClosingSoonTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
      ),
      child: const Text(
        '🔥 Closing Soon',
        style: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 11,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}
