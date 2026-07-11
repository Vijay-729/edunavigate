import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen brand gradient wrapper used by all screens.
///
/// Set [extendBehindAppBar] to `true` on screens that use
/// `Scaffold(extendBodyBehindAppBar: true)` — the body will then receive
/// an extra [kToolbarHeight] top padding so content clears the floating
/// transparent AppBar while the gradient still paints behind it.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.extendBehindAppBar = false,
  });

  final Widget child;

  /// When true, wraps content in padding equal to [kToolbarHeight] so it
  /// starts below the floating AppBar. SafeArea still handles the status bar.
  final bool extendBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        child: extendBehindAppBar
            ? Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: child,
              )
            : child,
      ),
    );
  }
}
