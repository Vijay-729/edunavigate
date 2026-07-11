import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../colleges/models/student_stream.dart';
import '../data/explore_bookmarks_repository.dart';
import '../models/coaching_provider.dart';
import '../providers/explore_providers.dart';
import '../services/nearby_places_service.dart';
import 'place_card_widgets.dart';

class CoachingDetailScreen extends ConsumerStatefulWidget {
  const CoachingDetailScreen({super.key, required this.provider});

  final CoachingProvider provider;

  @override
  ConsumerState<CoachingDetailScreen> createState() =>
      _CoachingDetailScreenState();
}

class _CoachingDetailScreenState extends ConsumerState<CoachingDetailScreen> {
  bool _isSaved = false;
  bool _findingBranch = false;

  @override
  void initState() {
    super.initState();
    ExploreBookmarksRepository.instance.savedCoachingIds().then((ids) {
      if (mounted) setState(() => _isSaved = ids.contains(widget.provider.id));
    });
  }

  Future<void> _toggleSaved() async {
    final nowSaved = await ExploreBookmarksRepository.instance
        .toggleCoaching(widget.provider.id);
    if (mounted) setState(() => _isSaved = nowSaved);
  }

  Future<void> _visitWebsite() async {
    final uri = Uri.parse(widget.provider.website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _email(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _share() {
    ShareService.shareText(
      '${widget.provider.name} — ${widget.provider.about}\n\n'
      '${widget.provider.website}',
      subject: widget.provider.name,
    );
  }

  /// Uses the shared, already-selected location (spec: "one common location
  /// service" for Nearby Colleges/Schools/Coaching Explorer) so this never
  /// needs a fresh GPS permission prompt on every tap; falls back to a live
  /// Geolocator + Nominatim reverse-geocode only if no location has been
  /// selected yet. Opens a Google Maps search for "`Institute City`" — a
  /// plain web-search URL, not the billed Places API, so it needs no key.
  Future<void> _findNearestBranch() async {
    setState(() => _findingBranch = true);
    try {
      String? city = ref.read(selectedLocationProvider)?.city;
      if (city == null) {
        final position = await NearbyPlacesService.getCurrentLocation();
        city = await NearbyPlacesService.currentCity(
            position.latitude, position.longitude);
      }
      final query =
          city == null ? widget.provider.name : '${widget.provider.name} $city';
      final uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on AppLocationServiceDisabledException {
      _showSnack('Turn on location services to find the nearest branch.');
    } on LocationPermissionDeniedException {
      _showSnack('Location permission is needed to find the nearest branch.');
    } on LocationPermissionDeniedForeverException {
      _showSnack(
          'Location permission is blocked. Enable it in Settings to find the nearest branch.');
    } on NoInternetException {
      _showSnack('No internet connection. Check your network and try again.');
    } catch (_) {
      _showSnack('Could not detect your location. Please try again.');
    } finally {
      if (mounted) setState(() => _findingBranch = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
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
                          provider.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSaved,
                        tooltip: _isSaved ? 'Remove bookmark' : 'Bookmark',
                        icon: Icon(
                          _isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: _isSaved ? AppColors.accent : Colors.white70,
                        ),
                      ),
                      IconButton(
                        onPressed: _share,
                        tooltip: 'Share',
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
                              EnrichedCardPhoto(
                                wikidataId: null,
                                wikipediaTitle: provider.wikipediaTitle,
                                height: 150,
                                icon: provider.icon,
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Photos'),
                              const SizedBox(height: 10),
                              InstitutionGallerySection(
                                wikidataId: null,
                                wikipediaTitle: provider.wikipediaTitle,
                                icon: provider.icon,
                                name: provider.name,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  InstitutionLogoAvatar(
                                    wikidataId: null,
                                    wikipediaTitle: provider.wikipediaTitle,
                                    fallbackIcon: provider.icon,
                                    size: 64,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded,
                                                color: Color(0xFFEAB308),
                                                size: 16),
                                            const SizedBox(width: 3),
                                            Text(
                                              provider.rating
                                                  .toStringAsFixed(1),
                                              style: const TextStyle(
                                                  color: Color(0xFFEAB308),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'About Institute'),
                              const SizedBox(height: 10),
                              _Card(
                                child: Text(
                                  provider.about,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.5,
                                      height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Courses Offered'),
                              const SizedBox(height: 10),
                              _ChipWrap(items: provider.coursesOffered),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Popular Exams'),
                              const SizedBox(height: 10),
                              _ChipWrap(
                                items: provider.popularExams,
                                color: const Color(0xFF8B5CF6),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Supported Streams'),
                              const SizedBox(height: 10),
                              _ChipWrap(
                                items: provider.supportedStreams
                                    .map((s) => s.label)
                                    .toList(),
                                color: const Color(0xFF22C55E),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Fee Structure'),
                              const SizedBox(height: 10),
                              _Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (provider.feeStructure.isEmpty)
                                      const Text('Information not available',
                                          style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 13))
                                    else
                                      ...provider.feeStructure.map(
                                        (line) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Text('•  $line',
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                  height: 1.5)),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Indicative only — confirm exact fees '
                                      'on the official website or at your '
                                      'nearest branch.',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(
                                  label: 'Scholarship Information'),
                              const SizedBox(height: 10),
                              _Card(
                                child: Text(
                                  provider.scholarshipInfo.isEmpty
                                      ? 'Information not available'
                                      : provider.scholarshipInfo,
                                  style: TextStyle(
                                      color: provider.scholarshipInfo.isEmpty
                                          ? Colors.white38
                                          : Colors.white70,
                                      fontSize: 13,
                                      height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Programme Details'),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (provider.offersOnline)
                                    const PlaceTag(
                                        label: 'Online',
                                        color: Color(0xFF3B82F6)),
                                  if (provider.offersOffline)
                                    const PlaceTag(
                                        label: 'Offline',
                                        color: Color(0xFF3B82F6)),
                                  if (provider.hasHostel)
                                    const PlaceTag(
                                        label: 'Hostel',
                                        color: Color(0xFF22C55E)),
                                  if (provider.hasTestSeries)
                                    const PlaceTag(
                                        label: 'Test Series',
                                        color: Color(0xFF8B5CF6)),
                                  if (provider.hasDoubtSupport)
                                    const PlaceTag(
                                        label: 'Doubt Support',
                                        color: Color(0xFFF97316)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.schedule_outlined,
                                text: 'Duration: ${provider.duration}',
                              ),
                              const SizedBox(height: 20),
                              const _SectionHeader(label: 'Popular Results'),
                              const SizedBox(height: 10),
                              _Card(
                                child: provider.popularResults.isEmpty
                                    ? const Text('Information not available',
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: provider.popularResults
                                            .map(
                                              (line) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Text('•  $line',
                                                    style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 13,
                                                        height: 1.5)),
                                              ),
                                            )
                                            .toList(),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              _InfoRow(
                                icon: Icons.language_outlined,
                                text: provider.website,
                                onTap: _visitWebsite,
                                isLink: true,
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.phone_outlined,
                                text: provider.phone ??
                                    'Information not available',
                                onTap: provider.phone == null
                                    ? null
                                    : () => _call(provider.phone!),
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.email_outlined,
                                text: provider.email ??
                                    'Information not available',
                                onTap: provider.email == null
                                    ? null
                                    : () => _email(provider.email!),
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
                                        vertical: 14),
                                  ),
                                  onPressed: _visitWebsite,
                                  icon: const Icon(Icons.open_in_new_rounded,
                                      color: Colors.white, size: 18),
                                  label: const Text('Visit Website',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side:
                                        const BorderSide(color: Colors.white24),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    foregroundColor: AppColors.accent,
                                  ),
                                  onPressed: _findingBranch
                                      ? null
                                      : _findNearestBranch,
                                  icon: _findingBranch
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.accent),
                                        )
                                      : const Icon(Icons.near_me_outlined,
                                          size: 18),
                                  label: Text(_findingBranch
                                      ? 'Finding your city…'
                                      : 'Find Nearest Branch'),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
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

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.items, this.color = AppColors.primary});
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((item) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ))
          .toList(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.onTap,
    this.isLink = false,
  });
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool isLink;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white38, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isLink
                      ? AppColors.accent
                      : (onTap == null ? Colors.white38 : Colors.white60),
                  fontSize: 13,
                  decoration: isLink ? TextDecoration.underline : null,
                  decorationColor: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      );
}
