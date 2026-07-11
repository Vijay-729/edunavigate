import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../models/nearby_school.dart';
import '../services/institution_media_service.dart';

/// First-photo banner shared by school and coaching cards, with a graceful
/// gradient+icon placeholder when there's no photo for a place.
class CardPhoto extends StatelessWidget {
  const CardPhoto({
    super.key,
    required this.photoUrls,
    required this.height,
    this.icon = Icons.school_rounded,
  });

  final List<String> photoUrls;
  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: photoUrls.isEmpty
            ? _placeholder()
            : Image.network(
                photoUrls.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _placeholder(),
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.30),
              const Color(0xFF8B5CF6).withValues(alpha: 0.20),
            ],
          ),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white54, size: 44),
        ),
      );
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, required this.count});
  final double? rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return const Text('No ratings',
          style: TextStyle(color: Colors.white38, fontSize: 11));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAB308).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFEAB308), size: 13),
          const SizedBox(width: 3),
          Text(
            '${rating!.toStringAsFixed(1)} ($count)',
            style: const TextStyle(
                color: Color(0xFFEAB308),
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class OpenStatusTag extends StatelessWidget {
  const OpenStatusTag(
      {super.key, required this.openNow, required this.operational});
  final bool? openNow;
  final bool operational;

  @override
  Widget build(BuildContext context) {
    if (!operational) {
      return const PlaceTag(
          label: 'Permanently closed', color: Colors.redAccent);
    }
    if (openNow == null) return const SizedBox.shrink();
    return PlaceTag(
      label: openNow! ? 'Open now' : 'Closed now',
      color: openNow! ? const Color(0xFF22C55E) : Colors.redAccent,
    );
  }
}

class PlaceTag extends StatelessWidget {
  const PlaceTag({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Small circular icon action shared by coaching/school cards and detail
/// screens for the "Open in Maps" / "Get Directions" quick actions.
class QuickActionIcon extends StatelessWidget {
  const QuickActionIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.accent, size: 16),
        ),
      ),
    );
  }
}

/// Opens a location pin — first tries the device's default map app via a
/// `geo:` intent, falling back to the OpenStreetMap web view. No API key.
Future<void> openInMaps(double lat, double lng, String label) async {
  final geoUri =
      Uri.parse('geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(label)})');
  if (await canLaunchUrl(geoUri)) {
    await launchUrl(geoUri);
    return;
  }
  final osmUri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=17/$lat/$lng');
  await launchUrl(osmUri, mode: LaunchMode.externalApplication);
}

/// Turn-by-turn directions via the free Google Maps deep-link URL (no API
/// key — this is a plain web URL, not the billed Places/Maps SDK).
Future<void> getDirections(double lat, double lng) async {
  final uri =
      Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// One-tap "Share" quick action for a school/college card — the detail
/// screens already have their own richer `_share()`, this is the same idea
/// available directly from the list without opening the card first.
void shareInstitution(NearbySchool place) {
  final address = place.address.isEmpty ? '' : '${place.address}\n';
  ShareService.shareText(
    '${place.name}\n$address'
    'https://www.openstreetmap.org/?mlat=${place.latitude}&mlon=${place.longitude}',
    subject: place.name,
  );
}

class SortChip extends StatelessWidget {
  const SortChip(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: selected ? AppColors.primary : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.accent : Colors.white54,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Real-photo enrichment (Wikidata/Wikipedia — free, keyless)
// ─────────────────────────────────────────────────────────────────────────────

/// [CardPhoto] that lazily resolves a real photo via
/// [InstitutionMediaService] and falls back to the plain gradient
/// placeholder while loading or when nothing is found — used wherever a
/// nearby school/college or coaching provider might have a Wikidata/
/// Wikipedia entry, without ever blocking the card on the network call.
class EnrichedCardPhoto extends StatelessWidget {
  const EnrichedCardPhoto({
    super.key,
    required this.wikidataId,
    required this.wikipediaTitle,
    required this.height,
    this.icon = Icons.school_rounded,
  });

  final String? wikidataId;
  final String? wikipediaTitle;
  final double height;
  final IconData icon;

  bool get _hasLookupKey =>
      (wikidataId != null && wikidataId!.isNotEmpty) ||
      (wikipediaTitle != null && wikipediaTitle!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (!_hasLookupKey) {
      return CardPhoto(photoUrls: const [], height: height, icon: icon);
    }
    return FutureBuilder<InstitutionMedia>(
      future: InstitutionMediaService.fetch(
        wikidataId: wikidataId,
        wikipediaTitle: wikipediaTitle,
      ),
      builder: (context, snapshot) {
        final photo = snapshot.data?.photoUrl;
        return CardPhoto(
          photoUrls: photo == null ? const [] : [photo],
          height: height,
          icon: icon,
        );
      },
    );
  }
}

/// Small circular avatar for a real institution logo (Wikidata P154), with
/// the same [fallbackIcon] treatment the rest of Explore already uses when
/// nothing is available.
class InstitutionLogoAvatar extends StatelessWidget {
  const InstitutionLogoAvatar({
    super.key,
    required this.wikidataId,
    required this.wikipediaTitle,
    this.fallbackIcon = Icons.school_rounded,
    this.size = 56,
  });

  final String? wikidataId;
  final String? wikipediaTitle;
  final IconData fallbackIcon;
  final double size;

  bool get _hasLookupKey =>
      (wikidataId != null && wikidataId!.isNotEmpty) ||
      (wikipediaTitle != null && wikipediaTitle!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (!_hasLookupKey) return _fallback();
    return FutureBuilder<InstitutionMedia>(
      future: InstitutionMediaService.fetch(
        wikidataId: wikidataId,
        wikipediaTitle: wikipediaTitle,
      ),
      builder: (context, snapshot) {
        final logo = snapshot.data?.logoUrl;
        if (logo == null) return _fallback();
        return ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            logo,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          ),
        );
      },
    );
  }

  Widget _fallback() => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Icon(fallbackIcon, color: AppColors.accent, size: size * 0.5),
      );
}

/// "Photos" gallery strip for a detail page — resolves lazily via
/// [InstitutionMediaService]. When Wikimedia has no images for this place
/// (the common case), shows a premium branded placeholder (icon + initials)
/// instead of an empty box or "No photos available" text — spec: "Never
/// show empty image boxes or 'No photos available'."
class InstitutionGallerySection extends StatelessWidget {
  const InstitutionGallerySection({
    super.key,
    required this.wikidataId,
    required this.wikipediaTitle,
    this.icon = Icons.school_rounded,
    this.name,
  });

  final String? wikidataId;
  final String? wikipediaTitle;

  /// Fallback icon for the placeholder when no real photos are found.
  final IconData icon;

  /// Institution name, used to derive initials shown on the placeholder.
  final String? name;

  bool get _hasLookupKey =>
      (wikidataId != null && wikidataId!.isNotEmpty) ||
      (wikipediaTitle != null && wikipediaTitle!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (!_hasLookupKey) {
      return _GalleryPlaceholder(icon: icon, name: name);
    }
    return FutureBuilder<InstitutionMedia>(
      future: InstitutionMediaService.fetch(
        wikidataId: wikidataId,
        wikipediaTitle: wikipediaTitle,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 110,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.accent),
              ),
            ),
          );
        }
        final urls = snapshot.data?.galleryUrls ?? const [];
        if (urls.isEmpty) {
          return _GalleryPlaceholder(icon: icon, name: name);
        }
        return SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: urls.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                urls[i],
                width: 140,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _GalleryPlaceholder(icon: icon, name: name, width: 140),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Premium gradient placeholder shown wherever a real photo/gallery can't
/// be obtained — icon plus the institution's initials, matching [CardPhoto]/
/// [InstitutionLogoAvatar]'s visual language rather than a blank box.
class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder({required this.icon, this.name, this.width});

  final IconData icon;
  final String? name;
  final double? width;

  String get _initials {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    final words = trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials;
    return Container(
      height: 110,
      width: width ?? double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.28),
            const Color(0xFF8B5CF6).withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 30),
          if (initials.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              initials,
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1),
            ),
          ],
        ],
      ),
    );
  }
}
