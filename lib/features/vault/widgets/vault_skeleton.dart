import 'package:flutter/material.dart';

/// A gently pulsing placeholder block — used while documents/folders are
/// first loading, instead of a blank screen or "no data yet" text.
class VaultSkeleton extends StatefulWidget {
  const VaultSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<VaultSkeleton> createState() => _VaultSkeletonState();
}

class _VaultSkeletonState extends State<VaultSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.06 + (_controller.value * 0.07);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// Row of skeleton document cards for the horizontal rails.
class VaultDocumentRailSkeleton extends StatelessWidget {
  const VaultDocumentRailSkeleton({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) =>
            VaultSkeleton(width: 148, height: 128, borderRadius: 18),
      ),
    );
  }
}

/// Grid of skeleton folder cards.
class VaultFolderGridSkeleton extends StatelessWidget {
  const VaultFolderGridSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (_, __) =>
          VaultSkeleton(borderRadius: 20, height: double.infinity),
    );
  }
}
