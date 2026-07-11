import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/career_resource.dart';

/// Glassmorphic card for one [ResourceItem]. Tapping opens the external link.
class ResourceCard extends StatelessWidget {
  const ResourceCard({
    super.key,
    required this.item,
    required this.accent,
    required this.onTap,
  });

  final ResourceItem item;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accent.withValues(alpha: 0.18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (item.icon != null) ...[
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: 0.16),
                        border:
                            Border.all(color: accent.withValues(alpha: 0.35)),
                      ),
                      child: Icon(item.icon, size: 17, color: accent),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _TagPill(label: item.tag, accent: accent),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
              if (item.eligibility != null) ...[
                const SizedBox(height: 8),
                _InfoLine(
                    icon: Icons.checklist_rtl,
                    label: 'Eligibility',
                    value: item.eligibility!,
                    accent: accent),
              ],
              if (item.prepTimeline != null) ...[
                const SizedBox(height: 6),
                _InfoLine(
                    icon: Icons.schedule,
                    label: 'Prep timeline',
                    value: item.prepTimeline!,
                    accent: accent),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.public, size: 15, color: accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.source,
                      style: TextStyle(
                        color: accent,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.open_in_new,
                      size: 16, color: AppColors.textMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: accent),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                      color: accent, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accent,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
