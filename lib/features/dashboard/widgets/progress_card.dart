import 'package:flutter/material.dart';

/// Displays a titled metric with an animated linear progress bar and a
/// percentage readout. Used for tracking completion of boards, exam
/// prep, applications, skills, etc.
class ProgressCard extends StatefulWidget {
  final String title;
  final double percentage; // 0.0 - 1.0
  final Color color;
  final String? trailingLabel;

  const ProgressCard({
    super.key,
    required this.title,
    required this.percentage,
    this.color = const Color(0xFF3B82F6),
    this.trailingLabel,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                widget.trailingLabel ?? '$pct%',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
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
      ),
    );
  }
}
