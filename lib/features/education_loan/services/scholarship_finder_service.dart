import '../../scholarships/models/scholarship.dart';

/// Extra facets (course/gender/minority/disability/category) layered on top
/// of the existing Scholarships module — implemented as keyword matches
/// against each scholarship's title/eligibility/tags, since the shared
/// [Scholarship] model doesn't carry structured fields for these yet. Reuses
/// the existing scholarship dataset/bookmarks rather than duplicating them.
class ScholarshipFinderFilter {
  final String query;
  final ScholarshipProvider? provider;
  final String? state;
  final int? maxFamilyIncome;
  final String? course;
  final String? gender;
  final bool minorityOnly;
  final bool disabilityOnly;

  const ScholarshipFinderFilter({
    this.query = '',
    this.provider,
    this.state,
    this.maxFamilyIncome,
    this.course,
    this.gender,
    this.minorityOnly = false,
    this.disabilityOnly = false,
  });

  ScholarshipFinderFilter copyWith({
    String? query,
    ScholarshipProvider? provider,
    bool clearProvider = false,
    String? state,
    bool clearState = false,
    int? maxFamilyIncome,
    String? course,
    bool clearCourse = false,
    String? gender,
    bool clearGender = false,
    bool? minorityOnly,
    bool? disabilityOnly,
  }) {
    return ScholarshipFinderFilter(
      query: query ?? this.query,
      provider: clearProvider ? null : (provider ?? this.provider),
      state: clearState ? null : (state ?? this.state),
      maxFamilyIncome: maxFamilyIncome ?? this.maxFamilyIncome,
      course: clearCourse ? null : (course ?? this.course),
      gender: clearGender ? null : (gender ?? this.gender),
      minorityOnly: minorityOnly ?? this.minorityOnly,
      disabilityOnly: disabilityOnly ?? this.disabilityOnly,
    );
  }
}

class ScholarshipFinderService {
  ScholarshipFinderService._();

  static List<Scholarship> apply(
      List<Scholarship> all, ScholarshipFinderFilter filter) {
    final query = filter.query.trim().toLowerCase();
    return all.where((s) {
      if (filter.provider != null && s.provider != filter.provider) {
        return false;
      }
      if (filter.state != null &&
          !s.isAllIndia &&
          !s.states.contains(filter.state)) {
        return false;
      }
      if (filter.maxFamilyIncome != null &&
          s.maxFamilyIncome != null &&
          filter.maxFamilyIncome! > s.maxFamilyIncome!) {
        return false;
      }
      final haystack =
          '${s.title} ${s.organization} ${s.eligibility} ${s.tags.join(' ')}'
              .toLowerCase();
      if (query.isNotEmpty && !haystack.contains(query)) return false;
      if (filter.course != null &&
          !haystack.contains(filter.course!.toLowerCase())) {
        return false;
      }
      if (filter.gender != null &&
          filter.gender != 'Any' &&
          !haystack.contains(filter.gender!.toLowerCase())) {
        return false;
      }
      if (filter.minorityOnly && !haystack.contains('minority')) return false;
      if (filter.disabilityOnly &&
          !haystack.contains('disab') &&
          !haystack.contains('pwd') &&
          !haystack.contains('divyang')) {
        return false;
      }
      return true;
    }).toList();
  }
}
