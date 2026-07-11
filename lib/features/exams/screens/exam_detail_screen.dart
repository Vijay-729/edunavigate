import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/services/pdf_report_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/stat_chip.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../explore/screens/place_card_widgets.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';
import '../providers/exam_providers.dart';

/// Full exam profile — overview through FAQs, with bookmark/share/download
/// actions and a "Ask AI Exam Finder" shortcut for follow-up questions.
class ExamDetailScreen extends ConsumerStatefulWidget {
  const ExamDetailScreen({super.key, required this.examId});

  final String examId;

  @override
  ConsumerState<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends ConsumerState<ExamDetailScreen> {
  bool _generatingPdf = false;

  @override
  Widget build(BuildContext context) {
    final exam = ref.watch(examByIdProvider(widget.examId));
    final savedIds =
        ref.watch(examBookmarkIdsProvider).asData?.value ?? const {};

    if (exam == null) {
      return const Scaffold(
          body: Center(
              child: Text('Exam not found',
                  style: TextStyle(color: Colors.white))));
    }

    final isSaved = savedIds.contains(exam.id);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(exam.shortName, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.accent : Colors.white),
            onPressed: () => ref
                .read(examBookmarkRepositoryProvider)
                .toggle(exam.id, isSaved),
          ),
          IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(exam)),
          IconButton(
            icon: _generatingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_outlined),
            onPressed: _generatingPdf ? null : () => _downloadPdf(exam),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _header(exam),
            const SizedBox(height: 20),
            _section(
                'Overview', Icons.info_outline, Text(exam.about, style: _body)),
            if (exam.subjects.isNotEmpty)
              _section(
                'Subjects',
                Icons.subject_outlined,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exam.subjects
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(s,
                                style: const TextStyle(
                                    color: AppColors.accent, fontSize: 12)),
                          ))
                      .toList(),
                ),
              ),
            _section('Eligibility', Icons.check_circle_outline,
                Text(exam.eligibility, style: _body)),
            _section('Age Limit', Icons.cake_outlined,
                Text(exam.ageLimit, style: _body)),
            _section('Educational Qualification', Icons.school_outlined,
                Text(exam.educationalQualification, style: _body)),
            if (exam.numberOfAttempts.isNotEmpty)
              _section('Number of Attempts', Icons.repeat_outlined,
                  Text(exam.numberOfAttempts, style: _body)),
            _section('Application Fees', Icons.currency_rupee,
                Text(exam.applicationFees, style: _body)),
            _section('Application Process', Icons.app_registration,
                Text(exam.applicationProcess, style: _body)),
            _section('Exam Pattern', Icons.quiz_outlined,
                _bulletList(exam.examPattern)),
            _section('Marking Scheme', Icons.rule_outlined,
                Text(exam.markingScheme, style: _body)),
            _section('Syllabus', Icons.menu_book_outlined,
                _bulletList(exam.syllabus)),
            _section('Preparation Strategy', Icons.lightbulb_outline,
                Text(exam.preparationStrategy, style: _body)),
            _section('Best Books', Icons.library_books_outlined,
                _bulletList(exam.bestBooks)),
            _section('Previous Year Papers', Icons.history_edu_outlined,
                Text(exam.previousYearPapersInfo, style: _body)),
            _section('Mock Tests', Icons.fact_check_outlined,
                Text(exam.mockTestsInfo, style: _body)),
            if (exam.expectedCutoff.isNotEmpty)
              _section('Expected Cutoff', Icons.insights_outlined,
                  Text(exam.expectedCutoff, style: _body)),
            _section('Previous Year Cutoffs', Icons.trending_down_outlined,
                _bulletList(exam.cutoffs)),
            _section('Result', Icons.emoji_events_outlined,
                Text(exam.resultInfo, style: _body)),
            _section('Counselling', Icons.support_agent_outlined,
                Text(exam.counsellingInfo, style: _body)),
            _section('Top Colleges Accepting', Icons.account_balance_outlined,
                _bulletList(exam.topCollegesAccepting)),
            _section('Career Opportunities', Icons.work_outline,
                _bulletList(exam.careerOpportunities)),
            _section(
              'FAQs',
              Icons.help_outline,
              Column(
                children: exam.faqs
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.question,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(f.answer, style: _muted),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            if (exam.officialWebsite.isNotEmpty)
              _section(
                'Official Website',
                Icons.language_outlined,
                OutlinedButton.icon(
                  onPressed: () => _openLink(exam.officialWebsite),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Visit Official Website'),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _askAssistant(context, exam),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ask the AI Exam Finder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _body =
      TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5);
  static const _muted =
      TextStyle(color: Colors.white54, fontSize: 12.5, height: 1.4);

  Widget _header(ExamProfileModel exam) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              exam.wikipediaTitle == null
                  ? Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(exam.category.icon,
                          color: AppColors.accent, size: 26),
                    )
                  : InstitutionLogoAvatar(
                      wikidataId: null,
                      wikipediaTitle: exam.wikipediaTitle,
                      fallbackIcon: exam.category.icon,
                      size: 52,
                    ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam.fullName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.25)),
                    const SizedBox(height: 4),
                    Text(exam.conductingBody,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatChip(
                  icon: Icons.speed_outlined,
                  label: exam.difficulty.label,
                  color: const Color(0xFFF59E0B)),
              StatChip(icon: Icons.laptop_outlined, label: exam.mode.label),
              StatChip(
                  icon: Icons.flag_outlined,
                  label: exam.applicationStatus.label,
                  color: const Color(0xFF22C55E)),
              if (exam.state != null)
                StatChip(icon: Icons.map_outlined, label: exam.state!),
              if (exam.duration.isNotEmpty)
                StatChip(icon: Icons.timer_outlined, label: exam.duration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, IconData icon, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle,
                          size: 5, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(child: Text(i, style: _body)),
                    ],
                  ),
                ))
            .toList(),
      );

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')));
    }
  }

  Future<void> _share(ExamProfileModel exam) async {
    final text =
        'EduNavigate AI — ${exam.fullName}\n\n${exam.about}\n\nOfficial website: ${exam.officialWebsite}';
    await ShareService.shareText(text, subject: exam.shortName);
  }

  Future<void> _downloadPdf(ExamProfileModel exam) async {
    setState(() => _generatingPdf = true);
    try {
      final file = await PdfReportService.generate(
        title: exam.shortName,
        subtitle: exam.fullName,
        fileName: 'exam_${exam.id}',
        sections: [
          PdfSection.text('Overview', exam.about),
          PdfSection.text('Eligibility', exam.eligibility),
          PdfSection.text('Application Process', exam.applicationProcess),
          PdfSection.list('Exam Pattern', exam.examPattern),
          PdfSection.list('Syllabus', exam.syllabus),
          PdfSection.text('Preparation Strategy', exam.preparationStrategy),
          PdfSection.list('Best Books', exam.bestBooks),
          if (exam.expectedCutoff.isNotEmpty)
            PdfSection.text('Expected Cutoff', exam.expectedCutoff),
          PdfSection.list('Previous Year Cutoffs', exam.cutoffs),
          PdfSection.list('Career Opportunities', exam.careerOpportunities),
          if (exam.duration.isNotEmpty || exam.numberOfAttempts.isNotEmpty)
            PdfSection.text(
              'Duration & Attempts',
              [
                if (exam.duration.isNotEmpty) 'Duration: ${exam.duration}',
                if (exam.numberOfAttempts.isNotEmpty)
                  'Attempts: ${exam.numberOfAttempts}',
              ].join('\n'),
            ),
        ],
      );
      if (mounted) {
        await ShareService.shareFile(file,
            text: '${exam.shortName} — Exam Guide');
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  void _askAssistant(BuildContext context, ExamProfileModel exam) {
    final profile = ref.read(currentProfileProvider).asData?.value;
    if (profile == null) return;
    showAiMentorSheet(context, profile,
        contextHint: 'the ${exam.shortName} (${exam.fullName}) entrance exam');
  }
}
