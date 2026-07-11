import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/expense_estimate_model.dart';
import '../providers/loan_providers.dart';

/// Financial Planning tool — estimates tuition/hostel/books/living/travel
/// and suggests a loan/scholarship/family-contribution split.
class FinancialPlanningScreen extends ConsumerStatefulWidget {
  const FinancialPlanningScreen({super.key});

  @override
  ConsumerState<FinancialPlanningScreen> createState() =>
      _FinancialPlanningScreenState();
}

class _FinancialPlanningScreenState
    extends ConsumerState<FinancialPlanningScreen> {
  final _tuitionController = TextEditingController(text: '200000');
  final _incomeController = TextEditingController();
  CityTier _cityTier = CityTier.metro;
  bool _hostelRequired = true;
  int _years = 4;

  @override
  void dispose() {
    _tuitionController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _recompute() {
    ref.read(expensePlanInputProvider.notifier).state = ExpensePlanInput(
      annualTuitionFee: int.tryParse(_tuitionController.text) ?? 200000,
      cityTier: _cityTier,
      hostelRequired: _hostelRequired,
      courseDurationYears: _years,
      familyAnnualIncome: int.tryParse(_incomeController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(expensePlanResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Planning'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _label('Annual Tuition Fee (₹)'),
            AppTextField(
              hint: 'e.g. 200000',
              icon: Icons.school_outlined,
              controller: _tuitionController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(_recompute),
            ),
            const SizedBox(height: 16),
            _label('Annual Family Income (₹, optional)'),
            AppTextField(
              hint: 'e.g. 600000',
              icon: Icons.account_balance_wallet_outlined,
              controller: _incomeController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(_recompute),
            ),
            const SizedBox(height: 16),
            _label('City Tier'),
            Wrap(
              spacing: 8,
              children: CityTier.values
                  .map((t) => ChoiceChip(
                        label: Text(t.label),
                        selected: _cityTier == t,
                        onSelected: (_) => setState(() {
                          _cityTier = t;
                          _recompute();
                        }),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20)),
              child: SwitchListTile(
                value: _hostelRequired,
                onChanged: (v) => setState(() {
                  _hostelRequired = v;
                  _recompute();
                }),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: const Text('Hostel Required',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 16),
            _label('Course Duration (years)'),
            Wrap(
              spacing: 8,
              children: [2, 3, 4, 5]
                  .map((y) => ChoiceChip(
                        label: Text('$y yrs'),
                        selected: _years == y,
                        onSelected: (_) => setState(() {
                          _years = y;
                          _recompute();
                        }),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 26),
            const Text('Estimated Expense Breakdown',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            _bar('Tuition', result.totalTuition, result.totalExpense,
                const Color(0xFF3B82F6)),
            _bar('Hostel', result.totalHostel, result.totalExpense,
                const Color(0xFF22C55E)),
            _bar('Books', result.totalBooks, result.totalExpense,
                const Color(0xFFF59E0B)),
            _bar('Living', result.totalLiving, result.totalExpense,
                const Color(0xFFA855F7)),
            _bar('Travel', result.totalTravel, result.totalExpense,
                const Color(0xFFEF4444)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Text('Total Expense',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('₹${result.totalExpense}',
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.auto_awesome, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('AI Suggested Funding Plan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 14),
                  _suggestionRow('Recommended Loan Amount',
                      '₹${result.suggestedLoanAmount}'),
                  _suggestionRow('Scholarship Target',
                      '₹${result.suggestedScholarshipAmount}'),
                  _suggestionRow('Family Contribution',
                      '₹${result.suggestedFamilyContribution}'),
                  _suggestionRow('Estimated Monthly EMI',
                      '₹${result.estimatedMonthlyEmi.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ],
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

  Widget _bar(String label, int value, int total, Color color) {
    final fraction = total == 0 ? 0.0 : value / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text('₹$value',
                  style: TextStyle(
                      color: color,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12.5))),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      );
}
