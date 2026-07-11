import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';

/// Premium placeholder for dashboard features that are architecture-ready but
/// not yet implemented in the current MVP (spec: "future modules must remain
/// architecture ready"). Pushed via [openFeatureComingSoon].
class FeatureComingSoonScreen extends StatelessWidget {
  const FeatureComingSoonScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.accent = AppColors.primary,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.15),
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Icon(icon, color: accent, size: 54),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Coming soon',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience to push the coming-soon screen for a dashboard feature.
void openFeatureComingSoon(
  BuildContext context, {
  required String title,
  required String description,
  required IconData icon,
  Color accent = AppColors.primary,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => FeatureComingSoonScreen(
        title: title,
        description: description,
        icon: icon,
        accent: accent,
      ),
    ),
  );
}
