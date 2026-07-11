import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../explore/screens/place_card_widgets.dart'
    show EnrichedCardPhoto, InstitutionLogoAvatar;
import '../models/scholarship.dart';
import 'scholarship_status_badge.dart';

class ScholarshipCard extends StatelessWidget {
  const ScholarshipCard({
    super.key,
    required this.scholarship,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    this.isRecommended = false,
  });

  final Scholarship scholarship;
  final bool isBookmarked;
  final bool isRecommended;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final isGov = scholarship.provider == ScholarshipProvider.government;
    final accent = isGov ? const Color(0xFF22C55E) : const Color(0xFFF97316);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  EnrichedCardPhoto(
                    wikidataId: null,
                    wikipediaTitle: scholarship.wikipediaTitle,
                    height: 84,
                    icon: scholarship.icon,
                  ),
                  Positioned(
                    left: 12,
                    bottom: -18,
                    child: InstitutionLogoAvatar(
                      wikidataId: null,
                      wikipediaTitle: scholarship.wikipediaTitle,
                      fallbackIcon: scholarship.icon,
                      size: 40,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scholarship.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                scholarship.organization,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onShare,
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.share_outlined,
                              color: Colors.white54, size: 20),
                        ),
                        IconButton(
                          onPressed: onBookmark,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? AppColors.accent
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (isRecommended)
                          const _Chip(
                              label: '⭐ Recommended', color: Color(0xFFEAB308)),
                        ScholarshipStatusBadge(status: scholarship.status),
                        if (scholarship.isClosingSoon) const ClosingSoonTag(),
                        _Chip(label: scholarship.providerLabel, color: accent),
                        _Chip(
                          label: scholarship.scopeLabel,
                          color: const Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined,
                            color: Colors.white54, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            scholarship.amount,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.event_outlined,
                            color: Colors.white54, size: 16),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            scholarship.deadline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
