/// An entrance exam referenced by one or more streams/careers. Cutoffs and
/// registration windows are realistic *sample* figures — always shown with a
/// note that students should confirm current details on the official site.
class StreamExam {
  const StreamExam({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.eligibility,
    required this.syllabusHighlights,
    required this.difficulty,
    required this.registration,
    required this.previousYearCutoffs,
    required this.preparationTips,
    required this.bestBooks,
    required this.timeline,
    this.officialNote,
  });

  final String id;
  final String name;
  final String fullName;
  final String description;
  final String eligibility;
  final List<String> syllabusHighlights;
  final String difficulty; // e.g. 'Moderate', 'High', 'Very High'
  final String registration;
  final String previousYearCutoffs;
  final List<String> preparationTips;
  final List<String> bestBooks;
  final String timeline;

  /// Optional correction/clarification (e.g. an exam that was discontinued
  /// or merged into another one) so students aren't misled by stale info.
  final String? officialNote;
}
