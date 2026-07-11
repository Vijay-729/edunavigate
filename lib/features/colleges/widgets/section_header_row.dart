import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Section title with an optional trailing "See all" action — used for the
/// Trending/Top Government/Top Private/Recommended rails on the explorer home.
class SectionHeaderRow extends StatelessWidget {
  const SectionHeaderRow({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12.5),
                ),
              ],
            ],
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            child: const Text('See all'),
          ),
      ],
    );
  }
}
