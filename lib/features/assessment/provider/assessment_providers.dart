import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/services/gemini_service.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/question_bank.dart';
import '../models/assessment_question.dart';
import '../models/assessment_type.dart';
import '../service/assessment_router.dart';
import '../service/assessment_scorer.dart';
import 'assessment_controller.dart';

/// Assessment type for the signed-in student, derived from their saved profile.
/// Falls back to the school assessment while the profile is still loading.
final assessmentTypeProvider = Provider<AssessmentType>((ref) {
  final profile = ref.watch(currentProfileProvider).asData?.value;
  if (profile == null) return AssessmentType.class8to10;
  return AssessmentRouter.getType(
    classOrYear: profile.classOrYear,
    educationLevel: profile.educationLevel,
  );
});

/// The question set for the current student's stage, capped at 10 questions
/// to keep the assessment short (spec §: 7–10 questions).
final assessmentQuestionsProvider = Provider<List<AssessmentQuestion>>((ref) {
  final all = QuestionBank.getQuestions(ref.watch(assessmentTypeProvider));
  return all.take(10).toList();
});

/// The scored result computed from the answers collected so far.
final assessmentResultProvider = Provider<AssessmentResult>((ref) {
  final questions = ref.watch(assessmentQuestionsProvider);
  final answers = ref.watch(assessmentControllerProvider).answers;
  return AssessmentScorer.score(questions, answers);
});

/// Optional AI-generated insight shown on the result screen. Returns `null`
/// when Gemini is not configured or the call fails, so the UI hides it
/// gracefully rather than erroring.
final assessmentAiInsightProvider =
    FutureProvider.autoDispose<String?>((ref) async {
  final gemini = ref.watch(geminiServiceProvider);
  if (!gemini.isConfigured) return null;

  final result = ref.watch(assessmentResultProvider);
  if (result.isEmpty) return null;

  final profile = ref.watch(currentProfileProvider).asData?.value;
  final prompt =
      'A ${profile?.classOrYear ?? 'school'} student in India completed a '
      'career assessment. Their strongest areas are: '
      '${result.strengths.join(', ')}. Their stated goal is '
      '"${profile?.careerGoal ?? 'undecided'}". In 3 short, encouraging '
      'sentences, explain what these strengths suggest and one concrete next '
      'step.';
  try {
    final text = await gemini.ask(prompt);
    return text.isEmpty ? null : text;
  } catch (_) {
    return null;
  }
});
