import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';

/// Lightweight preference bag the AI Exam Finder score is computed against —
/// kept independent of `UserProfile` so this service has no dependency on
/// the profile feature.
class ExamMatchPreferences {
  final String? classLevel;
  final String? stream;
  final double? percentage;
  final String? careerGoal;
  final String? state;
  final String? preferredCourse;

  const ExamMatchPreferences({
    this.classLevel,
    this.stream,
    this.percentage,
    this.careerGoal,
    this.state,
    this.preferredCourse,
  });

  bool get isEmpty =>
      (classLevel == null || classLevel!.isEmpty) &&
      (stream == null || stream!.isEmpty) &&
      percentage == null &&
      (careerGoal == null || careerGoal!.isEmpty) &&
      (state == null || state!.isEmpty) &&
      (preferredCourse == null || preferredCourse!.isEmpty);
}

/// Scores how well an exam fits a student's stated Class/Stream/Marks/Career
/// Goal/State/Preferred Course. A transparent, rule-based heuristic (not a
/// trained model) — kept deliberately simple and explainable, matching the
/// rest of the app's "AI Mentor" style of guidance rather than a black-box
/// score. Mirrors `AiMatchService` (colleges) and `PredictionEngine`.
class ExamMatchService {
  ExamMatchService._();

  static Set<ExamCategory> _streamCategories(String rawStream) {
    final s = rawStream.toLowerCase();
    if (s.contains('pcb') || s.contains('biology') || s.contains('medical')) {
      return {
        ExamCategory.medical,
        ExamCategory.paramedical,
        ExamCategory.biotechnology,
        ExamCategory.science,
      };
    }
    if (s.contains('pcm') || s.contains('science')) {
      return {
        ExamCategory.engineering,
        ExamCategory.architecture,
        ExamCategory.defence,
        ExamCategory.science,
        ExamCategory.higherStudies,
      };
    }
    if (s.contains('commerce')) {
      return {
        ExamCategory.commerce,
        ExamCategory.management,
        ExamCategory.banking,
        ExamCategory.law,
      };
    }
    if (s.contains('art') || s.contains('humanities')) {
      return {
        ExamCategory.arts,
        ExamCategory.law,
        ExamCategory.government,
        ExamCategory.teaching,
        ExamCategory.design,
      };
    }
    return ExamCategory.values.toSet();
  }

  static double computeMatch(
    ExamProfileModel exam,
    ExamMatchPreferences prefs,
  ) {
    double score = 50;

    if (prefs.stream != null && prefs.stream!.isNotEmpty) {
      if (_streamCategories(prefs.stream!).contains(exam.category)) {
        score += 20;
      } else {
        score -= 10;
      }
    }
    if (prefs.careerGoal != null && prefs.careerGoal!.trim().isNotEmpty) {
      final goal = prefs.careerGoal!.toLowerCase();
      if (exam.careerOpportunities.any((c) => c.toLowerCase().contains(goal)) ||
          exam.fullName.toLowerCase().contains(goal)) {
        score += 15;
      }
    }
    if (prefs.preferredCourse != null &&
        prefs.preferredCourse!.trim().isNotEmpty) {
      final course = prefs.preferredCourse!.toLowerCase();
      final haystack =
          '${exam.fullName} ${exam.shortName} ${exam.subjects.join(' ')} '
                  '${exam.category.label} ${exam.eligibility}'
              .toLowerCase();
      if (haystack.contains(course)) score += 15;
    }
    if (prefs.state != null && prefs.state!.isNotEmpty) {
      if (exam.state == prefs.state) {
        score += 12;
      } else if (exam.state != null) {
        // A different state's exam is a poor fit — most state-level exams
        // require domicile.
        score -= 15;
      }
    }
    if (prefs.percentage != null) {
      if (prefs.percentage! >= 90) {
        score += 5;
      } else if (prefs.percentage! < 60 &&
          exam.difficulty == ExamDifficulty.veryHard) {
        score -= 8;
      }
    }
    if (prefs.classLevel != null && prefs.classLevel!.isNotEmpty) {
      final cl = prefs.classLevel!.toLowerCase();
      final elig = '${exam.eligibility} ${exam.educationalQualification}'
          .toLowerCase();
      if (cl.contains('12') && elig.contains('12th')) score += 10;
      if ((cl.contains('ug') || cl.contains('graduat')) &&
          (elig.contains('bachelor') || elig.contains('graduat'))) {
        score += 10;
      }
    }

    // Popular, well-established exams are a safer general recommendation —
    // a mild tie-breaker, not a dominant factor.
    score += (exam.popularityScore / 100 * 6).clamp(0, 6);

    return score.clamp(20, 99);
  }

  /// Top matches sorted by score — backs the AI Exam Finder results list.
  static List<ExamProfileModel> topMatches(
    List<ExamProfileModel> exams,
    ExamMatchPreferences prefs, {
    int limit = 15,
  }) {
    final scored = exams
        .map((e) => MapEntry(e, computeMatch(e, prefs)))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return scored.take(limit).map((e) => e.key).toList();
  }
}
