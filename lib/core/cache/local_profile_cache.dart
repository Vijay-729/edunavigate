import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/profile/models/user_profile.dart';

/// Persists the signed-in user's profile locally so the app works even when
/// Firestore rules have not yet been deployed (writes are silently rolled back
/// when offline-persistence queues them and the server later rejects them).
///
/// Data flow:
///   save  — called after every successful [ProfileRepository.saveProfile]
///   load  — called by [currentProfileProvider] as a fallback when the
///            Firestore stream returns null
///   clear — called on sign-out so a new user cannot read a prior user's data
class LocalProfileCache {
  LocalProfileCache._();

  static const _key = 'edu_nav_profile_v1';

  static Future<void> save(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = Map<String, dynamic>.from(profile.toMap());
      // FieldValue.serverTimestamp() is not JSON-serialisable — strip it.
      map.remove('createdAt');
      map.remove('updatedAt');
      await prefs.setString(_key, jsonEncode(map));
    } catch (e, st) {
      debugPrint('LocalProfileCache.save failed: $e\n$st');
    }
  }

  static Future<UserProfile?> load(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      // Guard against a different user's cached data.
      if ((map['uid'] as String?) != uid) return null;
      return UserProfile.fromMap(uid, map);
    } catch (e, st) {
      debugPrint('LocalProfileCache.load failed: $e\n$st');
      return null;
    }
  }

  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}
