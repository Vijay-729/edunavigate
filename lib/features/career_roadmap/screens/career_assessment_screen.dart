import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/career_assessment_questions.dart';
import '../models/career_assessment_model.dart';
import '../providers/career_roadmap_providers.dart';
import 'career_recommendation_result_screen.dart';

/// Quick 8-question career assessment (interests, subjects, skills, goals,
/// budget, location, work style, personality) driving [recommendedCareersProvider].
class CareerAssessmentScreen extends ConsumerStatefulWidget {
  const CareerAssessmentScreen({super.key});

  @override
  ConsumerState<CareerAssessmentScreen> createState() =>
      _CareerAssessmentScreenState();
}

class _CareerAssessmentScreenState
    extends ConsumerState<CareerAssessmentScreen> {
  int _index = 0;

  List<CareerAssessmentQuestion> get _questions =>
      CareerAssessmentQuestions.all;

  void _select(AssessmentOption option) {
    final question = _questions[_index];
    ref
        .read(careerAssessmentAnswersProvider.notifier)
        .answer(question.id, option.tags.toSet());
    if (_index < _questions.length - 1) {
      setState(() => _index++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
            builder: (_) => const CareerRecommendationResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];
    final progress = (_index + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Assessment'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text('Question ${_index + 1} of ${_questions.length}',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12.5)),
              const SizedBox(height: 24),
              Text(question.question,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      height: 1.3)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final option = question.options[i];
                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _select(option),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF102846),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(option.label,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.white38),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_index > 0)
                TextButton.icon(
                  onPressed: () => setState(() => _index--),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Previous question'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
