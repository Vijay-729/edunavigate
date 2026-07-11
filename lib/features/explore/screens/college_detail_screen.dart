import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../data/explore_bookmarks_repository.dart';
import '../models/nearby_school.dart';
import '../services/nearby_places_service.dart';
import 'place_card_widgets.dart';

/// Detail page for a live "Nearby Colleges" result (Class 12 dashboard) —
/// same live-data model and refresh mechanism as [SchoolDetailScreen], with
/// an added Photos gallery, logo, and Popular Courses section.
class CollegeDetailScreen extends StatefulWidget {
  const CollegeDetailScreen({super.key, required this.college});

  final NearbySchool college;

  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen> {
  late NearbySchool _college = widget.college;
  String? _enrichedAddress;
  bool _isSaved = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _enrichAddressIfNeeded();
    ExploreBookmarksRepository.instance.savedSchoolIds().then((ids) {
      if (mounted) setState(() => _isSaved = ids.contains(_college.osmId));
    });
  }

  void _enrichAddressIfNeeded() {
    if (_college.address.isEmpty) {
      NearbyPlacesService.reverseGeocode(_college.latitude, _college.longitude)
          .then((address) {
        if (mounted && address != null) {
          setState(() => _enrichedAddress = address);
        }
      });
    }
  }

  Future<void> _toggleSaved() async {
    final nowSaved =
        await ExploreBookmarksRepository.instance.toggleSchool(_college.osmId);
    if (mounted) setState(() => _isSaved = nowSaved);
  }

  void _share() {
    ShareService.shareText(
      '${_college.name}\n${_address.isEmpty ? '' : '$_address\n'}'
      'https://www.openstreetmap.org/?mlat=${_college.latitude}&mlon=${_college.longitude}',
      subject: _college.name,
    );
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    try {
      final refreshed = await NearbyPlacesService.refreshSchool(
          _college.osmId, _college.distanceMeters);
      if (mounted && refreshed != null) {
        setState(() {
          _college = refreshed;
          _enrichedAddress = null;
        });
        _enrichAddressIfNeeded();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not refresh — please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  String get _address =>
      _college.address.isNotEmpty ? _college.address : (_enrichedAddress ?? '');

  @override
  Widget build(BuildContext context) {
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
                          _college.name,
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
                  child: _refreshing
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accent))
                      : _DetailBody(college: _college, address: _address),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _refreshing ? null : _refresh,
        backgroundColor: AppColors.primary,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh_rounded, color: Colors.white),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.college, required this.address});

  final NearbySchool college;
  final String address;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                      wikidataId: college.wikidataId,
                      wikipediaTitle: college.wikipediaTag,
                      height: 150,
                      icon: Icons.account_balance_rounded,
                    ),
                    Positioned(
                      left: 12,
                      bottom: -20,
                      child: InstitutionLogoAvatar(
                        wikidataId: college.wikidataId,
                        wikipediaTitle: college.wikipediaTag,
                        fallbackIcon: Icons.account_balance_rounded,
                        size: 48,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const _SectionHeader(label: 'Photos'),
                const SizedBox(height: 10),
                InstitutionGallerySection(
                  wikidataId: college.wikidataId,
                  wikipediaTitle: college.wikipediaTag,
                  icon: Icons.account_balance_rounded,
                  name: college.name,
                ),
                const SizedBox(height: 20),

                Text(
                  college.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    PlaceTag(label: college.level, color: AppColors.primary),
                    if (college.ownership != null)
                      PlaceTag(
                        label: college.ownership!,
                        color: college.ownership == 'Government'
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFF97316),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: address.isEmpty ? 'Address not available' : address,
                ),
                const SizedBox(height: 10),
                _InfoRow(
                    icon: Icons.straighten_outlined,
                    text: '${college.distanceLabel} away'),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.account_balance_outlined,
                  text: 'Type: ${college.level}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.workspace_premium_outlined,
                  text:
                      'NAAC Grade: ${college.naacGrade ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.leaderboard_outlined,
                  text:
                      'NIRF Ranking: ${college.nirfRank ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.currency_rupee_rounded,
                  text:
                      'Fee Structure: ${college.feeInfo ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.my_location_outlined,
                  text:
                      '${college.latitude.toStringAsFixed(5)}, ${college.longitude.toStringAsFixed(5)}',
                ),
                if (college.phone != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                      icon: Icons.phone_outlined,
                      text: college.phone!,
                      onTap: () => _call(college.phone!)),
                ],
                if (college.email != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                      icon: Icons.email_outlined,
                      text: college.email!,
                      onTap: () => _email(college.email!)),
                ],
                if (college.website != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.language_outlined,
                    text: college.website!,
                    onTap: () => _openUrl(college.website!),
                    isLink: true,
                  ),
                ],
                const SizedBox(height: 24),

                const _SectionHeader(label: 'Popular Courses'),
                const SizedBox(height: 10),
                college.popularCourses.isEmpty
                    ? const _Card(
                        child: Text('Information not available',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 13)),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: college.popularCourses
                            .map((c) => PlaceTag(
                                label: c, color: const Color(0xFF8B5CF6)))
                            .toList(),
                      ),
                const SizedBox(height: 24),

                const _SectionHeader(label: 'Facilities'),
                const SizedBox(height: 10),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FacilityRow(
                          label: 'Hostel',
                          available: _hasFacility(college, 'hostel')),
                      const Divider(color: Colors.white12, height: 20),
                      _FacilityRow(
                          label: 'Library',
                          available: _hasFacility(college, 'library')),
                      const Divider(color: Colors.white12, height: 20),
                      _FacilityRow(
                          label: 'Labs',
                          available: _hasFacility(college, 'lab')),
                      const Divider(color: Colors.white12, height: 20),
                      _FacilityRow(
                          label: 'Sports',
                          available: _hasFacility(college, 'sport')),
                      const Divider(color: Colors.white12, height: 20),
                      _FacilityRow(
                          label: 'Transport',
                          available: _hasFacility(college, 'transport')),
                      const Divider(color: Colors.white12, height: 20),
                      const _FacilityRow(label: 'Placement', available: null),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (college.openingHours != null) ...[
                  const _SectionHeader(label: 'Opening Hours'),
                  const SizedBox(height: 10),
                  _Card(
                    child: Text(college.openingHours!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13, height: 1.5)),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Map + directions ──────────────────────────────────
                const _SectionHeader(label: 'Location'),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.network(
                      'https://staticmap.openstreetmap.de/staticmap.php'
                      '?center=${college.latitude},${college.longitude}'
                      '&zoom=15&size=600x320'
                      '&markers=${college.latitude},${college.longitude},red-pushpin',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.white.withValues(alpha: 0.05),
                        child: const Icon(Icons.map_outlined,
                            color: Colors.white24, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          foregroundColor: Colors.white70,
                        ),
                        onPressed: () => openInMaps(
                            college.latitude, college.longitude, college.name),
                        icon: const Icon(Icons.map_outlined, size: 18),
                        label: const Text('Open in Maps'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          foregroundColor: AppColors.accent,
                        ),
                        onPressed: () =>
                            getDirections(college.latitude, college.longitude),
                        icon: const Icon(Icons.directions_rounded, size: 18),
                        label: const Text('Get Directions'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _email(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Best-effort check against OSM-derived [NearbySchool.facilities] — see
  /// [NearbyPlacesService.searchNearbyColleges]'s tag parsing. Sparse
  /// coverage is expected; [_FacilityRow] shows "Information not available"
  /// rather than "No" when a keyword doesn't match, since absence of an OSM
  /// tag doesn't mean the facility doesn't exist.
  bool _hasFacility(NearbySchool college, String keyword) =>
      college.facilities.any((f) => f.toLowerCase().contains(keyword));
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

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

/// One line in the College Details "Facilities" card — [available] is null
/// for facts OSM simply can't represent (e.g. Placement records), shown as
/// "Information not available" rather than a false "No".
class _FacilityRow extends StatelessWidget {
  const _FacilityRow({required this.label, required this.available});

  final String label;
  final bool? available;

  @override
  Widget build(BuildContext context) {
    final text = available == null
        ? 'Information not available'
        : (available! ? 'Yes' : 'Information not available');
    final color = available == true ? const Color(0xFF22C55E) : Colors.white38;
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13.5)),
        ),
        Text(text,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
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
  Widget build(BuildContext context) {
    return GestureDetector(
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
                color: isLink ? AppColors.accent : Colors.white60,
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
}
