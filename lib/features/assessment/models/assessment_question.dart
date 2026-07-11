class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;

  /// Used for scoring:
  /// pcm, pcb, commerce, humanities,
  /// coding, leadership, creativity etc.
  final String category;

  const AssessmentQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
  });
}
