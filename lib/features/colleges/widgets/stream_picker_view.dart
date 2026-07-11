import 'package:flutter/material.dart';

import '../models/student_stream.dart';

/// Shown whenever the active stream can't be inferred from the student's
/// profile — lets them pick one explicitly so College Explorer/Predictor
/// still only ever show stream-relevant colleges.
class StreamPickerView extends StatelessWidget {
  const StreamPickerView({
    super.key,
    required this.onPicked,
    this.title = 'Which stream are you in?',
    this.message = 'This decides which colleges and courses we show you.',
  });

  final ValueChanged<StudentStream> onPicked;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 13.5),
          ),
          const SizedBox(height: 20),
          ...StudentStream.values.map(
            (stream) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onPicked(stream),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF102846),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                LinearGradient(colors: stream.gradientColors),
                          ),
                          child:
                              Icon(stream.icon, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stream.label,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(stream.tagline,
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.55),
                                      fontSize: 12.5)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white38),
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
  }
}
