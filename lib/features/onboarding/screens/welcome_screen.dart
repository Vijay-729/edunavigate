import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: size.width * 0.42,
                height: size.width * 0.42,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.white.withValues(alpha: 0.04),
                    ],
                  ),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.18),
                      blurRadius: 35,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/images/edunavigate_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              const Text(
                'Navigate Your Future',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: size.height * 0.018),
              const Text(
                'Know every path before choosing one.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
              SizedBox(height: size.height * 0.045),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: const Column(
                      children: [
                        _FeatureTile(
                          icon: Icons.track_changes,
                          title: 'Personalized Career Guidance',
                        ),
                        SizedBox(height: 22),
                        _FeatureTile(
                          icon: Icons.school,
                          title: 'Exams, Colleges & Opportunities',
                        ),
                        SizedBox(height: 22),
                        _FeatureTile(
                          icon: Icons.smart_toy,
                          title: 'AI Mentor For Every Stage',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Get Started',
                icon: Icons.arrow_forward,
                onPressed: () => context.push(Routes.signup),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () => context.push(Routes.login),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.accent, size: 26),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
