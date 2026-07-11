enum CityTier { metro, tier2, tier3 }

extension CityTierX on CityTier {
  String get label {
    switch (this) {
      case CityTier.metro:
        return 'Metro City';
      case CityTier.tier2:
        return 'Tier 2 City';
      case CityTier.tier3:
        return 'Tier 3 / Town';
    }
  }
}

/// Financial planning inputs.
class ExpensePlanInput {
  final int annualTuitionFee;
  final CityTier cityTier;
  final bool hostelRequired;
  final int courseDurationYears;
  final int? familyAnnualIncome;

  const ExpensePlanInput({
    required this.annualTuitionFee,
    this.cityTier = CityTier.metro,
    this.hostelRequired = true,
    this.courseDurationYears = 4,
    this.familyAnnualIncome,
  });
}

/// Financial planning output — full expense estimate plus an AI-style
/// suggested funding split (loan / scholarship / family contribution).
class ExpensePlanResult {
  final int totalTuition;
  final int totalHostel;
  final int totalBooks;
  final int totalLiving;
  final int totalTravel;
  final int totalExpense;
  final int suggestedLoanAmount;
  final int suggestedScholarshipAmount;
  final int suggestedFamilyContribution;
  final double estimatedMonthlyEmi;

  const ExpensePlanResult({
    required this.totalTuition,
    required this.totalHostel,
    required this.totalBooks,
    required this.totalLiving,
    required this.totalTravel,
    required this.totalExpense,
    required this.suggestedLoanAmount,
    required this.suggestedScholarshipAmount,
    required this.suggestedFamilyContribution,
    required this.estimatedMonthlyEmi,
  });
}
