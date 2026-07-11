import 'course_model.dart';
import 'student_stream.dart';

enum ReservationCategory { general, obc, sc, st, ews, ph }

extension ReservationCategoryX on ReservationCategory {
  String get label {
    switch (this) {
      case ReservationCategory.general:
        return 'General';
      case ReservationCategory.obc:
        return 'OBC';
      case ReservationCategory.sc:
        return 'SC';
      case ReservationCategory.st:
        return 'ST';
      case ReservationCategory.ews:
        return 'EWS';
      case ReservationCategory.ph:
        return 'PwD';
    }
  }

  String get dataKey => name; // matches CutoffEntry.category values
}

enum PredictionTier { dream, target, safe }

extension PredictionTierX on PredictionTier {
  String get label {
    switch (this) {
      case PredictionTier.dream:
        return 'Dream Colleges';
      case PredictionTier.target:
        return 'Target Colleges';
      case PredictionTier.safe:
        return 'Safe Colleges';
    }
  }

  String get probabilityRangeLabel {
    switch (this) {
      case PredictionTier.dream:
        return '40–60%';
      case PredictionTier.target:
        return '60–85%';
      case PredictionTier.safe:
        return '85–99%';
    }
  }
}

/// Everything the predictor form collects before the student taps "Predict".
class PredictionInput {
  final StudentStream stream;
  final CourseCategory? preferredCourseCategory;
  final String? preferredState;
  final String? preferredCity;
  final ReservationCategory category;
  final String gender;
  final int? annualFamilyIncome;
  final int? budgetPerYear;
  final bool hostelRequired;
  final String examId;
  final int? examRank;
  final double? examScore;
  final double? class12Percentage;
  final String? homeState;

  const PredictionInput({
    required this.stream,
    this.preferredCourseCategory,
    this.preferredState,
    this.preferredCity,
    this.category = ReservationCategory.general,
    this.gender = 'Any',
    this.annualFamilyIncome,
    this.budgetPerYear,
    this.hostelRequired = false,
    required this.examId,
    this.examRank,
    this.examScore,
    this.class12Percentage,
    this.homeState,
  });

  bool get isReadyToPredict => examId.isNotEmpty && examRank != null;

  PredictionInput copyWith({
    StudentStream? stream,
    CourseCategory? preferredCourseCategory,
    bool clearPreferredCourseCategory = false,
    String? preferredState,
    bool clearPreferredState = false,
    String? preferredCity,
    ReservationCategory? category,
    String? gender,
    int? annualFamilyIncome,
    int? budgetPerYear,
    bool? hostelRequired,
    String? examId,
    int? examRank,
    double? examScore,
    double? class12Percentage,
    String? homeState,
  }) {
    return PredictionInput(
      stream: stream ?? this.stream,
      preferredCourseCategory: clearPreferredCourseCategory
          ? null
          : (preferredCourseCategory ?? this.preferredCourseCategory),
      preferredState:
          clearPreferredState ? null : (preferredState ?? this.preferredState),
      preferredCity: preferredCity ?? this.preferredCity,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      annualFamilyIncome: annualFamilyIncome ?? this.annualFamilyIncome,
      budgetPerYear: budgetPerYear ?? this.budgetPerYear,
      hostelRequired: hostelRequired ?? this.hostelRequired,
      examId: examId ?? this.examId,
      examRank: examRank ?? this.examRank,
      examScore: examScore ?? this.examScore,
      class12Percentage: class12Percentage ?? this.class12Percentage,
      homeState: homeState ?? this.homeState,
    );
  }
}

/// One predicted college+course outcome, ready to render as a card.
class PredictedCollege {
  final String collegeId;
  final String collegeName;
  final String courseId;
  final String courseName;
  final PredictionTier tier;
  final double probability;
  final int? expectedCutoffRank;
  final int? previousClosingRank;
  final int feesPerYear;
  final double averagePackageLpa;
  final bool hostelAvailable;
  final String aiReason;

  const PredictedCollege({
    required this.collegeId,
    required this.collegeName,
    required this.courseId,
    required this.courseName,
    required this.tier,
    required this.probability,
    this.expectedCutoffRank,
    this.previousClosingRank,
    required this.feesPerYear,
    required this.averagePackageLpa,
    required this.hostelAvailable,
    required this.aiReason,
  });
}

/// Full predictor output: the three tiers plus the input snapshot that
/// produced them, so a saved/shared report stays self-explanatory.
class PredictionResult {
  final PredictionInput input;
  final List<PredictedCollege> dreamColleges;
  final List<PredictedCollege> targetColleges;
  final List<PredictedCollege> safeColleges;
  final DateTime generatedAt;

  const PredictionResult({
    required this.input,
    required this.dreamColleges,
    required this.targetColleges,
    required this.safeColleges,
    required this.generatedAt,
  });

  bool get isEmpty =>
      dreamColleges.isEmpty && targetColleges.isEmpty && safeColleges.isEmpty;

  int get totalMatches =>
      dreamColleges.length + targetColleges.length + safeColleges.length;
}
