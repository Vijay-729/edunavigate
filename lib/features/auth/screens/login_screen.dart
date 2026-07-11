import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../../onboarding/providers/onboarding_controller.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return showAppSnack(context, 'Enter your email and password.');
    }

    setState(() => _loading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      if (!mounted) return;
      // Clear any stale onboarding draft from a previous session.
      ref.read(onboardingControllerProvider.notifier).reset();
      context.go(Routes.dashboard);
    } on AuthException catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } catch (_) {
      if (mounted) showAppSnack(context, 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: size.height - kToolbarHeight - 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: size.width * 0.30,
                  height: size.width * 0.30,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white.withValues(alpha: 0.06),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.10)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 32,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      'assets/images/edunavigate_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in to continue your learning journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 40),
                AppTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppPasswordField(
                    hint: 'Password', controller: _passwordController),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(Routes.forgotPassword),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: 'Login',
                  icon: Icons.arrow_forward_rounded,
                  loading: _loading,
                  onPressed: _onLogin,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white60, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () => context.go(Routes.signup),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
