import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../provider/assessment_providers.dart';
import '../service/assessment_scorer.dart';

class CongratulationsScreen extends ConsumerStatefulWidget {
  const CongratulationsScreen({super.key});

  @override
  ConsumerState<CongratulationsScreen> createState() =>
      _CongratulationsScreenState();
}

class _CongratulationsScreenState extends ConsumerState<CongratulationsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _trophyController;
  late final AnimationController _fadeController;
  late final AnimationController _slideController;

  late final Animation<double> _trophyScale;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _trophyScale = CurvedAnimation(
      parent: _trophyController,
      curve: Curves.elasticOut,
    );
    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Staggered entry
    _trophyController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(assessmentResultProvider);
    final topStrengths = result.ranked
        .take(3)
        .map((c) => AssessmentScorer.label(c.category))
        .toList();

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            children: [
              const SizedBox(height: 32),
              ScaleTransition(
                scale: _trophyScale,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.45),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  children: [
                    const Text(
                      'Assessment Complete!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You have taken the first step towards\nyour ideal career path.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              SlideTransition(
                position: _slideUp,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (topStrengths.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.auto_awesome_rounded,
                                      color: AppColors.accent, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Your Top Strengths',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: topStrengths
                                    .asMap()
                                    .entries
                                    .map((e) => _StrengthChip(
                                          label: e.value,
                                          rank: e.key + 1,
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      _InfoRow(
                        icon: Icons.insights_rounded,
                        color: AppColors.accent,
                        text:
                            'Your personalised dashboard is ready with resources matched to your profile.',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.school_rounded,
                        color: const Color(0xFF22C55E),
                        text:
                            'Explore scholarships, career paths, and AI-guided study plans.',
                      ),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        label: 'Start My Journey',
                        icon: Icons.rocket_launch_rounded,
                        onPressed: () => context.go(Routes.dashboard),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthChip extends StatelessWidget {
  const _StrengthChip({required this.label, required this.rank});

  final String label;
  final int rank;

  static const _rankColors = [
    Color(0xFFFFD700),
    Color(0xFFE2E8F0),
    Color(0xFFCD7F32),
  ];

  @override
  Widget build(BuildContext context) {
    final color = rank <= 3 ? _rankColors[rank - 1] : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$rank',
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
