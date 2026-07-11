import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/explore_location_repository.dart';
import '../models/selected_location.dart';

/// The student's chosen search location — shared by Nearby Colleges, Nearby
/// Schools and Coaching Explorer (spec: "one common location service used
/// by" all three). `null` until the first-visit [LocationSelectionSheet] (or
/// a saved preference from a previous session) resolves it. Deliberately
/// NOT autoDispose — the whole point is that picking a location on one of
/// these three screens carries over to the other two without re-prompting.
class SelectedLocationNotifier extends StateNotifier<SelectedLocation?> {
  SelectedLocationNotifier() : super(null) {
    _initFuture = _init();
  }

  late final Future<void> _initFuture;
  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> _init() async {
    final saved = await ExploreLocationRepository.instance.getSavedLocation();
    if (mounted) state = saved;
    _initialized = true;
  }

  /// Awaited by screens before deciding whether to show the first-visit
  /// location sheet, so a previously-saved location isn't mistaken for "no
  /// location yet" during the brief SharedPreferences read on cold start.
  Future<void> ensureInitialized() => _initFuture;

  Future<void> setLocation(SelectedLocation location) async {
    state = location;
    await ExploreLocationRepository.instance.saveLocation(location);
  }

  Future<void> clear() async {
    state = null;
    await ExploreLocationRepository.instance.clear();
  }
}

final selectedLocationProvider =
    StateNotifierProvider<SelectedLocationNotifier, SelectedLocation?>(
  (ref) => SelectedLocationNotifier(),
);

/// Up to 4 coaching providers selected for the side-by-side "Compare
/// Coachings" screen — same shape as College Explorer's
/// `CompareListNotifier`/`compareListProvider`, kept separate because it
/// tracks [CoachingProvider] ids, not college ids.
class CompareCoachingListNotifier extends StateNotifier<List<String>> {
  CompareCoachingListNotifier() : super(const []);

  static const maxCompare = 4;

  /// Returns false when the list is already full and [id] wasn't in it.
  bool toggle(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toList();
      return true;
    }
    if (state.length >= maxCompare) return false;
    state = [...state, id];
    return true;
  }

  void clear() => state = const [];
}

final compareCoachingListProvider = StateNotifierProvider.autoDispose<
    CompareCoachingListNotifier, List<String>>(
  (ref) => CompareCoachingListNotifier(),
);
