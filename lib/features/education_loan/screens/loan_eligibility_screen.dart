import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/loan_eligibility_model.dart';
import '../providers/loan_providers.dart';
import 'loan_eligibility_result_screen.dart';

/// Loan Eligibility Checker form — family income, college, course, loan
/// amount, category, collateral → eligibility + probability + recommended banks.
class LoanEligibilityScreen extends ConsumerStatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  ConsumerState<LoanEligibilityScreen> createState() =>
      _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends ConsumerState<LoanEligibilityScreen> {
  final _incomeController = TextEditingController();
  final _collegeController = TextEditingController();
  final _courseController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _incomeController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _patch(LoanEligibilityInput Function(LoanEligibilityInput) transform) {
    ref.read(loanEligibilityFormProvider.notifier).update(transform);
  }

  @override
  Widget build(BuildContext context) {
    final input = ref.watch(loanEligibilityFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Eligibility Checker'),
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
              const Text('Check Your Eligibility',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Answer a few questions for an instant estimate.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 13)),
              const SizedBox(height: 22),
              _label('Annual Family Income (₹)'),
              AppTextField(
                hint: 'e.g. 600000',
                icon: Icons.account_balance_wallet_outlined,
                controller: _incomeController,
                keyboardType: TextInputType.number,
                onChanged: (v) => _patch(
                    (i) => i.copyWith(annualFamilyIncome: int.tryParse(v))),
              ),
              const SizedBox(height: 16),
              _label('College'),
              AppTextField(
                hint: 'e.g. IIT Bombay',
                icon: Icons.account_balance_outlined,
                controller: _collegeController,
                onChanged: (v) => _patch((i) => i.copyWith(collegeName: v)),
              ),
              const SizedBox(height: 16),
              _label('Course'),
              AppTextField(
                hint: 'e.g. B.Tech Computer Science',
                icon: Icons.menu_book_outlined,
                controller: _courseController,
                onChanged: (v) => _patch((i) => i.copyWith(course: v)),
              ),
              const SizedBox(height: 16),
              _label('Loan Amount Needed (₹)'),
              AppTextField(
                hint: 'e.g. 1000000',
                icon: Icons.currency_rupee,
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: (v) => _patch(
                    (i) => i.copyWith(loanAmountNeeded: int.tryParse(v))),
              ),
              const SizedBox(height: 16),
              _label('Category'),
              _Dropdown<ReservationCategory>(
                value: input.category,
                items: ReservationCategory.values,
                labelBuilder: (c) => c.label,
                icon: Icons.groups_outlined,
                onChanged: (v) => _patch((i) => i.copyWith(category: v)),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(20)),
                child: SwitchListTile(
                  value: input.hasCollateral,
                  onChanged: (v) => _patch((i) => i.copyWith(hasCollateral: v)),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I can offer collateral',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Check Eligibility',
                icon: Icons.fact_check_outlined,
                onPressed: input.isReadyToCheck
                    ? () {
                        ref
                            .read(loanEligibilityResultProvider.notifier)
                            .check(input);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) =>
                                  const LoanEligibilityResultScreen()),
                        );
                      }
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please enter your family income and loan amount needed.'))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12.5,
                fontWeight: FontWeight.w700)),
      );
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.icon,
    required this.onChanged,
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final IconData icon;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value) ? value : null;
    return DropdownButtonFormField<T>(
      initialValue: safeValue,
      isExpanded: true,
      dropdownColor: AppColors.dropdownSurface,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
              value: e,
              child: Text(labelBuilder(e), overflow: TextOverflow.ellipsis)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
