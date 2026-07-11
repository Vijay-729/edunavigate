import '../../../core/education/education_stage.dart';
import '../models/assessment_type.dart';

/// Maps an [EducationStage] to the matching [AssessmentType]. Stage is derived
/// once via [EducationClassifier] so assessment and dashboard stay in sync.
class AssessmentRouter {
  AssessmentRouter._();

  static AssessmentType fromStage(EducationStage stage) {
    switch (stage) {
      case EducationStage.class8to10:
        return AssessmentType.class8to10;
      case EducationStage.class11:
        return AssessmentType.class11;
      case EducationStage.class12:
        return AssessmentType.class12;
    }
  }

  static AssessmentType getType({
    required String classOrYear,
    required String educationLevel,
  }) {
    return fromStage(EducationClassifier.classify(
      classOrYear: classOrYear,
      educationLevel: educationLevel,
    ));
  }
}
