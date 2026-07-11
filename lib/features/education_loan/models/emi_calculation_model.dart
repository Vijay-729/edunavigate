/// EMI calculator inputs.
class EmiInput {
  final double loanAmount;
  final double annualInterestRate;
  final int tenureYears;
  final double processingFeePercent;

  const EmiInput({
    required this.loanAmount,
    required this.annualInterestRate,
    required this.tenureYears,
    this.processingFeePercent = 0,
  });
}

/// EMI calculator output.
class EmiResult {
  final double monthlyEmi;
  final double totalInterest;
  final double totalAmount;
  final double processingFeeAmount;

  const EmiResult({
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalAmount,
    required this.processingFeeAmount,
  });
}
