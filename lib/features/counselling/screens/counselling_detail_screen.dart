import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/services/pdf_report_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/simple_calendar.dart';
import '../../../core/widgets/vertical_timeline.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/counselling_model.dart';
import '../providers/counselling_providers.dart';

/// Full counselling programme profile — overview through FAQs, an
/// interactive round-by-round timeline, a dated calendar, an AI counselling
/// assistant, and bookmark/share/download actions.
class CounsellingDetailScreen extends ConsumerStatefulWidget {
  const CounsellingDetailScreen({super.key, required this.programId});

  final String programId;

  @override
  ConsumerState<CounsellingDetailScreen> createState() =>
      _CounsellingDetailScreenState();
}

class _CounsellingDetailScreenState
    extends ConsumerState<CounsellingDetailScreen> {
  bool _generatingPdf = false;

  @override
  Widget build(BuildContext context) {
    final program = ref.watch(counsellingByIdProvider(widget.programId));
    final savedIds =
        ref.watch(counsellingBookmarkIdsProvider).asData?.value ?? const {};

    if (program == null) {
      return const Scaffold(
          body: Center(
              child: Text('Programme not found',
                  style: TextStyle(color: Colors.white))));
    }

    final isSaved = savedIds.contains(program.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(program.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.accent : Colors.white),
            onPressed: () => ref
                .read(counsellingBookmarkRepositoryProvider)
                .toggle(program.id, isSaved),
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _share(program),
          ),
          IconButton(
            tooltip: 'Download PDF',
            icon: _generatingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_outlined),
            onPressed: _generatingPdf ? null : () => _downloadPdf(program),
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
            _header(program),
            const SizedBox(height: 20),
            _section('Overview', Icons.info_outline,
                Text(program.about, style: _body)),
            _section('Eligibility', Icons.check_circle_outline,
                Text(program.eligibility, style: _body)),
            _section('Registration', Icons.app_registration,
                Text(program.registrationProcess, style: _body)),
            _section('Choice Filling', Icons.list_alt_outlined,
                Text(program.choiceFillingInfo, style: _body)),
            _section('Choice Locking', Icons.lock_outline,
                Text(program.choiceLockingInfo, style: _body)),
            _section('Seat Allotment', Icons.event_seat_outlined,
                Text(program.seatAllotmentInfo, style: _body)),
            _section('Document Verification', Icons.fact_check_outlined,
                Text(program.documentVerificationInfo, style: _body)),
            _section('Reporting', Icons.how_to_reg_outlined,
                Text(program.reportingInfo, style: _body)),
            _section('Admission Confirmation', Icons.verified_outlined,
                Text(program.admissionConfirmationInfo, style: _body)),
            _section(
              'Interactive Timeline',
              Icons.timeline_outlined,
              VerticalTimeline(
                accentColor: AppColors.accent,
                nodes: program.timelineSteps
                    .map((s) => TimelineNode(
                        title: s.title, subtitle: s.subtitle, detail: s.detail))
                    .toList(),
              ),
            ),
            if (program.dateEvents.isNotEmpty)
              _section(
                'Calendar',
                Icons.calendar_month_outlined,
                SimpleCalendar(
                  initialMonth: program.nextUpcomingEvent?.date ??
                      program.dateEvents.first.date,
                  events: program.dateEvents
                      .map((e) => CalendarEvent(
                          date: e.date,
                          title: e.label,
                          color: AppColors.accent))
                      .toList(),
                ),
              ),
            _section('Important Instructions', Icons.info,
                _bulletList(program.importantInstructions)),
            _section('Reservation Rules', Icons.diversity_3_outlined,
                _bulletList(program.reservationRules)),
            if (program.seatMatrixNote.isNotEmpty)
              _section('Seat Matrix', Icons.grid_view_outlined,
                  Text(program.seatMatrixNote, style: _body)),
            _section('Previous Year Cutoffs', Icons.trending_down_outlined,
                _bulletList(program.previousYearCutoffs)),
            _section('Required Documents', Icons.description_outlined,
                _bulletList(program.requiredDocuments)),
            _section('Document Checklist', Icons.checklist_outlined,
                _checklist(program.documentChecklist)),
            _section('Common Mistakes to Avoid', Icons.warning_amber_outlined,
                _bulletList(program.commonMistakes)),
            if (program.videoResources.isNotEmpty)
              _section(
                'Video Resources',
                Icons.play_circle_outline,
                Column(
                  children: program.videoResources
                      .map((v) => _linkRow(
                          Icons.smart_display_outlined, v.title, v.url))
                      .toList(),
                ),
              ),
            _section(
              'FAQs',
              Icons.help_outline,
              Column(
                children: program.faqs
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
            _section(
              'Contact & Official Website',
              Icons.contact_mail_outlined,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (program.contactEmail.isNotEmpty)
                    _kv('Email', program.contactEmail),
                  if (program.contactPhone.isNotEmpty)
                    _kv('Phone', program.contactPhone),
                  const SizedBox(height: 10),
                  if (program.officialWebsite.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => _openLink(program.officialWebsite),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Visit Official Website'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _askAssistant(context, program),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ask the AI Counselling Assistant'),
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

  Widget _header(CounsellingProgram program) {
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
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(program.category.icon,
                    color: AppColors.accent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.fullName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.25)),
                    const SizedBox(height: 4),
                    Text(program.conductingBody,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: program.tags.map(_tag).toList()),
        ],
      ),
    );
  }

  Widget _tag(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 11.5,
                fontWeight: FontWeight.w700)),
      );

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

  Widget _checklist(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_box_outlined,
                          size: 16, color: Color(0xFF22C55E)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(i, style: _body)),
                    ],
                  ),
                ))
            .toList(),
      );

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(child: Text(k, style: _muted)),
          Text(v,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5)),
        ]),
      );

  Widget _linkRow(IconData icon, String title, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _openLink(url),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 13))),
            const Icon(Icons.open_in_new, size: 14, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')));
    }
  }

  Future<void> _share(CounsellingProgram program) async {
    final text = 'EduNavigate AI — ${program.fullName}\n\n'
        '${program.about}\n\n'
        'Official website: ${program.officialWebsite}';
    await ShareService.shareText(text, subject: program.name);
  }

  Future<void> _downloadPdf(CounsellingProgram program) async {
    setState(() => _generatingPdf = true);
    try {
      final file = await PdfReportService.generate(
        title: program.name,
        subtitle: program.fullName,
        fileName: 'counselling_${program.id}',
        sections: [
          PdfSection.text('Overview', program.about),
          PdfSection.text('Eligibility', program.eligibility),
          PdfSection.text('Registration', program.registrationProcess),
          PdfSection.text('Choice Filling', program.choiceFillingInfo),
          PdfSection.text('Choice Locking', program.choiceLockingInfo),
          PdfSection.text('Seat Allotment', program.seatAllotmentInfo),
          PdfSection.text('Reporting', program.reportingInfo),
          PdfSection.list(
              'Important Instructions', program.importantInstructions),
          PdfSection.list('Reservation Rules', program.reservationRules),
          PdfSection.list('Required Documents', program.requiredDocuments),
          PdfSection.list('Common Mistakes', program.commonMistakes),
        ],
      );
      if (mounted) {
        await ShareService.shareFile(file,
            text: '${program.name} — Counselling Guide');
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  void _askAssistant(BuildContext context, CounsellingProgram program) {
    final profile = ref.read(currentProfileProvider).asData?.value;
    if (profile == null) return;
    showAiMentorSheet(
      context,
      profile,
      contextHint:
          'the ${program.name} (${program.fullName}) counselling process',
    );
  }
}
