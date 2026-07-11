import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/loan_model.dart';

/// List-item card for a loan product — used across the home rail, search
/// results, and saved list.
class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.loan,
    this.isSaved = false,
    this.isComparing = false,
    this.onTap,
    this.onSave,
    this.onCompareToggle,
  });

  final LoanModel loan;
  final bool isSaved;
  final bool isComparing;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onCompareToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.account_balance_outlined,
                        color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loan.lenderName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(loan.isNbfc ? 'NBFC' : 'Bank',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onSave,
                    tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? AppColors.accent : Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatChip(
                      icon: Icons.percent,
                      label: '${loan.interestRateLabel} p.a.',
                      color: const Color(0xFF22C55E)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: StatChip(
                          icon: Icons.account_balance_wallet_outlined,
                          label: loan.maxLoanAmount)),
                ],
              ),
              if (onCompareToggle != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onCompareToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isComparing
                            ? AppColors.primary.withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isComparing
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              isComparing
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              size: 13,
                              color: isComparing
                                  ? AppColors.accent
                                  : Colors.white60),
                          const SizedBox(width: 4),
                          Text('Compare',
                              style: TextStyle(
                                  color: isComparing
                                      ? AppColors.accent
                                      : Colors.white60,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
