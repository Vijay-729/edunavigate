import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/saved_college_repository.dart';
import '../models/college_model.dart';
import '../providers/college_providers.dart';
import '../utils/college_formatters.dart';
import '../widgets/college_visuals.dart';
import '../widgets/stat_chip.dart';

/// Full college profile — overview, courses, cutoffs, fees, placements,
/// facilities, reviews and FAQs, all on one scrollable page.
class CollegeDetailsScreen extends ConsumerStatefulWidget {
  const CollegeDetailsScreen({super.key, required this.collegeId});

  final String collegeId;

  @override
  ConsumerState<CollegeDetailsScreen> createState() =>
      _CollegeDetailsScreenState();
}

class _CollegeDetailsScreenState extends ConsumerState<CollegeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savedCollegeRepositoryProvider).recordView(widget.collegeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final college = ref.watch(collegeByIdProvider(widget.collegeId));
    final savedIds =
        ref.watch(savedCollegeIdsProvider).asData?.value ?? const {};

    if (college == null) {
      return const Scaffold(
          body: Center(
              child: Text('College not found',
                  style: TextStyle(color: Colors.white))));
    }

    final isSaved = savedIds.contains(college.id);
    final accent = collegeAccentColor(college.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(college.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.accent : Colors.white),
            onPressed: () => ref
                .read(savedCollegeRepositoryProvider)
                .toggleSaved(college.id, isSaved),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _HeaderCard(college: college, accent: accent),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'About',
              icon: Icons.info_outline,
              child: Text(college.about, style: _bodyStyle),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Courses Offered',
              icon: Icons.menu_book_outlined,
              child: Column(
                children: college.courses
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.chevron_right,
                                  color: AppColors.accent, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.5)),
                                    const SizedBox(height: 2),
                                    Text(
                                        '${c.durationYears} years • ${c.eligibility}',
                                        style: _mutedStyle),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Admission Process & Entrance Exams',
              icon: Icons.assignment_turned_in_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(college.admissionProcess, style: _bodyStyle),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: college.courses
                        .expand((c) => c.examIds)
                        .toSet()
                        .map((id) =>
                            _pill(id.toUpperCase().replaceAll('_', ' ')))
                        .toList(),
                  ),
                ],
              ),
            ),
            if (college.cutoffs.isNotEmpty) ...[
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Cutoff (Previous Year)',
                icon: Icons.trending_down_outlined,
                child: Column(
                  children: college.cutoffs
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${c.category.toUpperCase()}${c.homeStateQuota ? ' • Home State' : ''}',
                                    style: _mutedStyle,
                                  ),
                                ),
                                Text(
                                  c.closingRank != null
                                      ? 'Rank ${CollegeFormatters.rank(c.closingRank)}'
                                      : 'Score ${c.closingScore}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Fees & Scholarships',
              icon: Icons.currency_rupee,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('Tuition Fee',
                      '${CollegeFormatters.rupeesShort(college.fees.tuitionPerYear)}/year'),
                  _kv(
                      'Hostel Fee',
                      college.fees.hostelPerYear > 0
                          ? '${CollegeFormatters.rupeesShort(college.fees.hostelPerYear)}/year'
                          : 'No hostel fee data'),
                  if (college.scholarshipsAvailable) ...[
                    const SizedBox(height: 8),
                    Text(college.scholarshipInfo, style: _mutedStyle),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Placement Statistics',
              icon: Icons.trending_up_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv(
                      'Average Package',
                      CollegeFormatters.lpa(
                          college.placement.averagePackageLpa)),
                  _kv(
                      'Highest Package',
                      CollegeFormatters.lpa(
                          college.placement.highestPackageLpa)),
                  if (college.placement.placementPercentage > 0)
                    _kv('Placement Rate',
                        '${college.placement.placementPercentage.round()}%'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        college.placement.topRecruiters.map(_pill).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Faculty',
              icon: Icons.groups_2_outlined,
              child: Text(college.facultyInfo, style: _bodyStyle),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Campus Facilities',
              icon: Icons.apartment_outlined,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    college.facilities.map((f) => _pill(f.label)).toList(),
              ),
            ),
            if (college.reviews.isNotEmpty) ...[
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Reviews',
                icon: Icons.star_outline,
                child: Column(
                  children: college.reviews
                      .map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(r.author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13)),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.star,
                                        size: 14, color: Colors.amber.shade400),
                                    Text(' ${r.rating}',
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12.5)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(r.comment, style: _mutedStyle),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
            if (college.faqs.isNotEmpty) ...[
              const SizedBox(height: 14),
              _SectionCard(
                title: 'FAQs',
                icon: Icons.help_outline,
                child: Column(
                  children: college.faqs
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.question,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(f.answer, style: _mutedStyle),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Contact & Location',
              icon: Icons.map_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('City / State', '${college.city}, ${college.state}'),
                  if (college.contactPhone.isNotEmpty)
                    _kv('Phone', college.contactPhone),
                  if (college.contactEmail.isNotEmpty)
                    _kv('Email', college.contactEmail),
                  const SizedBox(height: 12),
                  if (college.website.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => _openLink(context, college.website),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Visit Official Website'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _bodyStyle =
      TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5);
  static const _mutedStyle =
      TextStyle(color: Colors.white54, fontSize: 12.5, height: 1.4);

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(child: Text(k, style: _mutedStyle)),
            Text(v,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5)),
          ],
        ),
      );

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 11.5,
                fontWeight: FontWeight.w600)),
      );

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')));
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.college, required this.accent});

  final CollegeModel college;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.4)),
                ),
                child: Text(college.logoInitials,
                    style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(college.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.2)),
                    const SizedBox(height: 4),
                    Text('${college.city}, ${college.state}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (college.nirfRank != null)
                StatChip(
                    icon: Icons.emoji_events_outlined,
                    label: 'NIRF #${college.nirfRank}',
                    color: Colors.amber.shade400),
              StatChip(
                  icon: Icons.account_balance_outlined,
                  label: college.type.label,
                  color: accent),
              if (college.naacGrade != null)
                StatChip(
                    icon: Icons.verified_outlined,
                    label: 'NAAC ${college.naacGrade}',
                    color: const Color(0xFF22C55E)),
              if (college.establishedYear != null)
                StatChip(
                    icon: Icons.calendar_today_outlined,
                    label: 'Est. ${college.establishedYear}'),
              StatChip(
                  icon: Icons.star_rounded,
                  label: college.averageRating.toStringAsFixed(1),
                  color: Colors.amber.shade400),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard(
      {required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
