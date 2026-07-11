import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/exam_profile_model.dart';
import '../providers/exam_providers.dart';
import '../services/exam_match_service.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

/// Structured AI Exam Finder — Class/Stream/Marks/Career Goal/State/
/// Preferred Course inputs (pre-filled from the student's profile where
/// possible) scored via [ExamMatchService] against the full exam database.
/// A transparent, explainable heuristic rather than a black-box "AI" claim
/// — the free-form Gemini chat (`showAiMentorSheet`) remains available
/// alongside this for open-ended questions.
class AiExamFinderScreen extends ConsumerStatefulWidget {
  const AiExamFinderScreen({super.key});

  @override
  ConsumerState<AiExamFinderScreen> createState() => _AiExamFinderScreenState();
}

class _AiExamFinderScreenState extends ConsumerState<AiExamFinderScreen> {
  late final TextEditingController _classController;
  late final TextEditingController _streamController;
  late final TextEditingController _percentageController;
  late final TextEditingController _careerGoalController;
  late final TextEditingController _stateController;
  final _courseController = TextEditingController();

  List<ExamProfileModel>? _results;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentProfileProvider).asData?.value;
    _classController = TextEditingController(text: profile?.classOrYear ?? '');
    _streamController = TextEditingController(text: profile?.branch ?? '');
    _percentageController = TextEditingController();
    _careerGoalController = TextEditingController(text: profile?.careerGoal ?? '');
    _stateController = TextEditingController(text: profile?.state ?? '');
  }

  @override
  void dispose() {
    _classController.dispose();
    _streamController.dispose();
    _percentageController.dispose();
    _careerGoalController.dispose();
    _stateController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _findExams() {
    final prefs = ExamMatchPreferences(
      classLevel: _classController.text.trim(),
      stream: _streamController.text.trim(),
      percentage: double.tryParse(_percentageController.text.trim()),
      careerGoal: _careerGoalController.text.trim(),
      state: _stateController.text.trim().isEmpty
          ? null
          : _stateController.text.trim(),
      preferredCourse: _courseController.text.trim(),
    );
    final allExams = ref.read(allExamsProvider);
    setState(() => _results = ExamMatchService.topMatches(allExams, prefs));
  }

  void _askAssistant() {
    final profile = ref.read(currentProfileProvider).asData?.value;
    if (profile == null) return;
    showAiMentorSheet(context, profile,
        contextHint: 'finding the right entrance exams');
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Exam Finder'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              'Tell us a bit about yourself and we\'ll rank the entrance '
              'exams that fit you best.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 13.5),
            ),
            const SizedBox(height: 18),
            AppTextField(
                hint: 'Class (e.g. Class 12, UG, PG)',
                icon: Icons.school_outlined,
                controller: _classController),
            const SizedBox(height: 12),
            AppTextField(
                hint: 'Stream (e.g. PCM, PCB, Commerce, Arts)',
                icon: Icons.category_outlined,
                controller: _streamController),
            const SizedBox(height: 12),
            AppTextField(
                hint: 'Marks / Percentage (optional)',
                icon: Icons.percent_outlined,
                keyboardType: TextInputType.number,
                controller: _percentageController),
            const SizedBox(height: 12),
            AppTextField(
                hint: 'Career Goal (e.g. Doctor, Engineer, CA)',
                icon: Icons.flag_outlined,
                controller: _careerGoalController),
            const SizedBox(height: 12),
            AppTextField(
                hint: 'State (for state-level exams)',
                icon: Icons.map_outlined,
                controller: _stateController),
            const SizedBox(height: 12),
            AppTextField(
                hint: 'Preferred Course (optional)',
                icon: Icons.menu_book_outlined,
                controller: _courseController),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Find My Exams',
              icon: Icons.auto_awesome,
              onPressed: _findExams,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _askAssistant,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Or ask the AI Mentor a free-form question'),
            ),
            if (results != null) ...[
              const SizedBox(height: 20),
              Text(
                results.isEmpty
                    ? 'No strong matches — try broadening your inputs.'
                    : 'Top matches for you',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...results.map((exam) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ExamCard(
                      exam: exam,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => ExamDetailScreen(examId: exam.id)),
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
