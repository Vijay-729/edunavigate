import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Generic shimmering card placeholder shown while list data resolves —
/// shared by Counselling Guide, Exam Universe, Career Roadmap and Education
/// Loan list/search screens.
class ShimmerCardSkeleton extends StatelessWidget {
  const ShimmerCardSkeleton({super.key, this.height = 150});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF102846),
      highlightColor: const Color(0xFF1B3A63),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF102846),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 140, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 22, width: 100, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// A short run of skeleton cards.
class ShimmerListSkeleton extends StatelessWidget {
  const ShimmerListSkeleton({super.key, this.count = 4, this.cardHeight = 150});

  final int count;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 14),
          child: ShimmerCardSkeleton(height: cardHeight),
        ),
      ),
    );
  }
}
