import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/comparison_table.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/loan_model.dart';
import '../providers/loan_providers.dart';

const _rowLabels = [
  'Type',
  'Interest Rate',
  'Max Loan',
  'Collateral',
  'Processing Fee',
  'Moratorium',
  'Processing Time',
];

/// Side-by-side comparison of up to 4 loan products.
class LoanCompareScreen extends ConsumerWidget {
  const LoanCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(loanCompareListProvider);
    final loans = ids
        .map((id) => ref.watch(loanByIdProvider(id)))
        .whereType<LoanModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Loans'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (loans.isNotEmpty)
            TextButton(
                onPressed: () =>
                    ref.read(loanCompareListProvider.notifier).clear(),
                child: const Text('Clear all')),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: loans.isEmpty
            ? const EmptyStateView(
                icon: Icons.compare_arrows,
                title: 'Nothing to compare yet',
                message:
                    'Add up to 4 loans using the "Compare" button on each card.',
              )
            : ComparisonTable(
                rowLabels: _rowLabels,
                columns: loans
                    .map((l) => ComparisonColumn(
                          title: l.lenderName,
                          accent: AppColors.primary,
                          onRemove: () => ref
                              .read(loanCompareListProvider.notifier)
                              .toggle(l.id),
                          values: [
                            l.isNbfc ? 'NBFC' : 'Bank',
                            '${l.interestRateLabel} p.a.',
                            l.maxLoanAmount,
                            l.collateral,
                            l.processingFee,
                            l.moratorium,
                            l.processingTime,
                          ],
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
