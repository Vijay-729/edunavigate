import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/scholarship_preferences.dart';

/// Local persistence for [ScholarshipPreferences] — purely on-device, same
/// pattern as the Explore feature's location/bookmark repositories, since
/// this data only sharpens recommendations and has no need for a backend.
class ScholarshipPreferencesRepository {
  ScholarshipPreferencesRepository._();
  static final instance = ScholarshipPreferencesRepository._();

  static const _key = 'scholarship_preferences';

  Future<ScholarshipPreferences> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const ScholarshipPreferences();
    try {
      return ScholarshipPreferences.fromMap(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const ScholarshipPreferences();
    }
  }

  Future<void> savePreferences(ScholarshipPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(preferences.toMap()));
  }
}
