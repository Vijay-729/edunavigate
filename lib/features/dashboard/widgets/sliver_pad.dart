import 'package:flutter/material.dart';

/// Wraps a box widget in horizontal-padded sliver adapter. Keeps dashboard
/// section spacing consistent without repeating SliverPadding boilerplate.
class SliverPad extends StatelessWidget {
  const SliverPad({
    super.key,
    required this.child,
    this.top = 0,
    this.bottom = 0,
    this.horizontal = 20,
  });

  final Widget child;
  final double top;
  final double bottom;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
