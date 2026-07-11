import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_colors.dart';
import '../data/explore_bookmarks_repository.dart';
import '../models/nearby_school.dart';
import '../models/selected_location.dart';
import '../providers/explore_providers.dart';
import '../services/nearby_places_service.dart';
import 'college_detail_screen.dart';
import 'explore_status_views.dart';
import 'location_selection_sheet.dart';
import 'place_card_widgets.dart';

enum _SortMode { distance, alphabetical }

enum _ScreenState {
  loading,
  permissionDenied,
  serviceDisabled,
  noInternet,
  apiError,
  ready,
}

/// Class 12's live "Nearby Colleges" search — same free OpenStreetMap
/// architecture as [NearbyPlacesService.searchNearbySchools] (Geolocator +
/// Overpass + Nominatim, no API key), but restricted to
/// [NearbyPlacesService.searchNearbyColleges] so only colleges/universities
/// show up, not plain schools. See [NearbySchoolsScreen] — kept untouched
/// and used as-is on the other class dashboards.
class NearbyCollegesScreen extends ConsumerStatefulWidget {
  const NearbyCollegesScreen({super.key});

  @override
  ConsumerState<NearbyCollegesScreen> createState() =>
      _NearbyCollegesScreenState();
}

class _NearbyCollegesScreenState extends ConsumerState<NearbyCollegesScreen> {
  _ScreenState _screenState = _ScreenState.loading;
  String _errorMessage = '';
  bool _permissionDeniedForever = false;
  double? _radiusUsedMeters;

  /// "City, State" for whatever position the last successful search used —
  /// shown under the title so it's obvious the results are live and tied to
  /// wherever the device/emulator's GPS currently is, not fixed sample data.
  String? _locationLabel;

  /// Live position updates so the screen re-searches automatically if the
  /// device's (or emulator's) GPS location changes while it's open —
  /// started only after the first successful load, since it requires
  /// permission to already be granted.
  StreamSubscription<Position>? _positionSub;
  bool _reloading = false;

  List<NearbySchool> _allColleges = [];
  String _selectedLevel = 'All';
  _SortMode _sortMode = _SortMode.distance;
  String _query = '';
  bool _savedOnly = false;
  Set<String> _savedIds = {};
  final _levels = ['All', 'College', 'University'];

  @override
  void initState() {
    super.initState();
    _init();
    _loadSaved();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  /// Shared location system (spec: one common location service for Nearby
  /// Colleges/Schools/Coaching Explorer) — on first visit (no saved
  /// location yet) shows [LocationSelectionSheet]; on every later visit the
  /// previously-picked GPS fix or manually-searched city is reused as-is.
  Future<void> _init() async {
    final notifier = ref.read(selectedLocationProvider.notifier);
    await notifier.ensureInitialized();
    if (!mounted) return;
    var location = ref.read(selectedLocationProvider);
    if (location == null && mounted) {
      location = await showLocationSelectionSheet(context, ref);
    }
    _load(location: location);
  }

  /// "Change Location" — lets the student switch between GPS and a manually
  /// searched city at any time, from any of the three Explore screens.
  Future<void> _changeLocation() async {
    final location = await showLocationSelectionSheet(context, ref);
    if (location == null) return;
    _positionSub?.cancel();
    _positionSub = null;
    _load(location: location, forceRefresh: true);
  }

  void _startWatchingPosition() {
    if (_positionSub != null) return;
    _positionSub = NearbyPlacesService.watchPosition().listen(
      (position) {
        if (_reloading) return;
        _load(forceRefresh: true, position: position, silent: true);
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  void _updateLocationLabel(Position position) {
    NearbyPlacesService.currentCityState(position.latitude, position.longitude)
        .then((label) {
      if (mounted && label != null) setState(() => _locationLabel = label);
    });
  }

  Future<void> _loadSaved() async {
    final ids = await ExploreBookmarksRepository.instance.savedSchoolIds();
    if (mounted) setState(() => _savedIds = ids);
  }

  Future<void> _toggleSaved(String osmId) async {
    final nowSaved =
        await ExploreBookmarksRepository.instance.toggleSchool(osmId);
    if (!mounted) return;
    setState(() {
      if (nowSaved) {
        _savedIds.add(osmId);
      } else {
        _savedIds.remove(osmId);
      }
    });
  }

  /// [position]: reuse an already-known fresh fix (from the position stream)
  /// instead of requesting a new one. [location]: the shared
  /// [SelectedLocation] to search from — a manual city skips GPS entirely
  /// and uses its fixed lat/lon; GPS (or no location, e.g. the very first
  /// call before the sheet resolves) falls back to a live fix and starts
  /// auto-refreshing on movement, same as before the shared location system
  /// existed. [silent]: used for the automatic location-change refresh —
  /// keeps showing the current list instead of swapping in the loading
  /// skeleton, so it doesn't feel like a disruptive full-screen reload
  /// every time the device (or emulator) GPS moves.
  Future<void> _load({
    List<double>? radii,
    bool forceRefresh = false,
    Position? position,
    bool silent = false,
    SelectedLocation? location,
  }) async {
    if (!silent) setState(() => _screenState = _ScreenState.loading);
    _reloading = true;
    try {
      final activeLocation = location ?? ref.read(selectedLocationProvider);
      final isManual = activeLocation?.source == LocationSource.manual;
      final resolvedPosition = position ??
          (isManual
              ? NearbyPlacesService.positionFromLatLng(
                  activeLocation!.latitude, activeLocation.longitude)
              : await NearbyPlacesService.getCurrentLocation());
      final (colleges, radiusUsed) =
          await NearbyPlacesService.searchNearbyColleges(
        resolvedPosition,
        radii: radii ?? NearbyPlacesService.defaultRadiiMeters,
        forceRefresh: forceRefresh,
      );
      if (!mounted) return;
      setState(() {
        _allColleges = colleges;
        _radiusUsedMeters = radiusUsed;
        _screenState = _ScreenState.ready;
      });
      if (isManual) {
        setState(() => _locationLabel = activeLocation!.label);
      } else {
        _updateLocationLabel(resolvedPosition);
        _startWatchingPosition();
      }
    } on AppLocationServiceDisabledException {
      if (!silent) setState(() => _screenState = _ScreenState.serviceDisabled);
    } on LocationPermissionDeniedException {
      if (!silent) {
        setState(() {
          _permissionDeniedForever = false;
          _screenState = _ScreenState.permissionDenied;
        });
      }
    } on LocationPermissionDeniedForeverException {
      if (!silent) {
        setState(() {
          _permissionDeniedForever = true;
          _screenState = _ScreenState.permissionDenied;
        });
      }
    } on NoInternetException {
      if (!silent) setState(() => _screenState = _ScreenState.noInternet);
    } on PlacesApiException catch (e) {
      if (!silent) {
        setState(() {
          _errorMessage = e.message;
          _screenState = _ScreenState.apiError;
        });
      }
    } catch (e) {
      if (!silent) {
        setState(() {
          _errorMessage = e.toString();
          _screenState = _ScreenState.apiError;
        });
      }
    } finally {
      _reloading = false;
    }
  }

  List<NearbySchool> get _visibleColleges {
    var list = _allColleges;
    if (_selectedLevel != 'All') {
      list = list.where((c) => c.level == _selectedLevel).toList();
    }
    if (_savedOnly) {
      list = list.where((c) => _savedIds.contains(c.osmId)).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      list = list.where((c) => c.name.toLowerCase().contains(q)).toList();
    }
    list = [...list];
    list.sort((a, b) => _sortMode == _SortMode.distance
        ? a.distanceMeters.compareTo(b.distanceMeters)
        : a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

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
                // ── AppBar ──────────────────────────────────────────────
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
                              'Nearby Colleges',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            if (_locationLabel != null)
                              Row(
                                children: [
                                  const Icon(Icons.my_location_rounded,
                                      color: Colors.white38, size: 11),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      'Near $_locationLabel',
                                      style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_location_alt_outlined,
                            color: Colors.white70),
                        tooltip: 'Change Location',
                        onPressed: _changeLocation,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white70),
                        tooltip: 'Refresh',
                        onPressed: () => _load(forceRefresh: true),
                      ),
                    ],
                  ),
                ),

                if (_screenState == _ScreenState.ready) ...[
                  // ── Search ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search colleges by name…',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Colors.white38, size: 20),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Level filter + sort ─────────────────────────────
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            itemCount: _levels.length,
                            itemBuilder: (_, i) {
                              final level = _levels[i];
                              final selected = _selectedLevel == level;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedLevel = level),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : Colors.white12,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    level,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.white54,
                                      fontSize: 12.5,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded,
                            color: Colors.white38, size: 16),
                        const SizedBox(width: 6),
                        SortChip(
                          label: 'Nearest',
                          selected: _sortMode == _SortMode.distance,
                          onTap: () =>
                              setState(() => _sortMode = _SortMode.distance),
                        ),
                        const SizedBox(width: 8),
                        SortChip(
                          label: 'Name (A-Z)',
                          selected: _sortMode == _SortMode.alphabetical,
                          onTap: () => setState(
                              () => _sortMode = _SortMode.alphabetical),
                        ),
                        const SizedBox(width: 8),
                        SortChip(
                          label: '★ Saved',
                          selected: _savedOnly,
                          onTap: () => setState(() => _savedOnly = !_savedOnly),
                        ),
                        const Spacer(),
                        Text(
                          '${_visibleColleges.length} found${_radiusExpandedLabel()}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // ── Content ─────────────────────────────────────────────
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _radiusExpandedLabel() {
    final radius = _radiusUsedMeters;
    if (radius == null ||
        radius <= NearbyPlacesService.defaultRadiiMeters.first) {
      return '';
    }
    final km = (radius / 1000).round();
    return ' · expanded to ${km}km';
  }

  Widget _buildContent() {
    switch (_screenState) {
      case _ScreenState.loading:
        return const ShimmerCardList();

      case _ScreenState.permissionDenied:
        return ExploreMessageView(
          icon: Icons.location_off_rounded,
          title: 'Location access needed',
          message: _permissionDeniedForever
              ? 'Location permission is blocked. EduNavigate AI needs it to '
                  'find colleges near where you are right now. Enable it in '
                  'Settings, then try again.'
              : 'EduNavigate AI needs your location to search for colleges '
                  'near you. Grant permission to continue.',
          primaryLabel:
              _permissionDeniedForever ? 'Open Settings' : 'Grant Permission',
          onPrimary: () {
            if (_permissionDeniedForever) {
              Geolocator.openAppSettings();
            } else {
              _load();
            }
          },
        );

      case _ScreenState.serviceDisabled:
        return ExploreMessageView(
          icon: Icons.location_disabled_rounded,
          title: 'Turn on location services',
          message:
              'Your device\'s location services are off. Enable GPS to see '
              'colleges near your current location.',
          primaryLabel: 'Open Location Settings',
          onPrimary: () => Geolocator.openLocationSettings(),
          secondaryLabel: 'Retry',
          onSecondary: () => _load(),
        );

      case _ScreenState.noInternet:
        return ExploreMessageView(
          icon: Icons.wifi_off_rounded,
          title: 'No internet connection',
          message:
              'Searching nearby colleges needs an internet connection. Check '
              'your network and try again.',
          primaryLabel: 'Retry',
          onPrimary: () => _load(),
        );

      case _ScreenState.apiError:
        return ExploreMessageView(
          icon: Icons.cloud_off_rounded,
          title: 'Couldn\'t load nearby colleges',
          message: _errorMessage,
          primaryLabel: 'Retry',
          onPrimary: () => _load(),
        );

      case _ScreenState.ready:
        final colleges = _visibleColleges;
        if (colleges.isEmpty &&
            (_query.trim().isNotEmpty || _selectedLevel != 'All')) {
          return ExploreMessageView(
            icon: Icons.search_off_rounded,
            title: 'No matches found',
            message: 'Try a different filter, or clear your search.',
            primaryLabel: 'Clear Filters',
            onPrimary: () => setState(() {
              _query = '';
              _selectedLevel = 'All';
            }),
          );
        }
        if (colleges.isEmpty) {
          return ExploreMessageView(
            icon: Icons.account_balance_outlined,
            title: 'No nearby colleges found',
            message: 'We couldn\'t find any colleges or universities nearby. '
                'Try searching a larger area.',
            primaryLabel: 'Search Larger Area',
            onPrimary: () => _load(radii: NearbyPlacesService.wideRadiiMeters),
          );
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => _load(forceRefresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: colleges.length,
            itemBuilder: (_, i) => _CollegeCard(
              college: colleges[i],
              isSaved: _savedIds.contains(colleges[i].osmId),
              onToggleSaved: () => _toggleSaved(colleges[i].osmId),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => CollegeDetailScreen(college: colleges[i]),
                ),
              ),
            ),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// College Card
// ─────────────────────────────────────────────────────────────────────────────

class _CollegeCard extends StatelessWidget {
  const _CollegeCard({
    required this.college,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onTap,
  });

  final NearbySchool college;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EnrichedCardPhoto(
              wikidataId: college.wikidataId,
              wikipediaTitle: college.wikipediaTag,
              height: 130,
              icon: Icons.account_balance_rounded,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    college.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.white38, size: 13),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        college.address.isEmpty
                            ? college.distanceLabel
                            : '${college.distanceLabel} · ${college.address}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PlaceTag(label: college.level, color: AppColors.primary),
                      if (college.ownership != null) ...[
                        const SizedBox(width: 6),
                        PlaceTag(
                          label: college.ownership!,
                          color: college.ownership == 'Government'
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFF97316),
                        ),
                      ],
                      const Spacer(),
                      QuickActionIcon(
                        icon: isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        tooltip: isSaved ? 'Saved' : 'Save',
                        onTap: onToggleSaved,
                      ),
                      const SizedBox(width: 4),
                      QuickActionIcon(
                        icon: Icons.map_outlined,
                        tooltip: 'Open in Maps',
                        onTap: () => openInMaps(
                            college.latitude, college.longitude, college.name),
                      ),
                      const SizedBox(width: 4),
                      QuickActionIcon(
                        icon: Icons.directions_rounded,
                        tooltip: 'Get Directions',
                        onTap: () =>
                            getDirections(college.latitude, college.longitude),
                      ),
                      const SizedBox(width: 4),
                      QuickActionIcon(
                        icon: Icons.share_outlined,
                        tooltip: 'Share',
                        onTap: () => shareInstitution(college),
                      ),
                    ],
                  ),
                  if (college.popularCourses.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: college.popularCourses
                          .take(3)
                          .map((c) => PlaceTag(
                              label: c, color: const Color(0xFF8B5CF6)))
                          .toList(),
                    ),
                  ],
                  if (college.averageFees != null ||
                      college.naacGrade != null ||
                      college.nirfRank != null) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        if (college.averageFees != null)
                          _MiniStat(
                              icon: Icons.currency_rupee_rounded,
                              text: college.averageFees!),
                        if (college.naacGrade != null)
                          _MiniStat(
                              icon: Icons.workspace_premium_outlined,
                              text: 'NAAC ${college.naacGrade}'),
                        if (college.nirfRank != null)
                          _MiniStat(
                              icon: Icons.leaderboard_outlined,
                              text: 'NIRF #${college.nirfRank}'),
                      ],
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 12),
        const SizedBox(width: 3),
        Text(text,
            style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
      ],
    );
  }
}
