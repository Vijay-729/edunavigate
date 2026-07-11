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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty) {
      return showAppSnack(context, 'Please enter your full name.');
    }
    if (email.isEmpty) return showAppSnack(context, 'Please enter your email.');
    if (!email.contains('@') || !email.contains('.')) {
      return showAppSnack(context, 'Please enter a valid email address.');
    }
    if (password.length < 6) {
      return showAppSnack(context, 'Password must be at least 6 characters.');
    }
    if (password != confirm) {
      return showAppSnack(context, 'Passwords do not match.');
    }

    setState(() => _loading = true);
    try {
      final auth = ref.read(authRepositoryProvider);
      await auth.signUp(email: email, password: password);
      await auth.updateDisplayName(name);

      // Seed the onboarding draft so later screens read shared state.
      ref
          .read(onboardingControllerProvider.notifier)
          .setIdentity(name: name, email: email);

      if (!mounted) return;
      context.go(Routes.photo);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: size.width * 0.32,
                height: size.width * 0.32,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(36),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 40,
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
              const SizedBox(height: 28),
              const Text(
                'Create Your Account 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Join EduNavigate AI and start\nyour learning journey.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white60, fontSize: 17, height: 1.7),
              ),
              const SizedBox(height: 32),
              AppTextField(
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Email Address',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                  hint: 'Password', controller: _passwordController),
              const SizedBox(height: 16),
              AppPasswordField(
                hint: 'Confirm Password',
                controller: _confirmPasswordController,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                loading: _loading,
                onPressed: _onContinue,
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
