import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/models/user_profile.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/bookmark_repository.dart';
import '../data/scholarship_data.dart';
import '../data/scholarship_preferences_repository.dart';
import '../models/scholarship.dart';
import '../models/scholarship_preferences.dart';

enum ScholarshipSortOrder {
  recommended,
  deadline,
  highestAmount,
  latest,
  government,
  private,
}

extension ScholarshipSortOrderX on ScholarshipSortOrder {
  String get label {
    switch (this) {
      case ScholarshipSortOrder.recommended:
        return 'Recommended';
      case ScholarshipSortOrder.deadline:
        return 'Deadline';
      case ScholarshipSortOrder.highestAmount:
        return 'Highest Amount';
      case ScholarshipSortOrder.latest:
        return 'Latest';
      case ScholarshipSortOrder.government:
        return 'Government';
      case ScholarshipSortOrder.private:
        return 'Private';
    }
  }
}

@immutable
class ScholarshipFilter {
  /// null = any provider.
  final ScholarshipProvider? provider;
  final String query;
  final bool onlyBookmarked;

  /// When set, only show scholarships for this state or All-India ones.
  final String? state;

  /// 'Central' or 'State' — refines government schemes by scope. Null = any.
  final String? scopeKind;

  /// Any of SC / ST / OBC / EWS / Minority / Girls / Disabled — OR'd
  /// together (a scholarship matching any selected facet passes).
  final Set<String> categories;

  /// Any of 'Class 10' / 'Class 12' / 'UG' / 'PG' — OR'd together.
  final Set<String> classLevels;

  final bool meritBased;
  final bool incomeBased;
  final bool onlyClosingSoon;
  final bool onlyRecommended;

  const ScholarshipFilter({
    this.provider,
    this.query = '',
    this.onlyBookmarked = false,
    this.state,
    this.scopeKind,
    this.categories = const {},
    this.classLevels = const {},
    this.meritBased = false,
    this.incomeBased = false,
    this.onlyClosingSoon = false,
    this.onlyRecommended = false,
  });

  bool get hasAdvancedFilters =>
      scopeKind != null ||
      categories.isNotEmpty ||
      classLevels.isNotEmpty ||
      meritBased ||
      incomeBased;

  int get activeFilterCount =>
      (provider != null ? 1 : 0) +
      (scopeKind != null ? 1 : 0) +
      categories.length +
      classLevels.length +
      (meritBased ? 1 : 0) +
      (incomeBased ? 1 : 0);

  ScholarshipFilter copyWith({
    ScholarshipProvider? provider,
    bool clearProvider = false,
    String? query,
    bool? onlyBookmarked,
    String? state,
    bool clearState = false,
    String? scopeKind,
    bool clearScopeKind = false,
    Set<String>? categories,
    Set<String>? classLevels,
    bool? meritBased,
    bool? incomeBased,
    bool? onlyClosingSoon,
    bool? onlyRecommended,
  }) {
    return ScholarshipFilter(
      provider: clearProvider ? null : (provider ?? this.provider),
      query: query ?? this.query,
      onlyBookmarked: onlyBookmarked ?? this.onlyBookmarked,
      state: clearState ? null : (state ?? this.state),
      scopeKind: clearScopeKind ? null : (scopeKind ?? this.scopeKind),
      categories: categories ?? this.categories,
      classLevels: classLevels ?? this.classLevels,
      meritBased: meritBased ?? this.meritBased,
      incomeBased: incomeBased ?? this.incomeBased,
      onlyClosingSoon: onlyClosingSoon ?? this.onlyClosingSoon,
      onlyRecommended: onlyRecommended ?? this.onlyRecommended,
    );
  }

  ScholarshipFilter clearAdvanced() => ScholarshipFilter(
        provider: provider,
        query: query,
        onlyBookmarked: onlyBookmarked,
        state: state,
      );
}

final scholarshipFilterProvider = StateProvider.autoDispose<ScholarshipFilter>(
    (ref) => const ScholarshipFilter());

final scholarshipSortOrderProvider =
    StateProvider.autoDispose<ScholarshipSortOrder>(
        (ref) => ScholarshipSortOrder.recommended);

/// Live set of bookmarked scholarship ids for the signed-in user.
final bookmarkIdsProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(bookmarkRepositoryProvider).watchBookmarkIds(),
);

// ── Personalization (local, optional — see ScholarshipPreferences) ────────

class ScholarshipPreferencesNotifier
    extends StateNotifier<ScholarshipPreferences> {
  ScholarshipPreferencesNotifier() : super(const ScholarshipPreferences()) {
    _init();
  }

  Future<void> _init() async {
    final saved =
        await ScholarshipPreferencesRepository.instance.getPreferences();
    if (mounted) state = saved;
  }

  Future<void> update(
      ScholarshipPreferences Function(ScholarshipPreferences) transform) async {
    state = transform(state);
    await ScholarshipPreferencesRepository.instance.savePreferences(state);
  }
}

final scholarshipPreferencesProvider = StateNotifierProvider<
    ScholarshipPreferencesNotifier, ScholarshipPreferences>(
  (ref) => ScholarshipPreferencesNotifier(),
);

// ── Recommendation scoring ─────────────────────────────────────────────────

/// Canonical class/level bucket ('Class 10' | 'Class 12' | 'UG' | 'PG') for
/// the signed-in student, from their existing profile — independent of the
/// school-only [EducationStage] classifier since scholarships also target
/// UG/PG students.
String? _profileClassLevel(UserProfile profile) {
  final level = profile.educationLevel.toLowerCase();
  if (level.contains('postgraduate')) return 'PG';
  if (level.contains('undergraduate')) return 'UG';
  final year = profile.classOrYear.toLowerCase();
  if (year.contains('12')) return 'Class 12';
  if (year.contains('11')) return 'Class 12';
  if (year.contains('10') || year.contains('9') || year.contains('8')) {
    return 'Class 10';
  }
  return null;
}

/// Score a scholarship against the student's profile + optional local
/// preferences. Returns null when a *known* hard criterion (gender-only
/// scheme, income cap, minimum percentage, restricted category) rules the
/// student out outright — those scholarships are excluded from
/// "Recommended For You" rather than merely ranked lower.
int? _recommendationScore(
  Scholarship s,
  UserProfile? profile,
  ScholarshipPreferences prefs,
) {
  final gender = profile?.gender.trim().toLowerCase();
  if (s.isGirlsOnly &&
      gender != null &&
      gender.isNotEmpty &&
      gender != 'female') {
    return null;
  }
  if (s.isDisabledOnly && !prefs.disabled) return null;
  if (prefs.familyIncome != null &&
      s.maxFamilyIncome != null &&
      prefs.familyIncome! > s.maxFamilyIncome!) {
    return null;
  }
  if (prefs.percentage != null &&
      s.minPercentage != null &&
      prefs.percentage! < s.minPercentage!) {
    return null;
  }
  if (prefs.category != null &&
      prefs.category != 'General' &&
      s.categoryEligibility.isNotEmpty &&
      !s.categoryEligibility.contains(prefs.category)) {
    return null;
  }

  var score = 0;
  if (profile != null) {
    final classLevel = _profileClassLevel(profile);
    if (classLevel != null && s.classLevelsResolved.contains(classLevel)) {
      score += 2;
    }
    if (profile.state.trim().isNotEmpty &&
        (s.isAllIndia || s.states.contains(profile.state))) {
      score += 2;
    }
    if (profile.branch.trim().isNotEmpty) {
      final haystack =
          '${s.title} ${s.eligibility} ${s.description} ${s.tags.join(' ')}'
              .toLowerCase();
      if (haystack.contains(profile.branch.trim().toLowerCase())) score += 1;
    }
    if (s.isGirlsOnly && gender == 'female') score += 2;
  }
  if (prefs.category != null &&
      s.categoryEligibility.contains(prefs.category)) {
    score += 2;
  }
  if (prefs.familyIncome != null &&
      s.maxFamilyIncome != null &&
      prefs.familyIncome! <= s.maxFamilyIncome!) {
    score += 2;
  }
  if (prefs.percentage != null &&
      s.minPercentage != null &&
      prefs.percentage! >= s.minPercentage!) {
    score += 1;
  }
  if (s.isAllIndia) score += 1;
  return score;
}

/// "Recommended For You" — scholarships the student isn't ruled out of,
/// ranked by how well they match class/stream/state/gender/category/income/
/// percentage, highest first. Falls back to featuring merit-based, all-India
/// schemes when no profile/preferences are set yet, so the section is never
/// empty.
final recommendedScholarshipsProvider =
    Provider.autoDispose<List<Scholarship>>((ref) {
  final profile = ref.watch(currentProfileProvider).asData?.value;
  final prefs = ref.watch(scholarshipPreferencesProvider);

  final scored = <MapEntry<Scholarship, int>>[];
  for (final s in ScholarshipData.all) {
    final score = _recommendationScore(s, profile, prefs);
    if (score != null && score > 0) scored.add(MapEntry(s, score));
  }
  scored.sort((a, b) => b.value.compareTo(a.value));
  if (scored.isEmpty) {
    return ScholarshipData.all
        .where((s) => s.isMeritBased || s.isAllIndia)
        .take(8)
        .toList();
  }
  return scored.take(10).map((e) => e.key).toList();
});

/// Deadline within the next 15 days (spec: "🔥 Closing Soon").
final closingSoonScholarshipsProvider =
    Provider.autoDispose<List<Scholarship>>((ref) {
  return ScholarshipData.all.where((s) => s.isClosingSoon).toList()
    ..sort((a, b) => (a.closeDateResolved ?? DateTime(2100))
        .compareTo(b.closeDateResolved ?? DateTime(2100)));
});

// ── Search + filter + sort pipeline ────────────────────────────────────────

bool _matchesCategory(Scholarship s, String c) {
  switch (c) {
    case 'Girls':
      return s.isGirlsOnly;
    case 'Disabled':
      return s.isDisabledOnly;
    default:
      return s.categoryEligibility.contains(c);
  }
}

/// Scholarships after applying the active filter + search query.
final filteredScholarshipsProvider =
    Provider.autoDispose<List<Scholarship>>((ref) {
  final filter = ref.watch(scholarshipFilterProvider);
  final bookmarks = ref.watch(bookmarkIdsProvider).asData?.value ?? const {};
  final recommended = ref.watch(recommendedScholarshipsProvider);
  final recommendedIds = recommended.map((s) => s.id).toSet();
  final query = filter.query.trim().toLowerCase();

  var result = ScholarshipData.all.where((s) {
    if (filter.provider != null && s.provider != filter.provider) return false;
    if (filter.onlyBookmarked && !bookmarks.contains(s.id)) return false;
    if (filter.onlyClosingSoon && !s.isClosingSoon) return false;
    if (filter.onlyRecommended && !recommendedIds.contains(s.id)) return false;
    if (filter.state != null &&
        !s.isAllIndia &&
        !s.states.contains(filter.state)) {
      return false;
    }
    if (filter.scopeKind != null && s.scopeKind != filter.scopeKind) {
      return false;
    }
    if (filter.meritBased && !s.isMeritBased) return false;
    if (filter.incomeBased && !s.isIncomeBased) return false;
    if (filter.categories.isNotEmpty &&
        !filter.categories.any((c) => _matchesCategory(s, c))) {
      return false;
    }
    if (filter.classLevels.isNotEmpty &&
        !filter.classLevels.any((c) => s.classLevelsResolved.contains(c))) {
      return false;
    }
    if (query.isNotEmpty) {
      final haystack =
          '${s.title} ${s.organization} ${s.tags.join(' ')} ${s.eligibility} '
                  '${s.scopeLabel} ${s.providerLabel}'
              .toLowerCase();
      if (!haystack.contains(query)) return false;
    }
    return true;
  }).toList();

  final sort = ref.watch(scholarshipSortOrderProvider);
  switch (sort) {
    case ScholarshipSortOrder.recommended:
      result.sort((a, b) {
        final ai = recommendedIds.contains(a.id) ? 0 : 1;
        final bi = recommendedIds.contains(b.id) ? 0 : 1;
        if (ai != bi) return ai.compareTo(bi);
        return a.title.compareTo(b.title);
      });
      break;
    case ScholarshipSortOrder.deadline:
      result.sort((a, b) {
        final ad = a.closeDateResolved ?? DateTime(2100);
        final bd = b.closeDateResolved ?? DateTime(2100);
        return ad.compareTo(bd);
      });
      break;
    case ScholarshipSortOrder.highestAmount:
      result.sort((a, b) => b.amountValue.compareTo(a.amountValue));
      break;
    case ScholarshipSortOrder.latest:
      result = result.reversed.toList();
      break;
    case ScholarshipSortOrder.government:
      result.sort((a, b) {
        final ap = a.provider == ScholarshipProvider.government ? 0 : 1;
        final bp = b.provider == ScholarshipProvider.government ? 0 : 1;
        return ap.compareTo(bp);
      });
      break;
    case ScholarshipSortOrder.private:
      result.sort((a, b) {
        final ap = a.provider == ScholarshipProvider.private ? 0 : 1;
        final bp = b.provider == ScholarshipProvider.private ? 0 : 1;
        return ap.compareTo(bp);
      });
      break;
  }

  return result;
});
