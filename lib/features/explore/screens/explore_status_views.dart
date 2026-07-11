import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';

/// Skeleton list shown while a live Places API request is in flight.
class ShimmerCardList extends StatelessWidget {
  const ShimmerCardList({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.06),
      highlightColor: Colors.white.withValues(alpha: 0.14),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

/// Full-bleed explanatory view used for permission-denied, GPS-disabled and
/// Places API failure states. Always gives the user a way forward instead of
/// silently swapping in sample data.
class ExploreMessageView extends StatelessWidget {
  const ExploreMessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white24, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 13, height: 1.5),
            ),
            if (primaryLabel != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onPrimary,
                  child: Text(primaryLabel!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel!,
                    style: const TextStyle(color: AppColors.accent)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
