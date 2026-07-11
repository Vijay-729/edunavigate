import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header_row.dart';
import '../providers/loan_providers.dart';
import '../widgets/loan_card.dart';
import 'emi_calculator_screen.dart';
import 'financial_planning_screen.dart';
import 'government_schemes_screen.dart';
import 'loan_detail_screen.dart';
import 'loan_eligibility_screen.dart';
import 'loan_list_screen.dart';
import 'saved_loans_screen.dart';
import 'scholarship_finder_screen.dart';

/// Education Loan entry point (spec §Feature 4) — compare loans, EMI
/// calculator, eligibility checker, scholarship finder, government schemes,
/// and financial planning.
class EducationLoanHomeScreen extends ConsumerWidget {
  const EducationLoanHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(allLoansProvider);
    final saved = ref.watch(savedLoansProvider);
    final savedIds =
        ref.watch(loanBookmarkIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(loanCompareListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Loan'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Saved loans',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const SavedLoansScreen())),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tools',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _toolCard(
                            context,
                            Icons.calculate_outlined,
                            'EMI Calculator',
                            const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                            () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const EmiCalculatorScreen()))),
                        _toolCard(
                            context,
                            Icons.fact_check_outlined,
                            'Eligibility Checker',
                            const [Color(0xFF22C55E), Color(0xFF4ADE80)],
                            () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const LoanEligibilityScreen()))),
                        _toolCard(
                            context,
                            Icons.workspace_premium_outlined,
                            'Scholarship Finder',
                            const [Color(0xFFF97316), Color(0xFFFB923C)],
                            () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const ScholarshipFinderScreen()))),
                        _toolCard(
                            context,
                            Icons.account_balance_outlined,
                            'Govt. Schemes',
                            const [Color(0xFFA855F7), Color(0xFFC084FC)],
                            () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const GovernmentSchemesScreen()))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    const FinancialPlanningScreen())),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: Colors.white, size: 26),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('AI Financial Planning',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 4),
                                    Text(
                                        'Estimate total cost & get a suggested loan/scholarship split',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: SectionHeaderRow(
                  title: 'Compare Loans',
                  subtitle: 'Banks & NBFCs',
                  onSeeAll: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const LoanListScreen())),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverList.separated(
                itemCount: loans.length > 5 ? 5 : loans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return LoanCard(
                    loan: loan,
                    isSaved: savedIds.contains(loan.id),
                    isComparing: compareIds.contains(loan.id),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => LoanDetailScreen(loanId: loan.id))),
                    onSave: () => ref
                        .read(loanBookmarkRepositoryProvider)
                        .toggle(loan.id, savedIds.contains(loan.id)),
                    onCompareToggle: () {
                      final ok = ref
                          .read(loanCompareListProvider.notifier)
                          .toggle(loan.id);
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('You can compare up to 4 loans.')));
                      }
                    },
                  );
                },
              ),
            ),
            if (saved.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                  child: SectionHeaderRow(
                    title: 'Saved Loans',
                    onSeeAll: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const SavedLoansScreen())),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _toolCard(BuildContext context, IconData icon, String title,
      List<Color> colors, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.first.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: colors),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              Text(title,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
