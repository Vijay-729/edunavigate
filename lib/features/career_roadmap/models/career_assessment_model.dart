/// One selectable option in a [CareerAssessmentQuestion] — its `tags` are
/// matched against [CareerRoadmapModel.tags] to score careers.
class AssessmentOption {
  final String label;
  final List<String> tags;
  const AssessmentOption({required this.label, required this.tags});
}

class CareerAssessmentQuestion {
  final String id;
  final String question;
  final List<AssessmentOption> options;
  const CareerAssessmentQuestion(
      {required this.id, required this.question, required this.options});
}
