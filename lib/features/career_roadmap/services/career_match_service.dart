import '../models/career_roadmap_model.dart';

/// Scores careers by how many of the student's selected assessment tags
/// overlap with the career's own tags — a transparent, explainable ranking
/// rather than a black-box model (consistent with the rest of the app's
/// rule-based "AI match" style).
class CareerMatchService {
  CareerMatchService._();

  static double computeMatch(
      CareerRoadmapModel career, Set<String> selectedTags) {
    if (selectedTags.isEmpty) return 50;
    final overlap = career.tags.where(selectedTags.contains).length;
    final ratio = overlap / career.tags.length.clamp(1, 999);
    final score = 45 + ratio * 55;
    return score.clamp(40, 99);
  }

  static List<CareerRoadmapModel> rank(
      List<CareerRoadmapModel> careers, Set<String> selectedTags) {
    final sorted = List<CareerRoadmapModel>.from(careers)
      ..sort((a, b) => computeMatch(b, selectedTags)
          .compareTo(computeMatch(a, selectedTags)));
    return sorted;
  }
}
