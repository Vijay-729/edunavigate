import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/selected_location.dart';

/// Local persistence for the student's chosen search location — shared by
/// Nearby Colleges, Nearby Schools and Coaching Explorer so a location
/// picked once (GPS fix or manually searched city) is remembered across
/// app sessions until explicitly changed. Purely on-device, same pattern as
/// [ExploreBookmarksRepository].
class ExploreLocationRepository {
  ExploreLocationRepository._();
  static final instance = ExploreLocationRepository._();

  static const _key = 'explore_selected_location';

  Future<SelectedLocation?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return SelectedLocation.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLocation(SelectedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(location.toMap()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
