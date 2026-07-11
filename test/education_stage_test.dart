import 'package:flutter_test/flutter_test.dart';
import 'package:edu_navigate_ai/core/education/education_stage.dart';

void main() {
  EducationStage stage(String classOrYear, [String level = 'School Student']) =>
      EducationClassifier.classify(
        classOrYear: classOrYear,
        educationLevel: level,
      );

  group('EducationClassifier', () {
    test('maps school classes correctly', () {
      expect(stage('Class 9'), EducationStage.class8to10);
      expect(stage('Class 10'), EducationStage.class8to10);
      expect(stage('Class 11'), EducationStage.class11);
      expect(stage('Class 12'), EducationStage.class12);
    });

    test('class number takes priority over education level', () {
      expect(stage('Class 12', 'School Student'), EducationStage.class12);
    });

    test('falls back to class8to10 for non-school input', () {
      // The classifier only distinguishes the 3 school stages it routes
      // dashboards for — anything else (college years, blank input) defaults
      // to class8to10 rather than guessing.
      expect(stage('1st Year', 'Undergraduate'), EducationStage.class8to10);
      expect(stage('', ''), EducationStage.class8to10);
    });
  });
}
