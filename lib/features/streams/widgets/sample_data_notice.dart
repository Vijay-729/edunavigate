import 'package:flutter/material.dart';

/// Small, unmissable-but-unobtrusive notice shown near numeric figures
/// (fees, salaries, cutoffs, rankings) that are realistic estimates rather
/// than live, verified data — so students know to double-check specifics
/// before making decisions.
class SampleDataNotice extends StatelessWidget {
  const SampleDataNotice(
      {super.key,
      this.label = 'Sample figures — verify current numbers before deciding'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAB308).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color(0xFFEAB308).withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 13, color: Color(0xFFEAB308)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFEAB308),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
