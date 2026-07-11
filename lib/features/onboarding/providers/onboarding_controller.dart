import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mutable draft of everything collected during onboarding, before it is
/// written to Firestore on the final "Finish Setup" step. Using a shared
/// provider (instead of passing data through constructors / go_router `extra`)
/// keeps deep links and back-navigation from losing the in-progress profile.
class OnboardingDraft {
  final String name;
  final String email;
  final File? photo;
  final String phone;
  final String dob;
  final String? gender;
  final String? state;
  final String? educationLevel;
  final String schoolOrCollege;
  final String? classOrYear;
  final String branch;
  final String? careerGoal;

  const OnboardingDraft({
    this.name = '',
    this.email = '',
    this.photo,
    this.phone = '',
    this.dob = '',
    this.gender,
    this.state,
    this.educationLevel,
    this.schoolOrCollege = '',
    this.classOrYear,
    this.branch = '',
    this.careerGoal,
  });

  OnboardingDraft copyWith({
    String? name,
    String? email,
    File? photo,
    String? phone,
    String? dob,
    String? gender,
    String? state,
    String? educationLevel,
    String? schoolOrCollege,
    String? classOrYear,
    String? branch,
    String? careerGoal,
  }) {
    return OnboardingDraft(
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      educationLevel: educationLevel ?? this.educationLevel,
      schoolOrCollege: schoolOrCollege ?? this.schoolOrCollege,
      classOrYear: classOrYear ?? this.classOrYear,
      branch: branch ?? this.branch,
      careerGoal: careerGoal ?? this.careerGoal,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingDraft> {
  OnboardingController() : super(const OnboardingDraft());

  void setIdentity({required String name, required String email}) {
    state = state.copyWith(name: name, email: email);
  }

  void setPhoto(File? photo) => state = state.copyWith(photo: photo);

  void setBasicDetails({
    required String phone,
    required String dob,
    required String gender,
    required String state,
    required String educationLevel,
    required String schoolOrCollege,
    required String classOrYear,
    required String branch,
    required String careerGoal,
  }) {
    this.state = this.state.copyWith(
          phone: phone,
          dob: dob,
          gender: gender,
          state: state,
          educationLevel: educationLevel,
          schoolOrCollege: schoolOrCollege,
          classOrYear: classOrYear,
          branch: branch,
          careerGoal: careerGoal,
        );
  }

  void reset() => state = const OnboardingDraft();
}

// Must NOT be autoDispose. UploadPhotoScreen and BasicDetailsScreen only use
// ref.read (never ref.watch) so the provider would have zero listeners between
// screens and Riverpod would dispose it before ProfilePreviewScreen can read
// the draft, wiping all entered data and showing "Not provided" everywhere.
// The controller is reset explicitly in profile_preview_screen after saving.
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingDraft>(
  (ref) => OnboardingController(),
);
