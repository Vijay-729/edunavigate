import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../colleges/providers/college_providers.dart';
import '../data/coaching_providers_data.dart';
import '../data/explore_bookmarks_repository.dart';
import '../models/coaching_provider.dart';
import '../providers/explore_providers.dart';
import 'coaching_compare_screen.dart';
import 'coaching_detail_screen.dart';
import 'explore_status_views.dart';
import 'location_selection_sheet.dart';
import 'place_card_widgets.dart';

/// "Top Coaching Institutes" — a curated, stream-aware list of well-known
/// coaching providers (NOT a live OpenStreetMap search: OSM's coverage of
/// coaching centres is too sparse/inconsistent to search reliably). Live
/// location is only used later, on demand, via "Find Nearest Branch" on the
/// detail screen.
class NearbyCoachingsScreen extends ConsumerStatefulWidget {
  const NearbyCoachingsScreen({super.key});

  @override
  ConsumerState<NearbyCoachingsScreen> createState() =>
      _NearbyCoachingsScreenState();
}

class _NearbyCoachingsScreenState extends ConsumerState<NearbyCoachingsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _savedOnly = false;
  Set<String> _savedIds = {};

  @override
  void initState() {
    super.initState();
    _loadSaved();
    _ensureLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _query = '';
      _savedOnly = false;
    });
    _searchController.clear();
  }

  Future<void> _loadSaved() async {
    final ids = await ExploreBookmarksRepository.instance.savedCoachingIds();
    if (mounted) setState(() => _savedIds = ids);
  }

  /// Shared location system (spec: one common location service for Nearby
  /// Colleges/Schools/Coaching Explorer) — on first visit anywhere across
  /// the three screens shows [LocationSelectionSheet]; here it just makes
  /// sure a location is on record so "Find Nearest Branch" never needs a
  /// fresh GPS permission prompt on every tap.
  Future<void> _ensureLocation() async {
    final notifier = ref.read(selectedLocationProvider.notifier);
    await notifier.ensureInitialized();
    if (!mounted) return;
    if (ref.read(selectedLocationProvider) == null) {
      await showLocationSelectionSheet(context, ref);
    }
  }

  Future<void> _changeLocation() async {
    await showLocationSelectionSheet(context, ref);
  }

  Future<void> _toggleSaved(String id) async {
    final nowSaved =
        await ExploreBookmarksRepository.instance.toggleCoaching(id);
    if (!mounted) return;
    setState(() {
      if (nowSaved) {
        _savedIds.add(id);
      } else {
        _savedIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stream = ref.watch(activeStreamProvider);
    final all = CoachingProviders.forStream(stream);
    final recommended = CoachingProviders.recommendedForStream(stream);
    final compareIds = ref.watch(compareCoachingListProvider);

    var visible = all;
    if (_savedOnly) {
      visible = visible.where((p) => _savedIds.contains(p.id)).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      visible = visible.where((p) => p.name.toLowerCase().contains(q)).toList();
    }

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Top Coaching Institutes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            Consumer(builder: (context, ref, _) {
                              final location =
                                  ref.watch(selectedLocationProvider);
                              if (location == null) {
                                return const SizedBox.shrink();
                              }
                              return Row(
                                children: [
                                  const Icon(Icons.my_location_rounded,
                                      color: Colors.white38, size: 11),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      'Near ${location.label}',
                                      style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_location_alt_outlined,
                            color: Colors.white70),
                        tooltip: 'Change Location',
                        onPressed: _changeLocation,
                      ),
                      Consumer(builder: (context, ref, _) {
                        final compareCount =
                            ref.watch(compareCoachingListProvider).length;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.compare_arrows_rounded,
                                  color: Colors.white70),
                              tooltip: 'Compare coachings',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const CoachingCompareScreen(),
                                ),
                              ),
                            ),
                            if (compareCount > 0)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle),
                                  constraints: const BoxConstraints(
                                      minWidth: 16, minHeight: 16),
                                  child: Text('$compareCount',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search institutes by name…',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Colors.white38, size: 20),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: !_savedOnly,
                        onTap: () => setState(() => _savedOnly = false),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '★ Saved',
                        selected: _savedOnly,
                        onTap: () => setState(() => _savedOnly = true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: visible.isEmpty
                      ? ExploreMessageView(
                          icon: _savedOnly
                              ? Icons.bookmark_border_rounded
                              : Icons.search_off_rounded,
                          title: _savedOnly
                              ? 'No saved institutes yet'
                              : 'No institutes found',
                          message: _savedOnly
                              ? 'Tap the bookmark icon on any institute to save it here.'
                              : 'Try a different search term.',
                          primaryLabel: (_savedOnly || _query.trim().isNotEmpty)
                              ? 'Clear Filters'
                              : null,
                          onPrimary: (_savedOnly || _query.trim().isNotEmpty)
                              ? _clearFilters
                              : null,
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            if (!_savedOnly &&
                                _query.trim().isEmpty &&
                                recommended.isNotEmpty) ...[
                              const Text(
                                'Recommended for You',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                              ...recommended.map((p) => _CoachingCard(
                                    provider: p,
                                    isRecommended: true,
                                    isSaved: _savedIds.contains(p.id),
                                    isComparing: compareIds.contains(p.id),
                                    onToggleSaved: () => _toggleSaved(p.id),
                                    onCompareToggle: () => _toggleCompare(p.id),
                                    onTap: () => _openDetail(p),
                                  )),
                              const SizedBox(height: 20),
                              const Text(
                                'All Institutes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                            ],
                            ...visible.map((p) => _CoachingCard(
                                  provider: p,
                                  isRecommended: false,
                                  isSaved: _savedIds.contains(p.id),
                                  isComparing: compareIds.contains(p.id),
                                  onToggleSaved: () => _toggleSaved(p.id),
                                  onCompareToggle: () => _toggleCompare(p.id),
                                  onTap: () => _openDetail(p),
                                )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: compareIds.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const CoachingCompareScreen(),
                ),
              ),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.compare_arrows_rounded),
              label: Text('Compare (${compareIds.length})'),
            )
          : null,
    );
  }

  void _toggleCompare(String id) {
    final ok = ref.read(compareCoachingListProvider.notifier).toggle(id);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You can compare up to 4 coaching institutes.')),
      );
    }
  }

  void _openDetail(CoachingProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CoachingDetailScreen(provider: provider),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: selected ? AppColors.primary : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white54,
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _CoachingCard extends StatelessWidget {
  const _CoachingCard({
    required this.provider,
    required this.isRecommended,
    required this.isSaved,
    this.isComparing = false,
    required this.onToggleSaved,
    this.onCompareToggle,
    required this.onTap,
  });

  final CoachingProvider provider;
  final bool isRecommended;
  final bool isSaved;
  final bool isComparing;
  final VoidCallback onToggleSaved;
  final VoidCallback? onCompareToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EnrichedCardPhoto(
              wikidataId: null,
              wikipediaTitle: provider.wikipediaTitle,
              height: 110,
              icon: provider.icon,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InstitutionLogoAvatar(
                        wikidataId: null,
                        wikipediaTitle: provider.wikipediaTitle,
                        fallbackIcon: provider.icon,
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFEAB308), size: 14),
                                const SizedBox(width: 2),
                                Text(provider.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                        color: Color(0xFFEAB308),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                if (isRecommended) ...[
                                  const SizedBox(width: 6),
                                  const Text('· Recommended',
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 11)),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onToggleSaved,
                        tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved ? AppColors.accent : Colors.white38,
                          size: 22,
                        ),
                        splashRadius: 20,
                      ),
                      IconButton(
                        onPressed: () => _shareProvider(provider),
                        tooltip: 'Share',
                        icon: const Icon(Icons.share_outlined,
                            color: Colors.white38, size: 20),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRecommended
                        ? provider.recommendationReason
                        : provider.about,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 12.5, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee_rounded,
                          color: Colors.white38, size: 13),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          'Starting Fee: ${provider.startingFeeLabel}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: provider.popularExams
                        .map((exam) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: const Color(0xFF8B5CF6)
                                        .withValues(alpha: 0.25)),
                              ),
                              child: Text(
                                exam,
                                style: const TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                        .toList(),
                  ),
                  if (onCompareToggle != null) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onCompareToggle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isComparing
                                ? AppColors.primary.withValues(alpha: 0.25)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isComparing
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isComparing
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 13,
                                color: isComparing
                                    ? AppColors.accent
                                    : Colors.white60,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Compare',
                                style: TextStyle(
                                  color: isComparing
                                      ? AppColors.accent
                                      : Colors.white60,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One-tap "Share" quick action for a coaching card — the detail screen has
/// its own richer `_share()`, this is the same idea from the list directly.
void _shareProvider(CoachingProvider provider) {
  ShareService.shareText(
    '${provider.name} — ${provider.about}\n\n${provider.website}',
    subject: provider.name,
  );
}
