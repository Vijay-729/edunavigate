/// How a [SelectedLocation] was obtained — drives whether the nearby-search
/// screens keep auto-refreshing from live GPS or stay pinned to a manually
/// chosen city.
enum LocationSource { gps, manual }

/// The location driving every "nearby" search across Nearby Colleges,
/// Nearby Schools and Coaching Explorer's "Find Nearest Branch" — set once
/// via [LocationSelectionSheet] (first visit, or "Change Location") and
/// persisted locally so it doesn't need to be re-picked every session.
class SelectedLocation {
  const SelectedLocation({
    required this.latitude,
    required this.longitude,
    required this.source,
    this.city,
    this.state,
    this.displayName,
  });

  final double latitude;
  final double longitude;
  final LocationSource source;
  final String? city;
  final String? state;

  /// Full Nominatim display name — only set for manually-searched results,
  /// used as a fallback label when city/state components aren't both known.
  final String? displayName;

  /// "City, State", falling back to whatever single piece is known.
  String get label {
    if (city != null && state != null) return '$city, $state';
    if (city != null) return city!;
    if (state != null) return state!;
    return displayName ?? 'Selected location';
  }

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'source': source.name,
        'city': city,
        'state': state,
        'displayName': displayName,
      };

  factory SelectedLocation.fromMap(Map<String, dynamic> map) =>
      SelectedLocation(
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        source: LocationSource.values.firstWhere(
          (s) => s.name == map['source'],
          orElse: () => LocationSource.manual,
        ),
        city: map['city'] as String?,
        state: map['state'] as String?,
        displayName: map['displayName'] as String?,
      );
}
