import 'package:flutter_test/flutter_test.dart';
import 'package:edu_navigate_ai/features/assessment/models/assessment_question.dart';
import 'package:edu_navigate_ai/features/assessment/service/assessment_scorer.dart';

void main() {
  const questions = [
    AssessmentQuestion(
      id: 'q1',
      question: 'Q1',
      options: ['Best', 'Mid', 'Worst'],
      category: 'technology',
    ),
    AssessmentQuestion(
      id: 'q2',
      question: 'Q2',
      options: ['Best', 'Mid', 'Worst'],
      category: 'creativity',
    ),
  ];

  group('AssessmentScorer', () {
    test('first option scores 1.0, last scores 0.0', () {
      final result = AssessmentScorer.score(questions, {
        'q1': 'Best',
        'q2': 'Worst',
      });
      final tech = result.ranked.firstWhere((c) => c.category == 'technology');
      final crea = result.ranked.firstWhere((c) => c.category == 'creativity');
      expect(tech.score, 1.0);
      expect(crea.score, 0.0);
    });

    test('ranks strongest category first', () {
      final result = AssessmentScorer.score(questions, {
        'q1': 'Mid',
        'q2': 'Best',
      });
      expect(result.ranked.first.category, 'creativity');
      expect(result.strengths.first, 'Creativity');
    });

    test('empty answers yield empty result', () {
      final result = AssessmentScorer.score(questions, {});
      expect(result.isEmpty, true);
    });

    test('produces recommendations from top categories', () {
      final result = AssessmentScorer.score(questions, {'q1': 'Best'});
      expect(result.recommendations, isNotEmpty);
    });
  });
}
