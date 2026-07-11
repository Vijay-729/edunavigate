import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';

import '../../features/onboarding/screens/basic_details_screen.dart';
import '../../features/onboarding/screens/profile_preview_screen.dart';
import '../../features/onboarding/screens/upload_photo_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';

import '../../features/splash/screens/splash_screen.dart';

import '../../features/assessment/screen/assessment_intro_screen.dart';
import '../../features/assessment/screen/assessment_question_screen.dart';
import '../../features/assessment/screen/assessment_result_screen.dart';
import '../../features/assessment/screen/congratulations_screen.dart';

import '../../features/dashboard/screens/dashboard_dispatcher.dart';
import '../../features/dashboard/screens/class_8_10_dashboard.dart';
import '../../features/dashboard/screens/class_11_dashboard.dart';
import '../../features/dashboard/screens/class_12_dashboard.dart';
import '../../features/dashboard/services/dashboard_router.dart';

import '../providers/firebase_providers.dart';

class Routes {
  Routes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  static const String photo = '/onboarding/photo';
  static const String details = '/onboarding/details';
  static const String preview = '/onboarding/preview';

  static const String assessmentIntro = '/assessment/intro';
  static const String assessmentQuestion = '/assessment/question';
  static const String assessmentResult = '/assessment/result';
  static const String congratulations = '/assessment/congratulations';

  static const String dashboard = '/dashboard';

  static String get class8to10Dashboard => DashboardRouter.class8to10Route;
  static String get class11Dashboard => DashboardRouter.class11Route;
  static String get class12Dashboard => DashboardRouter.class12Route;
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(firebaseAuthProvider).authStateChanges(),
    ),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      if (authState.isLoading) return null;

      final loggedIn = authState.asData?.value != null;
      final loc = state.matchedLocation;

      const authScreens = {
        Routes.welcome,
        Routes.login,
        Routes.signup,
        Routes.forgotPassword,
      };
      final isProtected = loc.startsWith('/onboarding') ||
          loc.startsWith('/assessment') ||
          loc.startsWith('/dashboard');

      if (!loggedIn && isProtected) return Routes.welcome;
      if (loggedIn && authScreens.contains(loc)) return Routes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.photo,
        builder: (context, state) => const UploadPhotoScreen(),
      ),
      GoRoute(
        path: Routes.details,
        builder: (context, state) => const BasicDetailsScreen(),
      ),
      GoRoute(
        path: Routes.preview,
        builder: (context, state) => const ProfilePreviewScreen(),
      ),
      GoRoute(
        path: Routes.assessmentIntro,
        builder: (context, state) => const AssessmentIntroScreen(),
      ),
      GoRoute(
        path: Routes.assessmentQuestion,
        builder: (context, state) => const AssessmentQuestionScreen(),
      ),
      GoRoute(
        path: Routes.assessmentResult,
        builder: (context, state) => const AssessmentResultScreen(),
      ),
      GoRoute(
        path: Routes.congratulations,
        builder: (context, state) => const CongratulationsScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashboardDispatcher(),
      ),
      GoRoute(
        path: DashboardRouter.class8to10Route,
        builder: (context, state) => const Class8to10Dashboard(),
      ),
      GoRoute(
        path: DashboardRouter.class11Route,
        builder: (context, state) => const Class11Dashboard(),
      ),
      GoRoute(
        path: DashboardRouter.class12Route,
        builder: (context, state) => const Class12Dashboard(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

/// Bridges a [Stream] to a [Listenable] so GoRouter re-evaluates `redirect`
/// whenever auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
