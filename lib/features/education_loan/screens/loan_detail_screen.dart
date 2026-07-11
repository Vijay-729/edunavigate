import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/services/pdf_report_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/loan_model.dart';
import '../providers/loan_providers.dart';

/// Full loan product profile — interest, collateral, moratorium, repayment,
/// tax benefit, eligibility, documents, processing time, and official link.
class LoanDetailScreen extends ConsumerStatefulWidget {
  const LoanDetailScreen({super.key, required this.loanId});

  final String loanId;

  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  bool _generatingPdf = false;

  @override
  Widget build(BuildContext context) {
    final loan = ref.watch(loanByIdProvider(widget.loanId));
    final savedIds =
        ref.watch(loanBookmarkIdsProvider).asData?.value ?? const {};

    if (loan == null) {
      return const Scaffold(
          body: Center(
              child: Text('Loan not found',
                  style: TextStyle(color: Colors.white))));
    }

    final isSaved = savedIds.contains(loan.id);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(loan.lenderName, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.accent : Colors.white),
            onPressed: () => ref
                .read(loanBookmarkRepositoryProvider)
                .toggle(loan.id, isSaved),
          ),
          IconButton(
              tooltip: 'Share',
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(loan)),
          IconButton(
            tooltip: 'Download PDF',
            icon: _generatingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_outlined),
            onPressed: _generatingPdf ? null : () => _downloadPdf(loan),
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF102846),
                borderRadius: BorderRadius.circular(22),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.account_balance_outlined,
                        color: AppColors.accent, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loan.lenderName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                            loan.isNbfc
                                ? 'Non-Banking Financial Company'
                                : 'Scheduled Commercial Bank',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _section('Interest Rate', Icons.percent,
                Text('${loan.interestRateLabel} per annum', style: _body)),
            _section(
                'Maximum Loan Amount',
                Icons.account_balance_wallet_outlined,
                Text(loan.maxLoanAmount, style: _body)),
            _section('Processing Fee', Icons.receipt_long_outlined,
                Text(loan.processingFee, style: _body)),
            _section('Collateral', Icons.shield_outlined,
                Text(loan.collateral, style: _body)),
            _section('Moratorium', Icons.hourglass_bottom_outlined,
                Text(loan.moratorium, style: _body)),
            _section('Repayment', Icons.calendar_month_outlined,
                Text(loan.repayment, style: _body)),
            _section('Tax Benefits', Icons.savings_outlined,
                Text(loan.taxBenefit, style: _body)),
            _section('Eligibility', Icons.check_circle_outline,
                Text(loan.eligibility, style: _body)),
            _section('Documents Required', Icons.description_outlined,
                _bulletList(loan.documentsRequired)),
            _section('Processing Time', Icons.timer_outlined,
                Text(loan.processingTime, style: _body)),
            if (loan.officialUrl.isNotEmpty)
              _section(
                'Official Link',
                Icons.language_outlined,
                OutlinedButton.icon(
                  onPressed: () => _openLink(loan.officialUrl),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Visit Official Website'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static const _body =
      TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5);

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

  Future<void> _share(LoanModel loan) async {
    final text = 'EduNavigate AI — ${loan.lenderName}\n\n'
        'Interest Rate: ${loan.interestRateLabel} p.a.\nMax Amount: ${loan.maxLoanAmount}\n\n'
        'Official site: ${loan.officialUrl}';
    await ShareService.shareText(text, subject: loan.lenderName);
  }

  Future<void> _downloadPdf(LoanModel loan) async {
    setState(() => _generatingPdf = true);
    try {
      final file = await PdfReportService.generate(
        title: loan.lenderName,
        subtitle: loan.isNbfc ? 'NBFC' : 'Bank',
        fileName: 'loan_${loan.id}',
        sections: [
          PdfSection.text(
              'Interest Rate', '${loan.interestRateLabel} per annum'),
          PdfSection.text('Maximum Loan Amount', loan.maxLoanAmount),
          PdfSection.text('Processing Fee', loan.processingFee),
          PdfSection.text('Collateral', loan.collateral),
          PdfSection.text('Moratorium', loan.moratorium),
          PdfSection.text('Repayment', loan.repayment),
          PdfSection.text('Tax Benefits', loan.taxBenefit),
          PdfSection.text('Eligibility', loan.eligibility),
          PdfSection.list('Documents Required', loan.documentsRequired),
        ],
      );
      if (mounted) {
        await ShareService.shareFile(file,
            text: '${loan.lenderName} — Loan Details');
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }
}
