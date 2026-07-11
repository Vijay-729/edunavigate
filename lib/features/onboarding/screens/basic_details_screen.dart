import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/onboarding_controller.dart';

class BasicDetailsScreen extends ConsumerStatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  ConsumerState<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends ConsumerState<BasicDetailsScreen> {
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();
  final _streamController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender;
  String? _state;
  String? _classLevel;
  String? _careerGoal;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingControllerProvider);
    final displayName = ref.read(firebaseAuthProvider).currentUser?.displayName;
    _nameController.text =
        draft.name.isNotEmpty ? draft.name : (displayName ?? '');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _streamController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      initialDate: DateTime(2008),
    );
    if (picked != null) {
      _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  void _onContinue() {
    if (_nameController.text.trim().isEmpty) {
      return showAppSnack(context, 'Please enter your full name.');
    }
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      return showAppSnack(context, 'Please enter your phone number.');
    }
    if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      return showAppSnack(context, 'Enter a valid 10-digit phone number.');
    }
    if (_dobController.text.isEmpty) {
      return showAppSnack(context, 'Please select your date of birth.');
    }
    if (_gender == null) {
      return showAppSnack(context, 'Please select your gender.');
    }
    if (_state == null) {
      _scrollToBottom();
      return showAppSnack(context, 'Please select your state.');
    }
    if (_schoolController.text.trim().isEmpty) {
      _scrollToBottom();
      return showAppSnack(context, 'Please enter your school name.');
    }
    if (_classLevel == null) {
      _scrollToBottom();
      return showAppSnack(context, 'Please select your class.');
    }
    if (_careerGoal == null) {
      _scrollToBottom();
      return showAppSnack(context, 'Please select your career goal.');
    }

    final notifier = ref.read(onboardingControllerProvider.notifier);
    final email = ref.read(firebaseAuthProvider).currentUser?.email ?? '';
    notifier.setIdentity(name: _nameController.text.trim(), email: email);
    notifier.setBasicDetails(
      phone: phone,
      dob: _dobController.text,
      gender: _gender!,
      state: _state!,
      educationLevel: 'School Student',
      schoolOrCollege: _schoolController.text.trim(),
      classOrYear: _classLevel!,
      branch: _streamController.text.trim(),
      careerGoal: _careerGoal!,
    );
    context.push(Routes.preview);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Basic Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tell us a little about yourself.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 35),
              AppTextField(
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Phone Number',
                icon: Icons.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Date of Birth',
                icon: Icons.calendar_month,
                controller: _dobController,
                readOnly: true,
                onTap: _pickDob,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                value: _gender,
                hint: 'Gender',
                icon: Icons.person,
                items: AppOptions.genders,
                onChanged: (v) => setState(() => _gender = v),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                value: _state,
                hint: 'State / UT',
                icon: Icons.location_on,
                items: AppOptions.states,
                onChanged: (v) => setState(() => _state = v),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'School Name',
                icon: Icons.school_outlined,
                controller: _schoolController,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                value: _classLevel,
                hint: 'Class',
                icon: Icons.menu_book,
                items: AppOptions.schoolClasses,
                onChanged: (v) => setState(() => _classLevel = v),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Stream (e.g. PCM, PCB, Commerce) — optional',
                icon: Icons.account_tree,
                controller: _streamController,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                value: _careerGoal,
                hint: 'Career Goal',
                icon: Icons.flag,
                items: AppOptions.careerGoals,
                onChanged: (v) => setState(() => _careerGoal = v),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
