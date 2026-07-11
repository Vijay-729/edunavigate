import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/nearby_school.dart';
import '../models/selected_location.dart';

class AppLocationServiceDisabledException implements Exception {}

class LocationPermissionDeniedException implements Exception {}

class LocationPermissionDeniedForeverException implements Exception {}

/// No network reachable at all (airplane mode, no signal, DNS failure, …).
class NoInternetException implements Exception {}

/// Raised for any non-2xx/timeout response from Overpass or Nominatim.
class PlacesApiException implements Exception {
  PlacesApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Live nearby-schools search backed entirely by free, keyless services:
/// device GPS (Geolocator), OpenStreetMap data queried via the Overpass API,
/// and Nominatim for on-demand reverse geocoding. No Google Maps Platform
/// billing, no API key, ever.
///
/// "Top Coaching Institutes" deliberately does NOT use this service — see
/// [CoachingProviders] — OSM coverage of coaching centres is too sparse to
/// search live, so that feature uses curated data instead.
class NearbyPlacesService {
  static const _overpassUrl = 'https://overpass-api.de/api/interpreter';
  static const _nominatimReverseUrl =
      'https://nominatim.openstreetmap.org/reverse';

  /// Nominatim's usage policy requires a descriptive User-Agent identifying
  /// the application making requests.
  static const _userAgent = 'EduNavigateAI/1.0 (student career guidance app)';

  /// Radii tried in order until a search finds something (spec: 10km, then
  /// 20km, then 50km). "Search Larger Area" retries with [wideRadiiMeters].
  static const defaultRadiiMeters = [10000.0, 20000.0, 50000.0];
  static const wideRadiiMeters = [100000.0];

  /// Session-only cache keyed by "lat,lon@radiusTier" so reopening the
  /// screen without an explicit refresh doesn't refetch Overpass.
  static final Map<String, (List<NearbySchool>, double)> _schoolsCache = {};

  static Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw AppLocationServiceDisabledException();
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedForeverException();
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  /// Builds a synthetic [Position] for a manually-selected city (spec:
  /// "Search City / Area Manually") so the exact same Overpass search code
  /// path used for a live GPS fix also works for a fixed lat/lon — with no
  /// real accuracy/heading/speed data, since none of that applies to a
  /// hand-picked location.
  static Position positionFromLatLng(double latitude, double longitude) {
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Live GPS updates for as long as a nearby-search screen stays open —
  /// lets Nearby Schools/Nearby Colleges notice the device's (or emulator's,
  /// via Extended Controls) location changing and re-run the search against
  /// the new position automatically, instead of only on manual refresh.
  /// [distanceFilterMeters] is how far the device must move before a new
  /// event fires; callers should already hold location permission (i.e.
  /// call this only after [getCurrentLocation] has succeeded once).
  static Stream<Position> watchPosition({int distanceFilterMeters = 150}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  // ── Schools / Colleges / Universities / Training Institutes ─────────────

  static Future<(List<NearbySchool>, double)> searchNearbySchools(
    Position position, {
    List<double> radii = defaultRadiiMeters,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        '${position.latitude.toStringAsFixed(2)},${position.longitude.toStringAsFixed(2)}@${radii.first}';
    if (!forceRefresh && _schoolsCache.containsKey(cacheKey)) {
      return _schoolsCache[cacheKey]!;
    }

    for (final radius in radii) {
      final elements = await _overpassQuery(_schoolsQuery(position, radius));
      final schools = elements
          .map((e) => _toSchool(
                e,
                distanceMeters: (lat, lng) => Geolocator.distanceBetween(
                    position.latitude, position.longitude, lat, lng),
              ))
          .whereType<NearbySchool>()
          .toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      if (schools.isNotEmpty) {
        final result = (schools, radius);
        _schoolsCache[cacheKey] = result;
        return result;
      }
    }
    final empty = (const <NearbySchool>[], radii.last);
    _schoolsCache[cacheKey] = empty;
    return empty;
  }

  static String _schoolsQuery(Position p, double radius) {
    final around = '(around:${radius.round()},${p.latitude},${p.longitude})';
    return '[out:json][timeout:25];'
        '('
        'node["amenity"~"^(school|college|university)\$"]$around;'
        'way["amenity"~"^(school|college|university)\$"]$around;'
        'relation["amenity"~"^(school|college|university)\$"]$around;'
        'node["office"="educational_institution"]$around;'
        'way["office"="educational_institution"]$around;'
        ');'
        'out center;';
  }

  /// Re-fetches a single school by its stored OSM id (`"node/12345"` etc.) —
  /// used by the "Refresh" action on the school details page to pick up any
  /// tag changes without re-running the whole nearby search or requesting a
  /// fresh GPS fix (the previously-known distance is preserved as-is).
  static Future<NearbySchool?> refreshSchool(
      String osmId, double previousDistanceMeters) async {
    final parts = osmId.split('/');
    if (parts.length != 2) return null;
    final ql = '[out:json][timeout:25];${parts[0]}(${parts[1]});out center;';
    final elements = await _overpassQuery(ql);
    if (elements.isEmpty) return null;
    return _toSchool(elements.first,
        distanceMeters: (_, __) => previousDistanceMeters);
  }

  static NearbySchool? _toSchool(
    Map<String, dynamic> e, {
    required double Function(double lat, double lng) distanceMeters,
  }) {
    final lat = _lat(e);
    final lng = _lng(e);
    if (lat == null || lng == null) return null;
    final tags = (e['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
    final name = tags['name'] as String?;
    if (name == null || name.trim().isEmpty) return null;
    return NearbySchool(
      osmId: '${e['type']}/${e['id']}',
      name: name,
      address: _addressFromTags(tags),
      latitude: lat,
      longitude: lng,
      distanceMeters: distanceMeters(lat, lng),
      level: _levelFromTags(tags),
      ownership: _ownershipFromTags(tags),
      board: tags['school:board'] as String? ?? tags['board'] as String?,
      phone: tags['contact:phone'] as String? ?? tags['phone'] as String?,
      website: tags['contact:website'] as String? ?? tags['website'] as String?,
      email: tags['contact:email'] as String? ?? tags['email'] as String?,
      openingHours: tags['opening_hours'] as String?,
      wikidataId: tags['wikidata'] as String?,
      wikipediaTag: tags['wikipedia'] as String?,
      facilities: _facilitiesFromTags(tags),
      feeInfo: tags['fee'] as String?,
      popularCourses: _coursesFromTags(tags),
      naacGrade: tags['naac:grade'] as String? ?? tags['naac'] as String?,
      nirfRank: tags['nirf:rank'] as String? ?? tags['nirf'] as String?,
      medium: tags['school:medium'] as String? ?? tags['medium'] as String?,
    );
  }

  /// Best-effort facilities derived from whatever OSM tags happen to be
  /// present — sparse coverage, so an empty list (→ "Information not
  /// available") is the common case, not a bug.
  static List<String> _facilitiesFromTags(Map<String, dynamic> tags) {
    final facilities = <String>[];
    final internet = (tags['internet_access'] as String?)?.toLowerCase();
    if (internet != null && internet != 'no') {
      facilities.add('Wi-Fi / Internet Access');
    }
    if ((tags['wheelchair'] as String?)?.toLowerCase() == 'yes') {
      facilities.add('Wheelchair Accessible');
    }
    final sport = tags['sport'] as String?;
    if (sport != null && sport.trim().isNotEmpty) {
      facilities
          .add('Sports: ${sport.split(';').map((s) => s.trim()).join(', ')}');
    }
    if (tags['leisure'] == 'sports_centre' ||
        tags['building'] == 'sports_hall') {
      facilities.add('Sports Centre');
    }
    if (tags['amenity'] == 'library' || tags['library'] != null) {
      facilities.add('Library');
    }
    if (tags['building'] == 'dormitory' || tags['amenity'] == 'dormitory') {
      facilities.add('Hostel');
    }
    if (tags['public_transport'] != null || tags['bus'] == 'yes') {
      facilities.add('Transport');
    }
    if (tags['laboratory'] != null ||
        (tags['name'] as String?)?.toLowerCase().contains('laboratory') ==
            true) {
      facilities.add('Labs');
    }
    return facilities;
  }

  static List<String> _coursesFromTags(Map<String, dynamic> tags) {
    final raw =
        tags['education:programme'] as String? ?? tags['courses'] as String?;
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // ── Colleges / Universities (Class 12 "Nearby Colleges") ────────────────

  /// Session-only cache, mirroring [_schoolsCache] but scoped to the
  /// college/university-only query used by "Nearby Colleges".
  static final Map<String, (List<NearbySchool>, double)> _collegesCache = {};

  /// Same live Overpass search as [searchNearbySchools] but restricted to
  /// `amenity=college|university` — used by the Class 12 dashboard's
  /// "Nearby Colleges" screen so it doesn't surface plain schools.
  static Future<(List<NearbySchool>, double)> searchNearbyColleges(
    Position position, {
    List<double> radii = defaultRadiiMeters,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        '${position.latitude.toStringAsFixed(2)},${position.longitude.toStringAsFixed(2)}@${radii.first}';
    if (!forceRefresh && _collegesCache.containsKey(cacheKey)) {
      return _collegesCache[cacheKey]!;
    }

    for (final radius in radii) {
      final elements = await _overpassQuery(_collegesQuery(position, radius));
      final colleges = elements
          .map((e) => _toSchool(
                e,
                distanceMeters: (lat, lng) => Geolocator.distanceBetween(
                    position.latitude, position.longitude, lat, lng),
              ))
          .whereType<NearbySchool>()
          .toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      if (colleges.isNotEmpty) {
        final result = (colleges, radius);
        _collegesCache[cacheKey] = result;
        return result;
      }
    }
    final empty = (const <NearbySchool>[], radii.last);
    _collegesCache[cacheKey] = empty;
    return empty;
  }

  static String _collegesQuery(Position p, double radius) {
    final around = '(around:${radius.round()},${p.latitude},${p.longitude})';
    return '[out:json][timeout:25];'
        '('
        'node["amenity"~"^(college|university)\$"]$around;'
        'way["amenity"~"^(college|university)\$"]$around;'
        'relation["amenity"~"^(college|university)\$"]$around;'
        ');'
        'out center;';
  }

  static String _levelFromTags(Map<String, dynamic> tags) {
    final amenity = tags['amenity'] as String?;
    if (amenity == 'university') return 'University';
    if (amenity == 'college') return 'College';
    if (amenity == 'school') return 'School';
    final name = (tags['name'] as String?)?.toLowerCase() ?? '';
    if (name.contains('training')) return 'Training Institute';
    return 'Educational Institution';
  }

  /// Best-effort — OSM only sometimes tags who runs a place. Returns null
  /// (displayed as "Information not available") when it can't tell.
  static String? _ownershipFromTags(Map<String, dynamic> tags) {
    final operatorType = (tags['operator:type'] as String?)?.toLowerCase();
    if (operatorType != null) {
      if (operatorType.contains('government') ||
          operatorType.contains('public')) {
        return 'Government';
      }
      if (operatorType.contains('private')) return 'Private';
    }
    final operatorName = (tags['operator'] as String?)?.toLowerCase() ?? '';
    if (operatorName.contains('government') ||
        operatorName.contains('municipal') ||
        operatorName.contains('govt')) {
      return 'Government';
    }
    return null;
  }

  // ── Reverse geocoding (Nominatim, on-demand — one call per detail open) ──

  static Future<String?> reverseGeocode(double lat, double lon) async {
    final address = await _reverseGeocodeAddress(lat, lon);
    return address?['display_name'] as String?;
  }

  /// Best-guess current city/town name, used to build the "Find Nearest
  /// Branch" Google Maps search query (e.g. "Allen Jammu").
  static Future<String?> currentCity(double lat, double lon) async {
    final address = await _reverseGeocodeAddress(lat, lon);
    final components = address?['address'] as Map<String, dynamic>?;
    if (components == null) return null;
    return components['city'] as String? ??
        components['town'] as String? ??
        components['municipality'] as String? ??
        components['county'] as String? ??
        components['state_district'] as String? ??
        components['state'] as String?;
  }

  /// "City, State" label shown on the Nearby Schools/Nearby Colleges screens
  /// so it's obvious which real-world location the live results are for
  /// (e.g. an emulator whose GPS is still set to its default location will
  /// clearly show that location's city here, rather than looking like the
  /// app is showing made-up data).
  static Future<String?> currentCityState(double lat, double lon) async {
    final cs = await cityStateComponents(lat, lon);
    if (cs.city != null && cs.state != null) return '${cs.city}, ${cs.state}';
    return cs.city ?? cs.state;
  }

  /// City and state as separate values (unlike [currentCityState], which
  /// joins them into one label) — needed when building a [SelectedLocation]
  /// for the shared location system, where the two are stored separately.
  static Future<({String? city, String? state})> cityStateComponents(
      double lat, double lon) async {
    final address = await _reverseGeocodeAddress(lat, lon);
    final components = address?['address'] as Map<String, dynamic>?;
    if (components == null) return (city: null, state: null);
    final city = components['city'] as String? ??
        components['town'] as String? ??
        components['village'] as String? ??
        components['municipality'] as String? ??
        components['county'] as String?;
    final state = components['state'] as String?;
    return (city: city, state: state);
  }

  /// Forward-geocodes a free-text city/area query (spec examples: "Delhi",
  /// "Jammu", "Pune", "Mumbai", "Bangalore", "Chandigarh") via Nominatim's
  /// `/search` endpoint — free, keyless, same usage-policy User-Agent as
  /// everything else in this service. Used by "Search City / Area Manually"
  /// in [LocationSelectionSheet].
  static Future<List<SelectedLocation>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];
    try {
      final uri =
          Uri.parse('https://nominatim.openstreetmap.org/search').replace(
        queryParameters: {
          'q': trimmed,
          'format': 'jsonv2',
          'addressdetails': '1',
          'limit': '8',
          'countrycodes': 'in',
        },
      );
      final response = await http.get(uri, headers: {
        'User-Agent': _userAgent
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return const [];
      final list = jsonDecode(response.body) as List;
      return list
          .map((raw) {
            final item = raw as Map<String, dynamic>;
            final address =
                item['address'] as Map<String, dynamic>? ?? const {};
            final lat = double.tryParse(item['lat'] as String? ?? '');
            final lon = double.tryParse(item['lon'] as String? ?? '');
            if (lat == null || lon == null) return null;
            final city = address['city'] as String? ??
                address['town'] as String? ??
                address['village'] as String? ??
                address['county'] as String? ??
                address['state_district'] as String?;
            final state = address['state'] as String?;
            return SelectedLocation(
              latitude: lat,
              longitude: lon,
              source: LocationSource.manual,
              city: city,
              state: state,
              displayName: item['display_name'] as String?,
            );
          })
          .whereType<SelectedLocation>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<Map<String, dynamic>?> _reverseGeocodeAddress(
      double lat, double lon) async {
    try {
      final uri = Uri.parse(_nominatimReverseUrl).replace(queryParameters: {
        'format': 'jsonv2',
        'lat': '$lat',
        'lon': '$lon',
        'zoom': '14',
        'addressdetails': '1',
      });
      final response = await http.get(uri, headers: {
        'User-Agent': _userAgent
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ── Overpass plumbing ────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> _overpassQuery(String ql) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(_overpassUrl),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
        body: {'data': ql},
      ).timeout(const Duration(seconds: 30));
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw NoInternetException();
    } on http.ClientException {
      throw NoInternetException();
    }
    if (response.statusCode != 200) {
      throw PlacesApiException(
        'The map data service returned an error (${response.statusCode}). '
        'Please try again in a moment.',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ((json['elements'] as List?) ?? const [])
        .cast<Map<String, dynamic>>();
  }

  static double? _lat(Map<String, dynamic> e) {
    if (e['lat'] != null) return (e['lat'] as num).toDouble();
    final center = e['center'] as Map<String, dynamic>?;
    return (center?['lat'] as num?)?.toDouble();
  }

  static double? _lng(Map<String, dynamic> e) {
    if (e['lon'] != null) return (e['lon'] as num).toDouble();
    final center = e['center'] as Map<String, dynamic>?;
    return (center?['lon'] as num?)?.toDouble();
  }

  static String _addressFromTags(Map<String, dynamic> tags) {
    final parts = [
      tags['addr:housenumber'],
      tags['addr:street'],
      tags['addr:suburb'],
      tags['addr:city'] ?? tags['addr:town'] ?? tags['addr:village'],
      tags['addr:state'],
      tags['addr:postcode'],
    ]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}
