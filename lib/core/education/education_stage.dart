/// The three school stages EduNavigate AI personalises for. A single
/// classifier maps a user's profile to one stage, and both the assessment and
/// the dashboard routing derive from it — so they can never disagree.
enum EducationStage {
  class8to10,
  class11,
  class12,
}

class EducationClassifier {
  EducationClassifier._();

  /// Classifies from the [classOrYear] string (e.g. "Class 10", "Class 12").
  static EducationStage classify({
    required String classOrYear,
    required String educationLevel,
  }) {
    final year = classOrYear.trim().toLowerCase();

    if (year.contains('12')) return EducationStage.class12;
    if (year.contains('11')) return EducationStage.class11;

    // Class 8, 9, 10 — or any unrecognized value defaults to this stage.
    return EducationStage.class8to10;
  }
}
