import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssessmentState {
  final int currentQuestionIndex;
  final Map<String, String> answers;

  const AssessmentState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
  });

  AssessmentState copyWith({
    int? currentQuestionIndex,
    Map<String, String>? answers,
  }) {
    return AssessmentState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
    );
  }
}

class AssessmentController extends StateNotifier<AssessmentState> {
  AssessmentController() : super(const AssessmentState());

  void answerQuestion(
    String questionId,
    String answer,
  ) {
    final updatedAnswers = Map<String, String>.from(state.answers);

    updatedAnswers[questionId] = answer;

    state = state.copyWith(
      answers: updatedAnswers,
    );
  }

  void nextQuestion() {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
    );
  }

  void previousQuestion() {
    if (state.currentQuestionIndex == 0) return;
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex - 1,
    );
  }

  void reset() {
    state = const AssessmentState();
  }
}

final assessmentControllerProvider =
    StateNotifierProvider.autoDispose<AssessmentController, AssessmentState>(
  (ref) => AssessmentController(),
);
