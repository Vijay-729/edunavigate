enum ReservationCategory { general, obc, sc, st, ews, minority }

extension ReservationCategoryX on ReservationCategory {
  String get label {
    switch (this) {
      case ReservationCategory.general:
        return 'General';
      case ReservationCategory.obc:
        return 'OBC';
      case ReservationCategory.sc:
        return 'SC';
      case ReservationCategory.st:
        return 'ST';
      case ReservationCategory.ews:
        return 'EWS';
      case ReservationCategory.minority:
        return 'Minority';
    }
  }
}

/// Everything the loan eligibility checker collects before computing a result.
class LoanEligibilityInput {
  final int? annualFamilyIncome;
  final String? collegeName;
  final String? course;
  final int? loanAmountNeeded;
  final ReservationCategory category;
  final bool hasCollateral;

  const LoanEligibilityInput({
    this.annualFamilyIncome,
    this.collegeName,
    this.course,
    this.loanAmountNeeded,
    this.category = ReservationCategory.general,
    this.hasCollateral = false,
  });

  bool get isReadyToCheck =>
      annualFamilyIncome != null && loanAmountNeeded != null;

  LoanEligibilityInput copyWith({
    int? annualFamilyIncome,
    String? collegeName,
    String? course,
    int? loanAmountNeeded,
    ReservationCategory? category,
    bool? hasCollateral,
  }) {
    return LoanEligibilityInput(
      annualFamilyIncome: annualFamilyIncome ?? this.annualFamilyIncome,
      collegeName: collegeName ?? this.collegeName,
      course: course ?? this.course,
      loanAmountNeeded: loanAmountNeeded ?? this.loanAmountNeeded,
      category: category ?? this.category,
      hasCollateral: hasCollateral ?? this.hasCollateral,
    );
  }
}

/// Output of the eligibility checker: pass/fail, a probability score, and
/// recommended lender ids ranked best-fit first.
class LoanEligibilityResult {
  final bool eligible;
  final double probability;
  final List<String> recommendedLenderIds;
  final String reason;

  const LoanEligibilityResult({
    required this.eligible,
    required this.probability,
    required this.recommendedLenderIds,
    required this.reason,
  });
}
