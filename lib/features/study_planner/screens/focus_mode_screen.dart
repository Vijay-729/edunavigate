import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/study_task_repository.dart';
import '../models/study_task.dart';
import '../providers/study_planner_providers.dart';
import 'planner_helpers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Focus Mode Screen
// ─────────────────────────────────────────────────────────────────────────────

class FocusModeScreen extends ConsumerStatefulWidget {
  const FocusModeScreen({
    super.key,
    required this.task,
    required this.uid,
  });

  final StudyTask task;
  final String uid;

  @override
  ConsumerState<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends ConsumerState<FocusModeScreen>
    with TickerProviderStateMixin {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _ticker;
  bool _isPaused = false;
  bool _showCelebration = false;

  late final AnimationController _celebrationCtrl;
  late final AnimationController _timerPulseCtrl;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.task.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;

    _celebrationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _timerPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          final elapsed = _totalSeconds - _remainingSeconds;
          ref.read(activeSessionElapsedSecondsProvider.notifier).state =
              elapsed;
        } else {
          _ticker?.cancel();
          _onTimerComplete();
        }
      });
    });
  }

  void _pause() {
    HapticFeedback.mediumImpact();
    _ticker?.cancel();
    _timerPulseCtrl.stop();
    setState(() => _isPaused = true);
  }

  void _resume() {
    HapticFeedback.mediumImpact();
    _timerPulseCtrl.repeat(reverse: true);
    setState(() => _isPaused = false);
    _startTicker();
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    _ticker?.cancel();
    await _completeTask();
    if (mounted) Navigator.of(context).pop();
  }

  void _onTimerComplete() {
    HapticFeedback.heavyImpact();
    _timerPulseCtrl.stop();
    setState(() => _showCelebration = true);
    _celebrationCtrl.forward();

    // Mark task complete after a short delay so the animation is visible
    Future.delayed(const Duration(milliseconds: 400), () async {
      await _completeTask();
    });

    // Auto-dismiss celebration after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _completeTask() async {
    ref.read(activeSessionElapsedSecondsProvider.notifier).state = 0;
    if (!widget.task.isCompleted) {
      await ref
          .read(studyTaskRepositoryProvider)
          .toggleComplete(widget.uid, widget.task);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    // Reset active session on any exit (back press, etc.)
    Future.microtask(() {
      if (ref.context.mounted) {
        ref.read(activeSessionElapsedSecondsProvider.notifier).state = 0;
      }
    });
    _celebrationCtrl.dispose();
    _timerPulseCtrl.dispose();
    super.dispose();
  }

  String get _timeString {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progressRatio =>
      _totalSeconds == 0 ? 0 : 1 - (_remainingSeconds / _totalSeconds);

  @override
  Widget build(BuildContext context) {
    final color = subjectColor(widget.task.subject);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final exit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF0D1F3C),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Leave Focus Mode?',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            content: const Text(
              'Your timer progress will be lost. Session will not be marked complete.',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Stay',
                    style: TextStyle(color: AppColors.accent)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Leave',
                    style: TextStyle(color: Color(0xFFEF4444))),
              ),
            ],
          ),
        );
        if (exit == true && context.mounted) {
          _ticker?.cancel();
          ref.read(activeSessionElapsedSecondsProvider.notifier).state = 0;
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgTop,
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(gradient: AppColors.bgGradient),
            ),
            // Color glow behind timer
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _timerPulseCtrl,
                  builder: (_, __) => Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        color.withValues(
                            alpha: 0.12 + _timerPulseCtrl.value * 0.06),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // ── Top bar ───────────────────────────────────────────────
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white70),
                          onPressed: () async {
                            final exit = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF0D1F3C),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text('Leave Focus Mode?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                                content: const Text(
                                  'Your timer progress will be lost.',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 13),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Stay',
                                        style:
                                            TextStyle(color: AppColors.accent)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Leave',
                                        style: TextStyle(
                                            color: Color(0xFFEF4444))),
                                  ),
                                ],
                              ),
                            );
                            if (exit == true && context.mounted) {
                              _ticker?.cancel();
                              ref
                                  .read(activeSessionElapsedSecondsProvider
                                      .notifier)
                                  .state = 0;
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Focus Mode',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Subject & Chapter ─────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: color.withValues(alpha: 0.30)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(subjectIcon(widget.task.subject),
                                  color: color, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                widget.task.subject,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.task.goal,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),

                        // ── Circular progress + timer ─────────────────────
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Track
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 10,
                                  color: Colors.white.withValues(alpha: 0.06),
                                ),
                              ),
                              // Progress arc
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: _progressRatio),
                                duration: const Duration(milliseconds: 600),
                                builder: (_, v, __) => SizedBox.expand(
                                  child: CircularProgressIndicator(
                                    value: v,
                                    strokeWidth: 10,
                                    strokeCap: StrokeCap.round,
                                    color: color,
                                  ),
                                ),
                              ),
                              // Timer text
                              AnimatedBuilder(
                                animation: _timerPulseCtrl,
                                builder: (_, __) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _timeString,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                            alpha: _isPaused
                                                ? 0.4 +
                                                    _timerPulseCtrl.value * 0.5
                                                : 1.0),
                                        fontSize: 52,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures()
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _isPaused ? 'Paused' : 'Remaining',
                                      style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),

                        // ── Elapsed bar ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: _progressRatio.clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.08),
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatMinutes(
                                        (_totalSeconds - _remainingSeconds) ~/
                                            60),
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 11),
                                  ),
                                  Text(
                                    formatMinutes(widget.task.durationMinutes),
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ── Buttons ────────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            children: [
                              // Pause / Resume
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: color.withValues(alpha: 0.5)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    foregroundColor: color,
                                  ),
                                  onPressed: _isPaused ? _resume : _pause,
                                  icon: Icon(
                                    _isPaused
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause_rounded,
                                    size: 20,
                                  ),
                                  label: Text(
                                    _isPaused ? 'Resume' : 'Pause',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Finish early
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  onPressed: _finish,
                                  icon: const Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 20,
                                      color: Colors.white),
                                  label: const Text(
                                    'Finish',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Celebration Overlay ────────────────────────────────────────
            if (_showCelebration)
              _CelebrationOverlay(controller: _celebrationCtrl),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Celebration Overlay
// ─────────────────────────────────────────────────────────────────────────────

const _kCelebrationMessages = [
  '🎉 Great Job!',
  '👏 Amazing Consistency!',
  '📚 Keep Going!',
  '🔥 One More Session Done!',
  '⭐ You\'re On Fire!',
];

class _CelebrationOverlay extends StatelessWidget {
  const _CelebrationOverlay({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final message = _kCelebrationMessages[
        DateTime.now().millisecond % _kCelebrationMessages.length];

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A5F), Color(0xFF0D1F3C)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.40), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✅', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Session Complete!',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
