import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/theme/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    runApp(const ProviderScope(child: EduNavigateApp()));
  } catch (e, s) {
    debugPrint('FIREBASE INIT ERROR: $e');
    debugPrintStack(stackTrace: s);
    runApp(ProviderScope(child: _StartupErrorApp(error: e)));
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.splashBg,
        body: Padding(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded,
                    color: Colors.white70, size: 72),
                const SizedBox(height: 24),
                const Text(
                  'Could not connect to EduNavigate services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 15),
                ),
                const SizedBox(height: 20),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
