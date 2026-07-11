import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../data/auth_repository.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return showAppSnack(context, 'Enter your email address.');
    }
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      return showAppSnack(context, 'Enter a valid email address.');
    }

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
      if (!mounted) return;
      setState(() => _sent = true);
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
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white70),
                ),
              ),
              const Spacer(),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.mark_email_read_outlined,
                          size: 72, color: AppColors.accent),
                      const SizedBox(height: 20),
                      const Text(
                        'Reset Link Sent!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'A password reset link has been sent to ${_emailController.text.trim()}.\nCheck your inbox and follow the instructions.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Back to Login',
                  icon: Icons.login_rounded,
                  onPressed: () => context.pop(),
                ),
              ] else ...[
                const Icon(Icons.lock_reset_rounded,
                    size: 72, color: AppColors.accent),
                const SizedBox(height: 24),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No worries! Enter your email and we'll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 16, height: 1.55),
                ),
                const SizedBox(height: 40),
                AppTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Send Reset Link',
                  icon: Icons.send_rounded,
                  loading: _loading,
                  onPressed: _sendReset,
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
