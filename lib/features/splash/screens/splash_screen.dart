import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), _route);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Signed-in users go to the dashboard dispatcher (which forwards to the
  /// correct stage or to onboarding if incomplete); everyone else starts at
  /// Welcome. The router redirect enforces this too, so both agree.
  void _route() {
    if (!mounted) return;
    final user = ref.read(firebaseAuthProvider).currentUser;
    context.go(user != null ? Routes.dashboard : Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/edunavigate_logo.png', width: 180),
                const SizedBox(height: 35),
                const Text(
                  'EduNavigate AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Know every path before choosing one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                const SizedBox(height: 60),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
