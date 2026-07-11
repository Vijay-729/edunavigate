import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/onboarding_controller.dart';

class UploadPhotoScreen extends ConsumerStatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  ConsumerState<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends ConsumerState<UploadPhotoScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          source == ImageSource.camera
              ? 'Could not access camera.'
              : 'Could not open gallery.',
        );
      }
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgBottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              _option(Icons.camera_alt_outlined, 'Take Photo', () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              }),
              _option(Icons.photo_library_outlined, 'Choose From Gallery', () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              }),
              _option(Icons.close, 'Cancel', () => Navigator.pop(context),
                  cancel: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(IconData icon, String label, VoidCallback onTap,
      {bool cancel = false}) {
    return ListTile(
      leading: Icon(icon, color: cancel ? Colors.white60 : AppColors.accent),
      title: Text(
        label,
        style: TextStyle(
          color: cancel ? Colors.white60 : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  void _continue() {
    if (_selectedImage == null) {
      return showAppSnack(context, 'Please upload a photo or tap Skip.');
    }
    _goNext();
  }

  void _goNext() {
    ref.read(onboardingControllerProvider.notifier).setPhoto(_selectedImage);
    context.push(Routes.details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 35,
                          spreadRadius: 2,
                        ),
                      ],
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Icon(Icons.person,
                            size: 90, color: Colors.white54)
                        : null,
                  ),
                  GestureDetector(
                    onTap: _showOptions,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Upload Your Smile 😊',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'A smiling photo helps us create\nyour personalized profile.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white60, fontSize: 17, height: 1.7),
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined,
                      color: Colors.white),
                  label: const Text(
                    'Choose From Gallery',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'Continue', onPressed: _continue),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _goNext,
                child: const Text(
                  'Skip for now',
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
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
