/// A school/college/university found via the Overpass API (OpenStreetMap),
/// centered on the device's live GPS position. Free alternative to Google
/// Places — coverage depends entirely on how well the area is mapped on OSM,
/// so some fields (ownership, board, phone, website, email, opening hours)
/// are frequently missing and should be shown as "Information not available"
/// rather than treated as an error.
class NearbySchool {
  const NearbySchool({
    required this.osmId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.level,
    required this.ownership,
    required this.board,
    required this.phone,
    required this.website,
    required this.email,
    required this.openingHours,
    this.wikidataId,
    this.wikipediaTag,
    this.facilities = const [],
    this.feeInfo,
    this.popularCourses = const [],
    this.naacGrade,
    this.nirfRank,
    this.medium,
  });

  /// OSM type+id, e.g. `"node/12345"` — stable enough to key a detail screen
  /// and re-fetch via [NearbyPlacesService.refreshSchool].
  final String osmId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  /// 'School' | 'College' | 'University' | 'Training Institute' |
  /// 'Educational Institution'.
  final String level;

  /// 'Government' | 'Private' | null when OSM doesn't say.
  final String? ownership;
  final String? board;
  final String? phone;
  final String? website;
  final String? email;

  /// Raw OSM `opening_hours` tag (e.g. "Mo-Fr 09:00-17:00"), shown as-is.
  final String? openingHours;

  /// OSM `wikidata` tag (e.g. `"Q12345"`) — used to look up a real campus
  /// photo/logo via [InstitutionMediaService] when OSM happens to have it.
  final String? wikidataId;

  /// OSM `wikipedia` tag (e.g. `"en:Delhi University"`), used the same way
  /// as [wikidataId] when there's no `wikidata` tag.
  final String? wikipediaTag;

  /// Best-effort facilities derived from OSM tags (internet access,
  /// wheelchair access, sport, library…) — frequently empty; shown as
  /// "Information not available" rather than treated as an error.
  final List<String> facilities;

  /// Raw OSM `fee` tag, if present. Almost never tagged for schools/colleges
  /// — shown as "Information not available" when null.
  final String? feeInfo;

  /// Raw OSM `education:programme`/`courses` tag, split on `;`. Almost never
  /// tagged — shown as "Information not available" when empty.
  final List<String> popularCourses;

  /// NAAC accreditation grade (e.g. "A++"), if OSM happens to tag it.
  /// Virtually never present — shown as "Information not available".
  final String? naacGrade;

  /// NIRF ranking, if OSM happens to tag it. Virtually never present —
  /// shown as "Information not available".
  final String? nirfRank;

  /// Raw average-fees figure, if OSM happens to tag it. Distinct from
  /// [feeInfo] only in label (spec: colleges show "Average Fees" while
  /// schools show "Fee Structure") — both read from the same underlying
  /// OSM `fee` tag.
  String? get averageFees => feeInfo;

  /// Medium of instruction (e.g. "English", "Hindi"), if OSM happens to tag
  /// it. Virtually never present — shown as "Information not available".
  final String? medium;

  String get distanceLabel => distanceMeters < 1000
      ? '${distanceMeters.round()} m'
      : '${(distanceMeters / 1000).toStringAsFixed(1)} km';
}
