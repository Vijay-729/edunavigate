import 'package:flutter/material.dart';

import '../models/stream_exam.dart';

class ExamLinkTile extends StatelessWidget {
  const ExamLinkTile(
      {super.key,
      required this.exam,
      required this.accent,
      required this.onTap});

  final StreamExam exam;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.edit_document, color: accent, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(exam.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

class StreamSectionHeader extends StatelessWidget {
  const StreamSectionHeader({super.key, required this.title, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white70, size: 17),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class StreamInfoCard extends StatelessWidget {
  const StreamInfoCard({super.key, required this.child, this.accent});
  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (accent ?? Colors.white)
              .withValues(alpha: accent != null ? 0.25 : 0.09),
        ),
      ),
      child: child,
    );
  }
}

class StreamChipList extends StatelessWidget {
  const StreamChipList({super.key, required this.items, required this.color});
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                s,
                style: TextStyle(
                    color: color, fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
    );
  }
}

class StreamBulletList extends StatelessWidget {
  const StreamBulletList(
      {super.key,
      required this.items,
      required this.color,
      this.icon = Icons.check_circle_rounded});
  final List<String> items;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13.5, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class StreamKeyValueRow extends StatelessWidget {
  const StreamKeyValueRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? Colors.white54, size: 19),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
