import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../provider/assessment_controller.dart';
import '../provider/assessment_providers.dart';

class AssessmentQuestionScreen extends ConsumerWidget {
  const AssessmentQuestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(assessmentQuestionsProvider);
    final state = ref.watch(assessmentControllerProvider);
    final controller = ref.read(assessmentControllerProvider.notifier);

    if (questions.isEmpty) {
      return const Scaffold(
        body: GradientBackground(
          child: Center(
            child: Text('No questions found',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final currentIndex =
        state.currentQuestionIndex.clamp(0, questions.length - 1);
    final question = questions[currentIndex];
    final selectedAnswer = state.answers[question.id];

    final progress = (currentIndex + 1) / questions.length;
    final isLastQuestion = currentIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Career Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: currentIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.previousQuestion,
              )
            : null,
      ),
      extendBodyBehindAppBar: true,
      // GradientBackground handles the status bar via SafeArea; the extra
      // kToolbarHeight padding clears the floating transparent AppBar.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: selectedAnswer == null
                  ? null
                  : () {
                      if (isLastQuestion) {
                        context.go(Routes.assessmentResult);
                      } else {
                        controller.nextQuestion();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isLastQuestion ? 'Finish Assessment 🎯' : 'Next Question →',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Question ${currentIndex + 1} of ${questions.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.psychology,
                        color: AppColors.accent, size: 42),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: question.options.length,
                  itemBuilder: (_, index) {
                    final option = question.options[index];
                    final isSelected = selectedAnswer == option;

                    return GestureDetector(
                      onTap: () =>
                          controller.answerQuestion(question.id, option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.08),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
