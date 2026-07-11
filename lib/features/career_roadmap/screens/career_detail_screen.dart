import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/services/pdf_report_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/stat_chip.dart';
import '../../../core/widgets/vertical_timeline.dart';
import '../../ai/widgets/ai_mentor.dart';
import '../../profile/providers/profile_providers.dart';
import '../models/career_roadmap_model.dart';
import '../providers/career_roadmap_providers.dart';

/// Full career profile — overview through learning path, an interactive
/// 12th→leadership roadmap, a beginner→advanced skill roadmap, and
/// bookmark/share/download/AI-compare actions.
class CareerDetailScreen extends ConsumerStatefulWidget {
  const CareerDetailScreen({super.key, required this.careerId});

  final String careerId;

  @override
  ConsumerState<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends ConsumerState<CareerDetailScreen> {
  bool _generatingPdf = false;

  @override
  Widget build(BuildContext context) {
    final career = ref.watch(careerByIdProvider(widget.careerId));
    final savedIds =
        ref.watch(careerBookmarkIdsProvider).asData?.value ?? const {};

    if (career == null) {
      return const Scaffold(
          body: Center(
              child: Text('Career not found',
                  style: TextStyle(color: Colors.white))));
    }

    final isSaved = savedIds.contains(career.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(career.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.accent : Colors.white),
            onPressed: () => ref
                .read(careerRoadmapBookmarkRepositoryProvider)
                .toggle(career.id, isSaved),
          ),
          IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(career)),
          IconButton(
            icon: _generatingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_outlined),
            onPressed: _generatingPdf ? null : () => _downloadPdf(career),
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
            _header(career),
            const SizedBox(height: 20),
            _section('Career Overview', Icons.info_outline,
                Text(career.overview, style: _body)),
            _section('Daily Work', Icons.work_history_outlined,
                Text(career.dailyWork, style: _body)),
            _section('Required Skills', Icons.psychology_alt_outlined,
                _bulletList(career.requiredSkills)),
            _section('Eligibility', Icons.check_circle_outline,
                Text(career.eligibility, style: _body)),
            _section('Best Degrees', Icons.school_outlined,
                _bulletList(career.bestDegrees)),
            _section('Best Colleges', Icons.account_balance_outlined,
                _bulletList(career.bestColleges)),
            _section('Top Recruiters', Icons.business_center_outlined,
                _bulletList(career.topRecruiters)),
            _section(
              'Salary',
              Icons.payments_outlined,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('India', career.indiaSalaryRange),
                  _kv('International', career.internationalSalaryRange),
                ],
              ),
            ),
            _section('Future Scope', Icons.trending_up_outlined,
                Text(career.futureScope, style: _body)),
            _section(
              'Growth & Demand',
              Icons.insights_outlined,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('Growth Rate', career.growthRate),
                  _kv('Demand Level', career.demandLevel.label),
                ],
              ),
            ),
            _section('AI Impact', Icons.auto_awesome_outlined,
                Text(career.aiImpact, style: _body)),
            _section(
              'Work Style',
              Icons.balance_outlined,
              Row(
                children: [
                  StatChip(
                      icon: Icons.wifi,
                      label: career.remoteWorkFriendly
                          ? 'Remote-friendly'
                          : 'On-site focused',
                      color: const Color(0xFF22C55E)),
                  const SizedBox(width: 14),
                  StatChip(
                      icon: Icons.self_improvement_outlined,
                      label:
                          'Work-life balance: ${career.workLifeBalanceRating}/5'),
                ],
              ),
            ),
            _section('Pros', Icons.thumb_up_outlined, _bulletList(career.pros)),
            _section(
                'Cons', Icons.thumb_down_outlined, _bulletList(career.cons)),
            _section(
                'Required Certifications',
                Icons.workspace_premium_outlined,
                _bulletList(career.requiredCertifications)),
            _section('Resources', Icons.menu_book_outlined,
                _bulletList(career.resources)),
            _section(
              'Interactive Roadmap',
              Icons.timeline_outlined,
              VerticalTimeline(
                accentColor: career.accent,
                nodes: career.roadmapSteps
                    .map((s) => TimelineNode(
                        title: s.title, subtitle: s.subtitle, detail: s.detail))
                    .toList(),
              ),
            ),
            _section(
              'Skill Roadmap',
              Icons.stairs_outlined,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _skillStage('Beginner', career.skillRoadmap.beginnerSkills,
                      const Color(0xFF22C55E)),
                  _skillStage(
                      'Intermediate',
                      career.skillRoadmap.intermediateSkills,
                      const Color(0xFFF59E0B)),
                  _skillStage('Advanced', career.skillRoadmap.advancedSkills,
                      const Color(0xFFEF4444)),
                  _skillGroup('Projects', career.skillRoadmap.projects),
                  _skillGroup('Certificates', career.skillRoadmap.certificates),
                  _skillGroup('Books', career.skillRoadmap.books),
                  _skillGroup('Courses', career.skillRoadmap.courses),
                ],
              ),
            ),
            _section(
              'FAQs',
              Icons.help_outline,
              Column(
                children: career.faqs
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
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _askAssistant(context, career),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ask AI to Compare This Career'),
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

  Widget _header(CareerRoadmapModel career) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: career.accent.withValues(alpha: 0.35)),
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
                    color: career.accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(career.icon, color: career.accent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(career.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(career.domain,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(career.shortDescription, style: _body),
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

  Widget _skillStage(String stage, List<String> skills, Color color) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(stage,
                style: TextStyle(
                    color: color, fontSize: 13, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(s,
                          style: TextStyle(
                              color: color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _skillGroup(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _bulletList(items),
        ],
      ),
    );
  }

  Future<void> _share(CareerRoadmapModel career) async {
    final text =
        'EduNavigate AI — ${career.title}\n\n${career.overview}\n\nIndia Salary: ${career.indiaSalaryRange}';
    await ShareService.shareText(text, subject: career.title);
  }

  Future<void> _downloadPdf(CareerRoadmapModel career) async {
    setState(() => _generatingPdf = true);
    try {
      final file = await PdfReportService.generate(
        title: career.title,
        subtitle: career.domain,
        fileName: 'career_${career.id}',
        sections: [
          PdfSection.text('Overview', career.overview),
          PdfSection.text('Daily Work', career.dailyWork),
          PdfSection.list('Required Skills', career.requiredSkills),
          PdfSection.text('Eligibility', career.eligibility),
          PdfSection.list('Best Degrees', career.bestDegrees),
          PdfSection.list('Top Recruiters', career.topRecruiters),
          PdfSection.text('India Salary', career.indiaSalaryRange),
          PdfSection.text('Future Scope', career.futureScope),
          PdfSection.list('Pros', career.pros),
          PdfSection.list('Cons', career.cons),
        ],
      );
      if (mounted) {
        await ShareService.shareFile(file,
            text: '${career.title} — Career Guide');
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  void _askAssistant(BuildContext context, CareerRoadmapModel career) {
    final profile = ref.read(currentProfileProvider).asData?.value;
    if (profile == null) return;
    showAiMentorSheet(
      context,
      profile,
      contextHint: 'the ${career.title} career',
      initialQuestion:
          'How does ${career.title} compare with similar careers, and is it a good fit for me?',
    );
  }
}
