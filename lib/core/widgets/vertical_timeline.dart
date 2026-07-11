import 'package:flutter/material.dart';

/// One stage in a [VerticalTimeline] — used for counselling rounds, career
/// roadmaps, and skill-progression stages across the app.
class TimelineNode {
  final String title;
  final String subtitle;
  final IconData icon;

  /// Full explanation shown when the node is tapped (empty = not tappable).
  final String detail;

  const TimelineNode({
    required this.title,
    required this.subtitle,
    this.icon = Icons.flag_outlined,
    this.detail = '',
  });
}

/// Connected-dot vertical timeline with an optional tap-for-detail bottom
/// sheet on each node. Shared by Counselling Guide (registration → reporting)
/// and Career Roadmap (12th → leadership) so the interaction stays consistent.
class VerticalTimeline extends StatelessWidget {
  const VerticalTimeline({
    super.key,
    required this.nodes,
    this.accentColor = const Color(0xFF3B82F6),
  });

  final List<TimelineNode> nodes;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(nodes.length, (i) {
        final node = nodes[i];
        final isLast = i == nodes.length - 1;
        final tappable = node.detail.isNotEmpty;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: accentColor.withValues(alpha: 0.5),
                          width: 1.5),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                          color: accentColor, fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: accentColor.withValues(alpha: 0.25),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 4 : 22, top: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: tappable
                          ? () => _showDetail(context, node, accentColor)
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    node.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    node.subtitle,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.55),
                                      fontSize: 12.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (tappable)
                              Icon(Icons.chevron_right,
                                  color: Colors.white.withValues(alpha: 0.35)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showDetail(BuildContext context, TimelineNode node, Color accent) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D2040),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Row(
              children: [
                Icon(node.icon, color: accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    node.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              node.detail,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
