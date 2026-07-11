import '../models/assessment_question.dart';

/// A scored interest/aptitude category, normalized 0..1.
class CategoryScore {
  final String category;
  final double score;

  const CategoryScore({required this.category, required this.score});

  int get percent => (score.clamp(0.0, 1.0) * 100).round();
}

/// The computed outcome of a completed assessment.
class AssessmentResult {
  final List<CategoryScore> ranked; // highest first
  final List<String> strengths; // display labels of top categories
  final List<String> recommendations;
  final String summary;

  const AssessmentResult({
    required this.ranked,
    required this.strengths,
    required this.recommendations,
    required this.summary,
  });

  bool get isEmpty => ranked.isEmpty;
}

/// Scores assessment answers. Options in the question bank are authored
/// strongest→weakest, so an answer's weight is derived from its position:
/// the first option = 1.0, the last = 0.0. Category scores are the mean weight
/// of answers in that category.
class AssessmentScorer {
  AssessmentScorer._();

  /// Display labels for category keys used in the question bank.
  static const Map<String, String> categoryLabels = {
    'mathematics': 'Mathematics',
    'science': 'Science',
    'technology': 'Technology',
    'coding': 'Coding & Software',
    'creativity': 'Creativity',
    'leadership': 'Leadership',
    'communication': 'Communication',
    'problem_solving': 'Problem Solving',
    'entrepreneurship': 'Entrepreneurship',
    'teamwork': 'Teamwork',
    'commerce': 'Commerce & Finance',
    'humanities': 'Humanities',
    'research': 'Research',
    'medical': 'Medical & Life Sciences',
    'education': 'Academic Planning',
    'career': 'Career Clarity',
  };

  /// Career suggestions seeded by a strong category.
  static const Map<String, List<String>> _categoryCareers = {
    'mathematics': ['Engineering (JEE)', 'Data Science', 'Actuarial Science'],
    'science': ['Research Science', 'Biotechnology', 'Engineering'],
    'technology': ['Computer Science', 'AI / ML Engineering', 'Robotics'],
    'coding': ['Software Engineering', 'App Development', 'Competitive Coding'],
    'creativity': ['UI/UX Design', 'Architecture', 'Media & Design'],
    'leadership': [
      'Management (BBA/MBA)',
      'Civil Services',
      'Entrepreneurship'
    ],
    'communication': ['Law', 'Journalism', 'Public Relations'],
    'problem_solving': ['Engineering', 'Consulting', 'Data Analytics'],
    'entrepreneurship': ['Startup Founder', 'Business Management', 'Product'],
    'teamwork': ['Project Management', 'Operations', 'Healthcare Teams'],
    'commerce': ['Chartered Accountancy', 'Finance', 'Economics'],
    'humanities': ['Civil Services', 'Psychology', 'Political Science'],
    'research': ['Research Scientist', 'BS-MS / PhD', 'Academia'],
    'medical': ['Medicine (NEET)', 'Pharmacy', 'Biotechnology'],
    'education': ['Higher Studies', 'Teaching', 'Academic Research'],
    'career': ['Career Counselling', 'Skill Certification', 'Internships'],
  };

  static String label(String category) =>
      categoryLabels[category] ?? _titleCase(category);

  static AssessmentResult score(
    List<AssessmentQuestion> questions,
    Map<String, String> answers,
  ) {
    final sums = <String, double>{};
    final counts = <String, int>{};

    for (final q in questions) {
      final answer = answers[q.id];
      if (answer == null) continue;
      final index = q.options.indexOf(answer);
      if (index < 0) continue;
      final divisor = (q.options.length - 1);
      final weight = divisor == 0 ? 1.0 : 1.0 - (index / divisor);
      sums[q.category] = (sums[q.category] ?? 0) + weight;
      counts[q.category] = (counts[q.category] ?? 0) + 1;
    }

    final ranked = <CategoryScore>[];
    sums.forEach((category, total) {
      final n = counts[category] ?? 1;
      ranked.add(CategoryScore(category: category, score: total / n));
    });
    ranked.sort((a, b) => b.score.compareTo(a.score));

    if (ranked.isEmpty) {
      return const AssessmentResult(
        ranked: [],
        strengths: [],
        recommendations: [],
        summary: 'Complete the assessment to see your personalized result.',
      );
    }

    final top = ranked.take(3).toList();
    final strengths = top.map((c) => label(c.category)).toList();

    final recommendations = <String>{};
    for (final c in top) {
      recommendations.addAll(_categoryCareers[c.category] ?? const []);
    }

    final summary =
        'Your strongest areas are ${strengths.join(', ')}. These point toward '
        'careers where ${strengths.first.toLowerCase()} is central. Explore the '
        'recommended paths below and ask your AI Mentor to go deeper.';

    return AssessmentResult(
      ranked: ranked,
      strengths: strengths,
      recommendations: recommendations.take(6).toList(),
      summary: summary,
    );
  }

  static String _titleCase(String s) => s
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
