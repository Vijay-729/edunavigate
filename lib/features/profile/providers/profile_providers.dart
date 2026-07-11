import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/local_profile_cache.dart';
import '../../../core/providers/firebase_providers.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';

/// Live stream of the signed-in user's profile.
///
/// Resolution order on each Firestore snapshot:
///   1. Complete Firestore document → use it directly (and sync to local cache).
///   2. Incomplete Firestore document (e.g. only assessment fields written after
///      the full saveProfile write was rejected) → merge assessment data on top
///      of the local SharedPreferences cache so neither source is lost.
///   3. Firestore returned null → fall back to local cache entirely.
///   4. Both null → return null (user genuinely has no profile yet).
///
/// The provider stays in AsyncLoading while Firebase Auth is still restoring
/// the persisted session, preventing a spurious null-profile flash that would
/// otherwise show the "Complete Profile" prompt on every cold start.
final currentProfileProvider = StreamProvider<UserProfile?>((ref) {
  final auth = ref.watch(authStateProvider);

  // Auth is still resolving — keep the provider in AsyncLoading so the
  // dashboard never renders the "incomplete profile" prompt prematurely.
  if (auth.isLoading) return const Stream.empty();

  final user = auth.asData?.value;
  if (user == null) return Stream.value(null); // definitively not signed in

  final uid = user.uid;
  return ref
      .watch(profileRepositoryProvider)
      .watchProfile(uid)
      .asyncMap((firestoreProfile) async {
    // ── Case 1: Firestore has a full, usable profile ─────────────────────
    if (firestoreProfile != null && firestoreProfile.isComplete) {
      LocalProfileCache.save(firestoreProfile); // best-effort, non-blocking
      return firestoreProfile;
    }

    // ── Cases 2 & 3: Firestore is null or incomplete ──────────────────────
    // This happens when:
    //   • The saveProfile Firestore write was rejected by security rules and
    //     rolled back (offline-persistence side-effect), but saveAssessmentStrengths
    //     later succeeded — creating a partial document with only assessment fields.
    //   • The document simply doesn't exist yet (new install / rules not deployed).
    // In both cases the local SharedPreferences cache is the source of truth
    // for the user-entered profile fields.
    final cached = await LocalProfileCache.load(uid);

    if (firestoreProfile != null && cached != null) {
      // Partial Firestore document exists alongside a cached profile.
      // Merge: full profile fields come from cache; assessment flags from Firestore.
      final merged = cached.copyWith(
        assessmentCompleted: firestoreProfile.assessmentCompleted,
        assessmentStrengths: firestoreProfile.assessmentStrengths.isNotEmpty
            ? firestoreProfile.assessmentStrengths
            : cached.assessmentStrengths,
      );
      LocalProfileCache.save(merged); // keep cache up-to-date
      return merged;
    }

    // Firestore is null — return local cache (may itself be null for new users).
    return cached;
  });
});
