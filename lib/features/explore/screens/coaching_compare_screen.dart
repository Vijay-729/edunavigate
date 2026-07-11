import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/coaching_providers_data.dart';
import '../models/coaching_provider.dart';
import '../providers/explore_providers.dart';
import 'explore_status_views.dart';
import 'place_card_widgets.dart';

/// Side-by-side comparison of up to 4 coaching providers — same
/// row-labels-then-scrollable-columns layout as College Explorer's
/// [CollegeCompareScreen], adapted to [CoachingProvider]'s fields (spec:
/// fee structure, courses offered, scholarship, online/offline, hostel,
/// test series, doubt support, duration, rating, official website).
class CoachingCompareScreen extends ConsumerWidget {
  const CoachingCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(compareCoachingListProvider);
    final providers = ids
        .map((id) => CoachingProviders.byId[id])
        .whereType<CoachingProvider>()
        .toList();

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
                      const Expanded(
                        child: Text(
                          'Compare Coachings',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (providers.isNotEmpty)
                        TextButton(
                          onPressed: () => ref
                              .read(compareCoachingListProvider.notifier)
                              .clear(),
                          child: const Text('Clear all',
                              style: TextStyle(color: AppColors.accent)),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: providers.isEmpty
                      ? const ExploreMessageView(
                          icon: Icons.compare_arrows_rounded,
                          title: 'Nothing to compare yet',
                          message: 'Add up to 4 coaching institutes from Top '
                              'Coaching Institutes using the "Compare" '
                              'button on each card.',
                        )
                      // Two orthogonal SingleChildScrollViews so the table
                      // scrolls both ways: the inner (horizontal) one lets
                      // more coaching columns scroll sideways, the outer
                      // (vertical) one gives it an unbounded height so the
                      // 10-row table never overflows on shorter screens —
                      // without it, the Row's natural height (~800px) is
                      // forced into whatever's left under the AppBar and
                      // clips with a RenderFlex overflow.
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _RowLabels(),
                                ...providers.map((p) => _CoachingColumn(
                                      provider: p,
                                      onRemove: () => ref
                                          .read(compareCoachingListProvider
                                              .notifier)
                                          .toggle(p.id),
                                    )),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _rowLabels = [
  'Courses Offered',
  'Fee Structure',
  'Scholarship',
  'Mode',
  'Hostel',
  'Test Series',
  'Doubt Support',
  'Duration',
  'Rating',
  'Official Website',
];

class _RowLabels extends StatelessWidget {
  const _RowLabels();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _rowLabels
            .map((l) => Container(
                  width: 100,
                  height: 64,
                  alignment: Alignment.centerLeft,
                  child: Text(l,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ))
            .toList(),
      ),
    );
  }
}

class _CoachingColumn extends StatelessWidget {
  const _CoachingColumn({required this.provider, required this.onRemove});

  final CoachingProvider provider;
  final VoidCallback onRemove;

  String get _mode {
    if (provider.offersOnline && provider.offersOffline) {
      return 'Online + Offline';
    }
    if (provider.offersOnline) return 'Online only';
    if (provider.offersOffline) return 'Offline only';
    return 'Information not available';
  }

  String get _websiteDomain {
    try {
      final host = Uri.parse(provider.website).host;
      return host.isEmpty ? provider.website : host.replaceFirst('www.', '');
    } catch (_) {
      return provider.website;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InstitutionLogoAvatar(
                  wikidataId: null,
                  wikipediaTitle: provider.wikipediaTitle,
                  fallbackIcon: provider.icon,
                  size: 38,
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 16, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: Text(
              provider.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3),
            ),
          ),
          _cell(provider.coursesOffered.join(', '), maxLines: 3),
          _cell(
            provider.feeStructure.isEmpty
                ? 'Information not available'
                : provider.feeStructure.first +
                    (provider.feeStructure.length > 1
                        ? ' (+${provider.feeStructure.length - 1} more)'
                        : ''),
            maxLines: 3,
          ),
          _cell(
            provider.scholarshipInfo.isEmpty ? 'No' : 'Yes',
            color: provider.scholarshipInfo.isEmpty
                ? Colors.white38
                : const Color(0xFF22C55E),
          ),
          _cell(_mode),
          _cell(provider.hasHostel ? 'Yes' : 'No',
              color: provider.hasHostel
                  ? const Color(0xFF22C55E)
                  : Colors.white38),
          _cell(provider.hasTestSeries ? 'Yes' : 'No',
              color: provider.hasTestSeries
                  ? const Color(0xFF22C55E)
                  : Colors.white38),
          _cell(provider.hasDoubtSupport ? 'Yes' : 'No',
              color: provider.hasDoubtSupport
                  ? const Color(0xFF22C55E)
                  : Colors.white38),
          _cell(provider.duration, maxLines: 3),
          _cell('★ ${provider.rating.toStringAsFixed(1)}',
              color: const Color(0xFFEAB308)),
          _cell(_websiteDomain),
        ],
      ),
    );
  }

  Widget _cell(String text, {Color color = Colors.white, int maxLines = 2}) {
    return Container(
      height: 64,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            height: 1.25),
      ),
    );
  }
}
