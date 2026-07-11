import 'dart:math' as math;

import '../models/emi_calculation_model.dart';

/// Standard reducing-balance EMI formula: E = P × r × (1+r)^n / ((1+r)^n − 1)
class EmiCalculatorService {
  EmiCalculatorService._();

  static EmiResult calculate(EmiInput input) {
    final principal = input.loanAmount;
    final monthlyRate = input.annualInterestRate / 12 / 100;
    final months = input.tenureYears * 12;

    double emi;
    if (monthlyRate == 0) {
      emi = principal / months;
    } else {
      final factor = math.pow(1 + monthlyRate, months);
      emi = principal * monthlyRate * factor / (factor - 1);
    }

    final totalAmount = emi * months;
    final totalInterest = totalAmount - principal;
    final processingFeeAmount = principal * input.processingFeePercent / 100;

    return EmiResult(
      monthlyEmi: emi,
      totalInterest: totalInterest,
      totalAmount: totalAmount,
      processingFeeAmount: processingFeeAmount,
    );
  }
}
