import '../models/college_model.dart';
import '../models/course_model.dart';

enum CollegeSortOrder {
  relevance,
  highestPlacement,
  lowestFees,
  topRanked,
  mostPopular,
  newest,
}

extension CollegeSortOrderX on CollegeSortOrder {
  String get label {
    switch (this) {
      case CollegeSortOrder.relevance:
        return 'Relevance';
      case CollegeSortOrder.highestPlacement:
        return 'Highest Placement';
      case CollegeSortOrder.lowestFees:
        return 'Lowest Fees';
      case CollegeSortOrder.topRanked:
        return 'Top Ranked';
      case CollegeSortOrder.mostPopular:
        return 'Most Popular';
      case CollegeSortOrder.newest:
        return 'Newest';
    }
  }
}

/// Everything a student can narrow a college list down by. Immutable +
/// `copyWith` so Riverpod can diff it cheaply.
class CollegeFilter {
  final String query;
  final CourseCategory? courseCategory;
  final String? state;
  final String? city;
  final bool governmentOnly;
  final bool privateOnly;
  final bool autonomousOnly;
  final bool naacAPlusPlusOnly;
  final bool nbaOnly;
  final bool hostelOnly;
  final bool scholarshipOnly;
  final bool lowFeesOnly;
  final bool highPlacementOnly;
  final bool aiRecommendedOnly;
  final int? maxFeesPerYear;

  /// Entrance exam ids a college must accept at least one of (OR match).
  /// Plural because some searches span multiple ids for the same exam
  /// family, e.g. "JEE Colleges" matches both `jee_main` and `jee_advanced`.
  final List<String> examIds;

  const CollegeFilter({
    this.query = '',
    this.courseCategory,
    this.state,
    this.city,
    this.governmentOnly = false,
    this.privateOnly = false,
    this.autonomousOnly = false,
    this.naacAPlusPlusOnly = false,
    this.nbaOnly = false,
    this.hostelOnly = false,
    this.scholarshipOnly = false,
    this.lowFeesOnly = false,
    this.highPlacementOnly = false,
    this.aiRecommendedOnly = false,
    this.maxFeesPerYear,
    this.examIds = const [],
  });

  bool get isEmpty =>
      query.isEmpty &&
      courseCategory == null &&
      state == null &&
      city == null &&
      !governmentOnly &&
      !privateOnly &&
      !autonomousOnly &&
      !naacAPlusPlusOnly &&
      !nbaOnly &&
      !hostelOnly &&
      !scholarshipOnly &&
      !lowFeesOnly &&
      !highPlacementOnly &&
      !aiRecommendedOnly &&
      maxFeesPerYear == null &&
      examIds.isEmpty;

  CollegeFilter copyWith({
    String? query,
    CourseCategory? courseCategory,
    bool clearCourseCategory = false,
    String? state,
    bool clearState = false,
    String? city,
    bool clearCity = false,
    bool? governmentOnly,
    bool? privateOnly,
    bool? autonomousOnly,
    bool? naacAPlusPlusOnly,
    bool? nbaOnly,
    bool? hostelOnly,
    bool? scholarshipOnly,
    bool? lowFeesOnly,
    bool? highPlacementOnly,
    bool? aiRecommendedOnly,
    int? maxFeesPerYear,
    bool clearMaxFees = false,
    List<String>? examIds,
  }) {
    return CollegeFilter(
      query: query ?? this.query,
      courseCategory:
          clearCourseCategory ? null : (courseCategory ?? this.courseCategory),
      state: clearState ? null : (state ?? this.state),
      city: clearCity ? null : (city ?? this.city),
      governmentOnly: governmentOnly ?? this.governmentOnly,
      privateOnly: privateOnly ?? this.privateOnly,
      autonomousOnly: autonomousOnly ?? this.autonomousOnly,
      naacAPlusPlusOnly: naacAPlusPlusOnly ?? this.naacAPlusPlusOnly,
      nbaOnly: nbaOnly ?? this.nbaOnly,
      hostelOnly: hostelOnly ?? this.hostelOnly,
      scholarshipOnly: scholarshipOnly ?? this.scholarshipOnly,
      lowFeesOnly: lowFeesOnly ?? this.lowFeesOnly,
      highPlacementOnly: highPlacementOnly ?? this.highPlacementOnly,
      aiRecommendedOnly: aiRecommendedOnly ?? this.aiRecommendedOnly,
      maxFeesPerYear:
          clearMaxFees ? null : (maxFeesPerYear ?? this.maxFeesPerYear),
      examIds: examIds ?? this.examIds,
    );
  }
}

/// Pure, stateless search/filter/sort logic over a list of colleges. Kept
/// separate from Riverpod providers so it stays trivially unit-testable.
class CollegeQueryService {
  CollegeQueryService._();

  static List<CollegeModel> search(
    List<CollegeModel> colleges,
    String rawQuery,
  ) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return colleges;
    return colleges.where((c) {
      final haystack = <String>[
        c.name,
        c.city,
        c.state,
        if (c.nirfRank != null) 'nirf ${c.nirfRank}',
        ...c.courses.map((course) => course.name),
        ...c.courses.map((course) => course.shortName),
        ...c.courses.expand((course) => course.examIds),
        ...c.tags,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  static List<CollegeModel> filter(
    List<CollegeModel> colleges,
    CollegeFilter filter,
    Set<String> aiRecommendedIds,
  ) {
    return colleges.where((c) {
      if (filter.courseCategory != null &&
          !c.categories.contains(filter.courseCategory)) {
        return false;
      }
      if (filter.state != null && c.state != filter.state) return false;
      if (filter.city != null && c.city != filter.city) return false;
      if (filter.governmentOnly && !c.isGovernment) return false;
      if (filter.privateOnly && c.type != CollegeType.private) return false;
      if (filter.autonomousOnly && c.type != CollegeType.autonomous) {
        return false;
      }
      if (filter.naacAPlusPlusOnly && c.naacGrade != 'A++') return false;
      if (filter.nbaOnly && !c.nbaAccredited) return false;
      if (filter.hostelOnly && !c.hasHostel) return false;
      if (filter.scholarshipOnly && !c.scholarshipsAvailable) return false;
      if (filter.lowFeesOnly && c.startingFeePerYear > 100000) return false;
      if (filter.highPlacementOnly && c.placement.averagePackageLpa < 10) {
        return false;
      }
      if (filter.aiRecommendedOnly && !aiRecommendedIds.contains(c.id)) {
        return false;
      }
      if (filter.maxFeesPerYear != null &&
          c.startingFeePerYear > filter.maxFeesPerYear!) {
        return false;
      }
      if (filter.examIds.isNotEmpty &&
          !c.courses
              .any((course) => course.examIds.any(filter.examIds.contains))) {
        return false;
      }
      return true;
    }).toList();
  }

  static List<CollegeModel> sort(
    List<CollegeModel> colleges,
    CollegeSortOrder order,
  ) {
    final list = List<CollegeModel>.from(colleges);
    switch (order) {
      case CollegeSortOrder.relevance:
        break;
      case CollegeSortOrder.highestPlacement:
        list.sort((a, b) => b.placement.averagePackageLpa
            .compareTo(a.placement.averagePackageLpa));
        break;
      case CollegeSortOrder.lowestFees:
        list.sort(
            (a, b) => a.startingFeePerYear.compareTo(b.startingFeePerYear));
        break;
      case CollegeSortOrder.topRanked:
        list.sort((a, b) {
          final ra = a.nirfRank ?? 100000;
          final rb = b.nirfRank ?? 100000;
          return ra.compareTo(rb);
        });
        break;
      case CollegeSortOrder.mostPopular:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
        break;
      case CollegeSortOrder.newest:
        list.sort((a, b) =>
            (b.establishedYear ?? 0).compareTo(a.establishedYear ?? 0));
        break;
    }
    return list;
  }

  static List<String> distinctStates(List<CollegeModel> colleges) {
    final states = colleges.map((c) => c.state).toSet().toList();
    states.sort();
    return states;
  }

  static List<String> distinctCities(List<CollegeModel> colleges,
      {String? state}) {
    final cities = colleges
        .where((c) => state == null || c.state == state)
        .map((c) => c.city)
        .toSet()
        .toList();
    cities.sort();
    return cities;
  }

  /// Home-screen "Trending Colleges" rail — most popular first.
  static List<CollegeModel> trending(List<CollegeModel> colleges,
      {int take = 10}) {
    final list = sort(colleges, CollegeSortOrder.mostPopular);
    return list.take(take).toList();
  }

  static List<CollegeModel> topGovernment(List<CollegeModel> colleges,
      {int take = 10}) {
    final govt = colleges.where((c) => c.isGovernment).toList();
    return sort(govt, CollegeSortOrder.topRanked).take(take).toList();
  }

  static List<CollegeModel> topPrivate(List<CollegeModel> colleges,
      {int take = 10}) {
    final private =
        colleges.where((c) => c.type == CollegeType.private).toList();
    return sort(private, CollegeSortOrder.topRanked).take(take).toList();
  }

  static List<CollegeModel> topRanked(List<CollegeModel> colleges,
      {int take = 10}) {
    final ranked = colleges.where((c) => c.nirfRank != null).toList();
    return sort(ranked, CollegeSortOrder.topRanked).take(take).toList();
  }
}
