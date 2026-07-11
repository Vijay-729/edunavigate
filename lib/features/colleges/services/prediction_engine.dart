import '../data/exam_seed_data.dart';
import '../models/college_model.dart';
import '../models/course_model.dart';
import '../models/prediction_model.dart';
import '../models/student_stream.dart';

/// Turns a [PredictionInput] plus the college catalogue into a tiered
/// [PredictionResult]. This is a transparent, explainable heuristic (ratio of
/// the student's rank/score against historical cutoffs) rather than a
/// trained ML model — every number shown to the student traces back to a
/// [CutoffEntry] in the seed/Firestore data, which is what the "AI Reason"
/// text spells out.
class PredictionEngine {
  PredictionEngine._();

  static const int _capPerTier = 8;

  static PredictionResult predict(
    PredictionInput input,
    List<CollegeModel> colleges,
  ) {
    final dream = <PredictedCollege>[];
    final target = <PredictedCollege>[];
    final safe = <PredictedCollege>[];

    final eligibleCategories = input.preferredCourseCategory != null
        ? {input.preferredCourseCategory!}
        : input.stream.eligibleCategories.toSet();

    for (final college in colleges) {
      if (!college.categories.any(eligibleCategories.contains)) continue;

      for (final course in college.courses) {
        if (!course.examIds.contains(input.examId)) continue;
        if (input.preferredCourseCategory != null &&
            course.category != input.preferredCourseCategory) {
          continue;
        }

        final wantHomeQuota =
            input.homeState != null && college.state == input.homeState;
        final cutoff = _bestCutoff(college, course, input, wantHomeQuota);
        if (cutoff == null) continue;

        final ratio = _ratio(cutoff, input);
        if (ratio == null) continue;

        double probability = _probabilityFromRatio(ratio);

        final overBudget = input.budgetPerYear != null &&
            college.startingFeePerYear > input.budgetPerYear!;
        if (overBudget) probability = (probability * 0.92).clamp(5, 99);

        final inPreferredState = input.preferredState != null &&
            college.state == input.preferredState;
        if (inPreferredState) probability = (probability + 3).clamp(5, 99);

        if (probability < 40) continue; // too much of a reach to surface

        final tier = probability >= 85
            ? PredictionTier.safe
            : probability >= 60
                ? PredictionTier.target
                : PredictionTier.dream;

        final predicted = PredictedCollege(
          collegeId: college.id,
          collegeName: college.name,
          courseId: course.id,
          courseName: course.shortName,
          tier: tier,
          probability: probability,
          expectedCutoffRank: cutoff.closingRank != null
              ? (cutoff.closingRank! * 1.05).round()
              : null,
          previousClosingRank: cutoff.closingRank,
          feesPerYear: college.startingFeePerYear,
          averagePackageLpa: college.placement.averagePackageLpa,
          hostelAvailable: college.hasHostel,
          aiReason: _buildReason(
            input: input,
            college: college,
            course: course,
            probability: probability,
            usedHomeQuota: cutoff.homeStateQuota,
            overBudget: overBudget,
          ),
        );

        switch (tier) {
          case PredictionTier.dream:
            dream.add(predicted);
            break;
          case PredictionTier.target:
            target.add(predicted);
            break;
          case PredictionTier.safe:
            safe.add(predicted);
            break;
        }
      }
    }

    dream.sort((a, b) => b.probability.compareTo(a.probability));
    target.sort((a, b) => b.probability.compareTo(a.probability));
    safe.sort((a, b) => b.probability.compareTo(a.probability));

    return PredictionResult(
      input: input,
      dreamColleges: dream.take(_capPerTier).toList(),
      targetColleges: target.take(_capPerTier).toList(),
      safeColleges: safe.take(_capPerTier).toList(),
      generatedAt: DateTime.now(),
    );
  }

  static CutoffEntry? _bestCutoff(
    CollegeModel college,
    CourseModel course,
    PredictionInput input,
    bool wantHomeQuota,
  ) {
    final entries =
        college.cutoffs.where((e) => e.courseId == course.id).toList();
    if (entries.isEmpty) return null;

    final categoryKey = input.category.dataKey;

    CutoffEntry? find(bool Function(CutoffEntry) test) {
      for (final e in entries) {
        if (test(e)) return e;
      }
      return null;
    }

    return find((e) =>
            e.category == categoryKey && e.homeStateQuota == wantHomeQuota) ??
        find((e) =>
            e.category == 'general' && e.homeStateQuota == wantHomeQuota) ??
        find((e) => e.category == categoryKey) ??
        find((e) => e.category == 'general') ??
        entries.first;
  }

  static double? _ratio(CutoffEntry cutoff, PredictionInput input) {
    if (cutoff.closingRank != null && input.examRank != null) {
      return input.examRank! / cutoff.closingRank!;
    }
    if (cutoff.closingScore != null &&
        input.examScore != null &&
        input.examScore! > 0) {
      return cutoff.closingScore! / input.examScore!;
    }
    return null;
  }

  /// Piecewise-linear mapping from "how far the student's rank/score is from
  /// the cutoff" (ratio <= 1 means they clear it) to an admission probability.
  static double _probabilityFromRatio(double ratio) {
    if (ratio <= 0.4) return (97 + (0.4 - ratio) / 0.4 * 2).clamp(0, 99);
    if (ratio <= 0.7) return 85 + (0.7 - ratio) / 0.3 * 12;
    if (ratio <= 1.0) return 60 + (1.0 - ratio) / 0.3 * 25;
    if (ratio <= 1.3) return 40 + (1.3 - ratio) / 0.3 * 20;
    if (ratio <= 1.6) return 15 + (1.6 - ratio) / 0.3 * 25;
    return 5;
  }

  static String _buildReason({
    required PredictionInput input,
    required CollegeModel college,
    required CourseModel course,
    required double probability,
    required bool usedHomeQuota,
    required bool overBudget,
  }) {
    final exam = ExamSeedData.byId(input.examId);
    final metric = input.examRank != null
        ? 'a ${exam.shortName} rank of ${_formatNumber(input.examRank!)}'
        : 'a ${exam.shortName} score of ${input.examScore}';
    final quotaNote = usedHomeQuota ? ', your home state quota' : '';

    final buffer = StringBuffer(
      'You have $metric. Based on previous years\' cutoffs, your '
      '${input.category.label} category$quotaNote and preferred course, you '
      'have a ${probability.round()}% chance of admission to '
      '${college.name} (${course.shortName}).',
    );
    if (overBudget) {
      buffer.write(' Note: this college\'s fees are above your stated budget.');
    }
    return buffer.toString();
  }

  static String _formatNumber(int n) {
    final chars = n.toString().split('');
    final result = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && (chars.length - i) % 3 == 0) result.write(',');
      result.write(chars[i]);
    }
    return result.toString();
  }
}
