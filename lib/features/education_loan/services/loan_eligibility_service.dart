import '../models/loan_eligibility_model.dart';

/// Transparent, rule-based eligibility heuristic (not a bank underwriting
/// engine) — mirrors the explainable "AI match" style used elsewhere in the
/// app rather than a black-box score.
class LoanEligibilityService {
  LoanEligibilityService._();

  static const _noCollateralFriendly = [
    'sbi',
    'pnb',
    'bob',
    'canara',
    'union_bank'
  ];
  static const _highTicketFriendly = [
    'hdfc_credila',
    'avanse',
    'icici_bank',
    'hdfc_bank',
    'axis_bank'
  ];

  static LoanEligibilityResult evaluate(LoanEligibilityInput input) {
    double score = 45;
    final reasons = <String>[];

    final amount = input.loanAmountNeeded ?? 0;
    final income = input.annualFamilyIncome ?? 0;

    if (input.hasCollateral) {
      score += 20;
      reasons.add('having collateral significantly widens your loan options');
    } else if (amount <= 750000) {
      score += 15;
      reasons
          .add('loans up to ₹7.5L are usually collateral-free at most banks');
    } else {
      score -= 10;
      reasons.add(
          'loans above ₹7.5L without collateral are harder to secure at PSU banks');
    }

    if (income > 0 && income <= 800000) {
      score += 10;
      reasons.add(
          'your family income qualifies for interest-subvention schemes like PM Vidyalaxmi/CSIS');
    }

    if (input.category != ReservationCategory.general) {
      score += 5;
      reasons.add(
          'your category may unlock additional government scheme benefits');
    }

    if (amount > 5000000) {
      score -= 10;
      reasons.add(
          'very high loan amounts need stronger co-applicant income or collateral');
    }

    score = score.clamp(10, 97);
    final eligible = score >= 40;

    final recommended = <String>{
      if (!input.hasCollateral && amount <= 750000) ..._noCollateralFriendly,
      if (input.hasCollateral || amount > 750000) ..._highTicketFriendly,
    }.toList();

    final reasonText =
        'Based on ${income > 0 ? "a family income of ₹$income" : "your inputs"}, '
        '${input.hasCollateral ? "collateral availability" : "no collateral"}, and a loan requirement of '
        '₹$amount, you have an estimated ${score.round()}% chance of loan approval — ${reasons.join('; ')}.';

    return LoanEligibilityResult(
      eligible: eligible,
      probability: score,
      recommendedLenderIds: recommended,
      reason: reasonText,
    );
  }
}
