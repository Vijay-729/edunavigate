import 'package:flutter/material.dart';

/// Animated labeled score bar used on the assessment result screen.
class ScoreBar extends StatefulWidget {
  const ScoreBar({
    super.key,
    required this.label,
    required this.percentage, // 0..1
    required this.color,
  });

  final String label;
  final double percentage;
  final Color color;

  @override
  State<ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.percentage.clamp(0.0, 1.0) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                color: widget.color,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _animation.value,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              ),
            );
          },
        ),
      ],
    );
  }
}
