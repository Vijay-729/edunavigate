import '../models/college_model.dart';
import '../models/course_model.dart';

/// Lightweight preference bag the AI match score is computed against. Kept
/// independent of [UserProfile] so this service has no dependency on the
/// profile feature — callers adapt whatever profile/filter state they have
/// into this shape.
class CollegeMatchPreferences {
  final CourseCategory? preferredCourseCategory;
  final String? preferredState;
  final List<String> preferredCities;
  final int? budgetPerYear;
  final bool hostelRequired;
  final String? examId;

  const CollegeMatchPreferences({
    this.preferredCourseCategory,
    this.preferredState,
    this.preferredCities = const [],
    this.budgetPerYear,
    this.hostelRequired = false,
    this.examId,
  });
}

/// Scores how well a college fits a student's stated/inferred preferences.
/// This is a transparent, rule-based heuristic (not a trained model) — kept
/// deliberately simple and explainable, matching the rest of the app's
/// "AI Mentor" style of guidance rather than a black-box score.
class AiMatchService {
  AiMatchService._();

  static double computeMatch(
    CollegeModel college,
    CollegeMatchPreferences prefs,
  ) {
    double score = 52;

    if (prefs.preferredCourseCategory != null &&
        college.categories.contains(prefs.preferredCourseCategory)) {
      score += 18;
    }
    if (prefs.preferredState != null && college.state == prefs.preferredState) {
      score += 10;
    }
    if (prefs.preferredCities.contains(college.city)) {
      score += 6;
    }
    if (prefs.examId != null &&
        college.courses.any((c) => c.examIds.contains(prefs.examId))) {
      score += 6;
    }
    if (prefs.hostelRequired && college.hasHostel) {
      score += 5;
    }
    if (prefs.budgetPerYear != null) {
      if (college.startingFeePerYear <= prefs.budgetPerYear!) {
        score += 8;
      } else {
        final overBy = college.startingFeePerYear - prefs.budgetPerYear!;
        final penalty = (overBy / prefs.budgetPerYear!.clamp(1, 1 << 30)) * 20;
        score -= penalty.clamp(0, 25);
      }
    }

    // Reward strong outcomes/ranking as a tie-breaker signal.
    score += (college.placement.averagePackageLpa / 30 * 6).clamp(0, 6);
    if (college.nirfRank != null && college.nirfRank! <= 25) {
      score += 4;
    }

    return score.clamp(35, 99);
  }

  /// Ids of colleges scoring >= 80 for the given preferences — backs both the
  /// "AI Recommended" quick filter and the "Recommended For You" rail.
  static Set<String> topRecommendedIds(
    List<CollegeModel> colleges,
    CollegeMatchPreferences prefs, {
    double threshold = 78,
  }) {
    return colleges
        .where((c) => computeMatch(c, prefs) >= threshold)
        .map((c) => c.id)
        .toSet();
  }
}
