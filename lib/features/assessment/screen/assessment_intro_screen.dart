import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';

class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.psychology,
                    color: AppColors.accent, size: 38),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Career Assessment 🚀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'A quick set of questions tailored to your class helps us '
                'understand you and personalize your dashboard.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const _Point(text: 'Your interests & strengths'),
              const _Point(text: 'Your preferred learning style'),
              const _Point(text: 'Your career direction'),
              const _Point(text: 'Personalized recommendations'),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.schedule, color: Colors.white54, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Takes about 3 minutes',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Start Assessment',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(Routes.assessmentQuestion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
