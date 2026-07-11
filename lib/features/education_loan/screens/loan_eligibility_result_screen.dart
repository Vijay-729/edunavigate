import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/loan_providers.dart';
import '../widgets/loan_card.dart';
import 'loan_detail_screen.dart';

/// Shows the eligibility verdict, probability, and recommended lenders.
class LoanEligibilityResultScreen extends ConsumerWidget {
  const LoanEligibilityResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(loanEligibilityResultProvider);
    final savedIds =
        ref.watch(loanBookmarkIdsProvider).asData?.value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligibility Result'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: result == null
            ? const EmptyStateView(
                title: 'No result yet',
                message: 'Fill in the eligibility form and check again.')
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: result.eligible
                            ? const [Color(0xFF22C55E), Color(0xFF4ADE80)]
                            : const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                                result.eligible
                                    ? Icons.check_circle
                                    : Icons.info_outline,
                                color: Colors.white,
                                size: 28),
                            const SizedBox(width: 10),
                            Text(
                                result.eligible
                                    ? 'Likely Eligible'
                                    : 'May Need More Support',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            '${result.probability.round()}% approval probability',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome,
                            size: 16, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(result.reason,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.45))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text('Recommended Lenders',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ...result.recommendedLenderIds
                      .map((id) => Consumer(builder: (context, ref, _) {
                            final loan = ref.watch(loanByIdProvider(id));
                            if (loan == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: LoanCard(
                                loan: loan,
                                isSaved: savedIds.contains(loan.id),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (_) =>
                                          LoanDetailScreen(loanId: loan.id)),
                                ),
                                onSave: () => ref
                                    .read(loanBookmarkRepositoryProvider)
                                    .toggle(
                                        loan.id, savedIds.contains(loan.id)),
                              ),
                            );
                          })),
                ],
              ),
      ),
    );
  }
}
