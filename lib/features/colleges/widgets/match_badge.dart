import 'package:flutter/material.dart';

/// Small pill showing the AI match percentage, colour-coded by strength.
class MatchBadge extends StatelessWidget {
  const MatchBadge({super.key, required this.percent, this.compact = false});

  final double percent;
  final bool compact;

  Color get _color {
    if (percent >= 85) return const Color(0xFF22C55E);
    if (percent >= 65) return const Color(0xFFF59E0B);
    return const Color(0xFF94A3B8);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: compact ? 11 : 13, color: _color),
          const SizedBox(width: 4),
          Text(
            '${percent.round()}% Match',
            style: TextStyle(
              color: _color,
              fontSize: compact ? 10.5 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
