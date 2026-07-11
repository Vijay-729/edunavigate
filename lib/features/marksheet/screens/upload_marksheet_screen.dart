import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../../ai/services/gemini_service.dart';

class UploadMarksheetScreen extends ConsumerStatefulWidget {
  const UploadMarksheetScreen({super.key});

  @override
  ConsumerState<UploadMarksheetScreen> createState() =>
      _UploadMarksheetScreenState();
}

class _UploadMarksheetScreenState extends ConsumerState<UploadMarksheetScreen> {
  Uint8List? _imageBytes;
  String? _imageName;
  bool _analyzing = false;
  String? _analysisResult;
  String? _errorMessage;

  static const _analysisPrompt = '''
You are an AI academic advisor analyzing a student's marksheet from India.

Please extract and analyze the following:
1. Student name (if visible)
2. Class/Grade and academic year
3. Subject-wise marks (Subject | Marks Obtained | Maximum Marks | Percentage)
4. Overall percentage or CGPA
5. Performance summary:
   - Strongest subjects (scoring above 80%)
   - Subjects needing improvement (scoring below 60%)
6. Personalized recommendations for improvement
7. Career streams well-suited based on these marks

Keep the tone encouraging and constructive. Format clearly with sections.
If the image is not a marksheet, say so politely.
''';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = file.name;
        _analysisResult = null;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Failed to pick image: $e');
    }
  }

  Future<void> _analyze() async {
    if (_imageBytes == null) return;

    final gemini = ref.read(geminiServiceProvider);

    if (!gemini.isConfigured) {
      setState(() {
        _errorMessage = 'AI analysis requires a Gemini API key.\n'
            'Launch with:\n'
            'flutter run --dart-define-from-file=env.json';
      });
      return;
    }

    setState(() {
      _analyzing = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final result = await gemini.analyzeImage(_imageBytes!, _analysisPrompt);
      setState(() => _analysisResult = result);
    } catch (e) {
      setState(() => _errorMessage = 'Analysis failed: $e');
    } finally {
      setState(() => _analyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gemini = ref.watch(geminiServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Marksheet Analysis'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IntroCard(aiConfigured: gemini.isConfigured),
              const SizedBox(height: 20),
              if (_imageBytes == null) ...[
                _PickerButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take a Photo',
                  subtitle: 'Best for physical marksheets',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(height: 12),
                _PickerButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose from Gallery',
                  subtitle: 'JPG, PNG files only',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ] else ...[
                _ImagePreview(
                  bytes: _imageBytes!,
                  name: _imageName ?? 'marksheet',
                  onClear: () => setState(() {
                    _imageBytes = null;
                    _analysisResult = null;
                    _errorMessage = null;
                  }),
                ),
                const SizedBox(height: 20),
                if (_analysisResult == null && !_analyzing) ...[
                  PrimaryButton(
                    label: 'Analyse with AI',
                    icon: Icons.auto_awesome_rounded,
                    loading: _analyzing,
                    onPressed: _analyze,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => setState(() {
                      _imageBytes = null;
                      _analysisResult = null;
                    }),
                    child: const Text(
                      'Choose a different image',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
                if (_analyzing)
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 14),
                        Text(
                          'AI is analysing your marksheet…',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                _ErrorCard(message: _errorMessage!),
              ],
              if (_analysisResult != null) ...[
                const SizedBox(height: 20),
                _AnalysisResultCard(result: _analysisResult!),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Analyse Another',
                  icon: Icons.refresh_rounded,
                  onPressed: () => setState(() {
                    _imageBytes = null;
                    _analysisResult = null;
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.aiConfigured});

  final bool aiConfigured;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.accent.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.document_scanner_rounded,
                  color: AppColors.accent, size: 24),
              SizedBox(width: 10),
              Text(
                'AI Marksheet Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Upload your marksheet photo and get instant AI insights — '
            'subject-wise performance, strengths, improvement areas, and '
            'career stream recommendations.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
          ),
          if (!aiConfigured) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI key not configured. Upload will work but analysis requires --dart-define-from-file=env.json.',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview(
      {required this.bytes, required this.name, required this.onClear});

  final Uint8List bytes;
  final String name;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.image_outlined, color: Colors.white54, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, color: Colors.white38, size: 20),
              tooltip: 'Remove',
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            bytes,
            width: double.infinity,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ],
    );
  }
}

class _AnalysisResultCard extends StatelessWidget {
  const _AnalysisResultCard({required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text(
                'AI Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            result,
            style: const TextStyle(
                color: Colors.white70, fontSize: 14, height: 1.65),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.redAccent, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
