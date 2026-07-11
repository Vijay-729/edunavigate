import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../data/explore_bookmarks_repository.dart';
import '../models/nearby_school.dart';
import '../services/nearby_places_service.dart';
import 'place_card_widgets.dart';

class SchoolDetailScreen extends StatefulWidget {
  const SchoolDetailScreen({super.key, required this.school});

  final NearbySchool school;

  @override
  State<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends State<SchoolDetailScreen> {
  late NearbySchool _school = widget.school;
  String? _enrichedAddress;
  bool _isSaved = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _enrichAddressIfNeeded();
    ExploreBookmarksRepository.instance.savedSchoolIds().then((ids) {
      if (mounted) setState(() => _isSaved = ids.contains(_school.osmId));
    });
  }

  void _enrichAddressIfNeeded() {
    if (_school.address.isEmpty) {
      NearbyPlacesService.reverseGeocode(_school.latitude, _school.longitude)
          .then((address) {
        if (mounted && address != null) {
          setState(() => _enrichedAddress = address);
        }
      });
    }
  }

  Future<void> _toggleSaved() async {
    final nowSaved =
        await ExploreBookmarksRepository.instance.toggleSchool(_school.osmId);
    if (mounted) setState(() => _isSaved = nowSaved);
  }

  void _share() {
    ShareService.shareText(
      '${_school.name}\n${_address.isEmpty ? '' : '$_address\n'}'
      'https://www.openstreetmap.org/?mlat=${_school.latitude}&mlon=${_school.longitude}',
      subject: _school.name,
    );
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    try {
      final refreshed = await NearbyPlacesService.refreshSchool(
          _school.osmId, _school.distanceMeters);
      if (mounted && refreshed != null) {
        setState(() {
          _school = refreshed;
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
      _school.address.isNotEmpty ? _school.address : (_enrichedAddress ?? '');

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
                          _school.name,
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
                      : _DetailBody(school: _school, address: _address),
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
  const _DetailBody({required this.school, required this.address});

  final NearbySchool school;
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
                      wikidataId: school.wikidataId,
                      wikipediaTitle: school.wikipediaTag,
                      height: 150,
                    ),
                    Positioned(
                      left: 12,
                      bottom: -20,
                      child: InstitutionLogoAvatar(
                        wikidataId: school.wikidataId,
                        wikipediaTitle: school.wikipediaTag,
                        fallbackIcon: Icons.school_rounded,
                        size: 48,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const _SectionHeader(label: 'Photos'),
                const SizedBox(height: 10),
                InstitutionGallerySection(
                  wikidataId: school.wikidataId,
                  wikipediaTitle: school.wikipediaTag,
                  icon: Icons.school_rounded,
                  name: school.name,
                ),
                const SizedBox(height: 20),

                Text(
                  school.name,
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
                    PlaceTag(label: school.level, color: AppColors.primary),
                    if (school.ownership != null)
                      PlaceTag(
                        label: school.ownership!,
                        color: school.ownership == 'Government'
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
                    text: '${school.distanceLabel} away'),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.school_outlined,
                  text: 'Type: ${school.level}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.menu_book_outlined,
                  text: 'Board: ${school.board ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.translate_outlined,
                  text:
                      'Medium: ${school.medium ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.currency_rupee_rounded,
                  text:
                      'Fee Structure: ${school.feeInfo ?? 'Information not available'}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.my_location_outlined,
                  text:
                      '${school.latitude.toStringAsFixed(5)}, ${school.longitude.toStringAsFixed(5)}',
                ),
                if (school.phone != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                      icon: Icons.phone_outlined,
                      text: school.phone!,
                      onTap: () => _call(school.phone!)),
                ],
                if (school.email != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                      icon: Icons.email_outlined,
                      text: school.email!,
                      onTap: () => _email(school.email!)),
                ],
                if (school.website != null) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.language_outlined,
                    text: school.website!,
                    onTap: () => _openUrl(school.website!),
                    isLink: true,
                  ),
                ],
                const SizedBox(height: 24),

                const _SectionHeader(label: 'Facilities'),
                const SizedBox(height: 10),
                school.facilities.isEmpty
                    ? const _Card(
                        child: Text('Information not available',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 13)),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: school.facilities
                            .map((f) => PlaceTag(
                                label: f, color: const Color(0xFF60A5FA)))
                            .toList(),
                      ),
                const SizedBox(height: 20),

                if (school.openingHours != null) ...[
                  const _SectionHeader(label: 'Opening Hours'),
                  const SizedBox(height: 10),
                  _Card(
                    child: Text(school.openingHours!,
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
                      '?center=${school.latitude},${school.longitude}'
                      '&zoom=15&size=600x320'
                      '&markers=${school.latitude},${school.longitude},red-pushpin',
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
                            school.latitude, school.longitude, school.name),
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
                            getDirections(school.latitude, school.longitude),
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
