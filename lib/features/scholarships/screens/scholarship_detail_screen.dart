import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../explore/screens/place_card_widgets.dart'
    show EnrichedCardPhoto, InstitutionLogoAvatar, InstitutionGallerySection;
import '../data/bookmark_repository.dart';
import '../models/scholarship.dart';
import '../providers/scholarship_providers.dart';
import '../widgets/scholarship_status_badge.dart';

const _monthNames = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatDate(DateTime d) => '${d.day} ${_monthNames[d.month]} ${d.year}';

/// Full details page for a scholarship — spec: logo, banner, description,
/// benefits, amount, eligibility, income/category/state criteria, required
/// documents, selection process, application window, renewal rules,
/// official website, Apply Now, Share, Bookmark.
class ScholarshipDetailScreen extends ConsumerWidget {
  const ScholarshipDetailScreen({super.key, required this.scholarship});

  final Scholarship scholarship;

  Future<void> _apply(BuildContext context) async {
    final uri = Uri.tryParse(scholarship.applyUrl);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the apply link.')),
      );
    }
  }

  void _share() {
    ShareService.shareText(
      '${scholarship.title} — ${scholarship.organization}\n'
      '${scholarship.eligibility}\n'
      'Amount: ${scholarship.amount}\n'
      'Deadline: ${scholarship.deadline}\n\n'
      '${scholarship.applyUrl}',
      subject: scholarship.title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkIdsProvider).asData?.value ?? const {};
    final isBookmarked = bookmarks.contains(scholarship.id);

    return Scaffold(
      backgroundColor: AppColors.bgTop,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(gradient: AppColors.bgGradient)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          scholarship.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                        onPressed: () => ref
                            .read(bookmarkRepositoryProvider)
                            .toggle(scholarship.id, isBookmarked),
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color:
                              isBookmarked ? AppColors.accent : Colors.white70,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Share',
                        onPressed: _share,
                        icon: const Icon(Icons.share_outlined,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  EnrichedCardPhoto(
                                    wikidataId: null,
                                    wikipediaTitle: scholarship.wikipediaTitle,
                                    height: 150,
                                    icon: scholarship.icon,
                                  ),
                                  Positioned(
                                    left: 12,
                                    bottom: -20,
                                    child: InstitutionLogoAvatar(
                                      wikidataId: null,
                                      wikipediaTitle:
                                          scholarship.wikipediaTitle,
                                      fallbackIcon: scholarship.icon,
                                      size: 48,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Text(
                                scholarship.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                scholarship.organization,
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 13.5),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ScholarshipStatusBadge(
                                      status: scholarship.status),
                                  if (scholarship.isClosingSoon)
                                    const ClosingSoonTag(),
                                  _Chip(
                                    label: scholarship.providerLabel,
                                    color: scholarship.provider ==
                                            ScholarshipProvider.government
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFFF97316),
                                  ),
                                  _Chip(
                                      label: scholarship.scopeLabel,
                                      color: const Color(0xFF3B82F6)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (scholarship.description.isNotEmpty) ...[
                                const _SectionHeader(label: 'Description'),
                                const SizedBox(height: 10),
                                _Card(
                                  child: Text(
                                    scholarship.description,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13.5,
                                        height: 1.6),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              const _SectionHeader(label: 'Benefits'),
                              const SizedBox(height: 10),
                              _Card(
                                child: scholarship.benefits.isEmpty
                                    ? const Text('Information not available',
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: scholarship.benefits
                                            .map((b) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6),
                                                  child: Text('•  $b',
                                                      style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 13,
                                                          height: 1.5)),
                                                ))
                                            .toList(),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Eligibility'),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.payments_outlined,
                                label: 'Amount',
                                value: scholarship.amount,
                              ),
                              _InfoRow(
                                icon: Icons.fact_check_outlined,
                                label: 'Eligibility',
                                value: scholarship.eligibility,
                              ),
                              _InfoRow(
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'Income Criteria',
                                value: scholarship.maxFamilyIncome != null
                                    ? 'Family income up to '
                                        '₹${scholarship.maxFamilyIncome}/year'
                                    : 'Information not available',
                              ),
                              _InfoRow(
                                icon: Icons.percent_rounded,
                                label: 'Minimum Percentage',
                                value: scholarship.minPercentage != null
                                    ? '${scholarship.minPercentage}%'
                                    : 'Information not available',
                              ),
                              _InfoRow(
                                icon: Icons.groups_outlined,
                                label: 'Category Eligibility',
                                value: scholarship.categoryEligibility.isEmpty
                                    ? 'All categories'
                                    : scholarship.categoryEligibility
                                        .join(', '),
                              ),
                              _InfoRow(
                                icon: Icons.public_rounded,
                                label: 'State Eligibility',
                                value: scholarship.scopeLabel,
                              ),
                              const SizedBox(height: 12),
                              const _SectionHeader(label: 'Required Documents'),
                              const SizedBox(height: 10),
                              scholarship.requiredDocuments.isEmpty
                                  ? const _Card(
                                      child: Text('Information not available',
                                          style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 13)),
                                    )
                                  : Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: scholarship.requiredDocuments
                                          .map((d) => _Chip(
                                              label: d,
                                              color: const Color(0xFF8B5CF6)))
                                          .toList(),
                                    ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Selection Process'),
                              const SizedBox(height: 10),
                              _Card(
                                child: Text(
                                  scholarship.selectionProcess.isEmpty
                                      ? 'Information not available'
                                      : scholarship.selectionProcess,
                                  style: TextStyle(
                                      color:
                                          scholarship.selectionProcess.isEmpty
                                              ? Colors.white38
                                              : Colors.white70,
                                      fontSize: 13,
                                      height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Application Window'),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.event_available_outlined,
                                label: 'Start Date',
                                value: scholarship.applicationOpenDate != null
                                    ? _formatDate(
                                        scholarship.applicationOpenDate!)
                                    : 'Information not available',
                              ),
                              _InfoRow(
                                icon: Icons.event_busy_outlined,
                                label: 'Last Date',
                                value: scholarship.closeDateResolved != null
                                    ? _formatDate(
                                        scholarship.closeDateResolved!)
                                    : scholarship.deadline,
                              ),
                              const SizedBox(height: 12),
                              const _SectionHeader(label: 'Renewal Rules'),
                              const SizedBox(height: 10),
                              _Card(
                                child: Text(
                                  scholarship.renewalRules.isEmpty
                                      ? 'Information not available'
                                      : scholarship.renewalRules,
                                  style: TextStyle(
                                      color: scholarship.renewalRules.isEmpty
                                          ? Colors.white38
                                          : Colors.white70,
                                      fontSize: 13,
                                      height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Photos'),
                              const SizedBox(height: 10),
                              InstitutionGallerySection(
                                wikidataId: null,
                                wikipediaTitle: scholarship.wikipediaTitle,
                                icon: scholarship.icon,
                                name: scholarship.organization,
                              ),
                              const SizedBox(height: 24),
                              _InfoRow(
                                icon: Icons.language_outlined,
                                label: 'Official Website',
                                value: scholarship.applyUrl,
                                onTap: () =>
                                    _openUrl(context, scholarship.applyUrl),
                                isLink: true,
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  onPressed: () => _apply(context),
                                  icon: const Icon(Icons.open_in_new_rounded,
                                      color: Colors.white, size: 18),
                                  label: const Text(
                                    'Apply Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: child,
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
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.isLink = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white38, size: 16),
            const SizedBox(width: 8),
            SizedBox(
              width: 128,
              child: Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 12.5),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: isLink ? AppColors.accent : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: isLink ? TextDecoration.underline : null,
                  decorationColor: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
