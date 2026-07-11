import 'package:shared_preferences/shared_preferences.dart';

/// Local "Save"/"Favorites" store for the Explore feature (nearby schools +
/// coaching providers). Kept purely on-device via [SharedPreferences] — this
/// feature has no backend, so there's nothing to sync.
class ExploreBookmarksRepository {
  ExploreBookmarksRepository._();
  static final instance = ExploreBookmarksRepository._();

  static const _schoolsKey = 'explore_saved_schools';
  static const _coachingsKey = 'explore_saved_coachings';

  Future<Set<String>> savedSchoolIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_schoolsKey) ?? const []).toSet();
  }

  Future<bool> toggleSchool(String osmId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_schoolsKey) ?? const []).toSet();
    final nowSaved = !ids.contains(osmId);
    nowSaved ? ids.add(osmId) : ids.remove(osmId);
    await prefs.setStringList(_schoolsKey, ids.toList());
    return nowSaved;
  }

  Future<Set<String>> savedCoachingIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_coachingsKey) ?? const []).toSet();
  }

  Future<bool> toggleCoaching(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_coachingsKey) ?? const []).toSet();
    final nowSaved = !ids.contains(id);
    nowSaved ? ids.add(id) : ids.remove(id);
    await prefs.setStringList(_coachingsKey, ids.toList());
    return nowSaved;
  }
}
