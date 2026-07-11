import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholder matching [CollegeCard]'s shape, shown while stream
/// data or search results are resolving.
class CollegeCardSkeleton extends StatelessWidget {
  const CollegeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF102846),
      highlightColor: const Color(0xFF1B3A63),
      child: Container(
        height: 210,
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
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
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
            Container(height: 20, width: 180, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 22, width: 100, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// A short horizontal/vertical run of skeleton cards.
class CollegeListSkeleton extends StatelessWidget {
  const CollegeListSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 14),
          child: const CollegeCardSkeleton(),
        ),
      ),
    );
  }
}
