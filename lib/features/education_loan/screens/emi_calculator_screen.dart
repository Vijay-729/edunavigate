import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/emi_calculation_model.dart';
import '../providers/loan_providers.dart';

/// Live EMI calculator — loan amount, interest rate, tenure, processing fee
/// → monthly EMI, total interest, total amount.
class EmiCalculatorScreen extends ConsumerStatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  ConsumerState<EmiCalculatorScreen> createState() =>
      _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends ConsumerState<EmiCalculatorScreen> {
  late double _loanAmount;
  late double _interestRate;
  late int _tenureYears;
  late double _processingFeePercent;

  @override
  void initState() {
    super.initState();
    final input = ref.read(emiInputProvider);
    _loanAmount = input.loanAmount;
    _interestRate = input.annualInterestRate;
    _tenureYears = input.tenureYears;
    _processingFeePercent = input.processingFeePercent;
  }

  void _recompute() {
    ref.read(emiInputProvider.notifier).state = EmiInput(
      loanAmount: _loanAmount,
      annualInterestRate: _interestRate,
      tenureYears: _tenureYears,
      processingFeePercent: _processingFeePercent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(emiResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly EMI',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('₹${result.monthlyEmi.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _resultStat('Total Interest',
                              '₹${result.totalInterest.toStringAsFixed(0)}')),
                      Expanded(
                          child: _resultStat('Total Amount',
                              '₹${result.totalAmount.toStringAsFixed(0)}')),
                    ],
                  ),
                  if (result.processingFeeAmount > 0) ...[
                    const SizedBox(height: 10),
                    _resultStat('Processing Fee',
                        '₹${result.processingFeeAmount.toStringAsFixed(0)}'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            _slider(
                'Loan Amount',
                '₹${_loanAmount.toStringAsFixed(0)}',
                _loanAmount,
                100000,
                15000000,
                100,
                (v) => setState(() {
                      _loanAmount = v;
                      _recompute();
                    })),
            _slider(
                'Interest Rate',
                '$_interestRate% p.a.',
                _interestRate,
                6,
                16,
                200,
                (v) => setState(() {
                      _interestRate = v;
                      _recompute();
                    })),
            _slider(
                'Tenure',
                '$_tenureYears years',
                _tenureYears.toDouble(),
                1,
                20,
                19,
                (v) => setState(() {
                      _tenureYears = v.round();
                      _recompute();
                    })),
            _slider(
                'Processing Fee',
                '$_processingFeePercent%',
                _processingFeePercent,
                0,
                3,
                30,
                (v) => setState(() {
                      _processingFeePercent = v;
                      _recompute();
                    })),
          ],
        ),
      ),
    );
  }

  Widget _resultStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _slider(String label, String valueLabel, double value, double min,
      double max, int divisions, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(valueLabel,
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: AppColors.accent,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
            ),
            child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
