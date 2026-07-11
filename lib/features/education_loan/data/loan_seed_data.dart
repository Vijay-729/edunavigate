import '../models/loan_model.dart';

/// Representative seed data for major Indian education loan lenders.
/// Approximate, illustrative figures — swap for a live `loanProducts`
/// Firestore feed later via [LoanRepository].
class LoanSeedData {
  LoanSeedData._();

  static const List<LoanModel> all = [
    LoanModel(
      id: 'sbi',
      lenderName: 'State Bank of India (SBI Scholar Loan)',
      isNbfc: false,
      interestRateMin: 8.15,
      interestRateMax: 11.15,
      maxLoanAmount: 'Up to ₹1.5 Cr (no upper cap for premier institutes)',
      processingFee: 'Nil for loans up to ₹20L; 0.10% (max ₹10,000) above that',
      collateral:
          'Required above ₹7.5L (third-party guarantee or collateral security)',
      moratorium: 'Course period + 1 year',
      repayment: 'Up to 15 years after moratorium',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with admission confirmed at a recognised institute; co-applicant (parent/guardian) required',
      documentsRequired: [
        'Admission letter',
        'Fee structure',
        'KYC of student & co-applicant',
        'Income proof of co-applicant',
        'Academic records'
      ],
      processingTime: '15-20 working days',
      officialUrl:
          'https://sbi.co.in/web/personal-banking/loans/education-loans',
    ),
    LoanModel(
      id: 'pnb',
      lenderName: 'Punjab National Bank (PNB Saraswati/Udaan)',
      isNbfc: false,
      interestRateMin: 8.35,
      interestRateMax: 11.5,
      maxLoanAmount: 'Up to ₹1.5 Cr for studies abroad; ₹10-20L for India',
      processingFee: 'Nil for loans up to ₹7.5L; 1% above that (capped)',
      collateral: 'Required above ₹7.5L',
      moratorium: 'Course period + 1 year',
      repayment: 'Up to 15 years after moratorium',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'Fee structure',
        'KYC documents',
        'Income proof',
        'Collateral documents (if applicable)'
      ],
      processingTime: '2-3 weeks',
      officialUrl: 'https://www.pnbindia.in',
    ),
    LoanModel(
      id: 'bob',
      lenderName: 'Bank of Baroda (Baroda Education Loan)',
      isNbfc: false,
      interestRateMin: 8.55,
      interestRateMax: 10.85,
      maxLoanAmount: 'Up to ₹1.5 Cr (abroad); ₹20L (India, unsecured)',
      processingFee: 'Nil for loans up to ₹7.5L',
      collateral: 'Required above ₹7.5L',
      moratorium: 'Course period + 1 year',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'Mark sheets',
        'KYC',
        'Income proof of co-applicant'
      ],
      processingTime: '2-3 weeks',
      officialUrl: 'https://www.bankofbaroda.in',
    ),
    LoanModel(
      id: 'canara',
      lenderName: 'Canara Bank (Vidya Turant / IBA Scheme)',
      isNbfc: false,
      interestRateMin: 8.4,
      interestRateMax: 10.9,
      maxLoanAmount: 'Up to ₹1.5 Cr (abroad); ₹10L (India, unsecured)',
      processingFee: 'Nil for loans up to ₹7.5L',
      collateral: 'Required above ₹7.5L',
      moratorium: 'Course period + 1 year',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'Fee structure',
        'KYC',
        'Income proof'
      ],
      processingTime: '2-3 weeks',
      officialUrl: 'https://canarabank.com',
    ),
    LoanModel(
      id: 'union_bank',
      lenderName: 'Union Bank of India (Union Vidya)',
      isNbfc: false,
      interestRateMin: 8.4,
      interestRateMax: 11.15,
      maxLoanAmount: 'Up to ₹1.5 Cr (abroad); ₹10-20L (India)',
      processingFee: 'Nil for loans up to ₹7.5L',
      collateral: 'Required above ₹7.5L',
      moratorium: 'Course period + 1 year',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'Fee structure',
        'KYC',
        'Income proof of co-applicant'
      ],
      processingTime: '2-3 weeks',
      officialUrl: 'https://www.unionbankofindia.co.in',
    ),
    LoanModel(
      id: 'axis_bank',
      lenderName: 'Axis Bank Education Loan',
      isNbfc: false,
      interestRateMin: 9.7,
      interestRateMax: 13.7,
      maxLoanAmount: 'Up to ₹75L (India & abroad)',
      processingFee: 'Up to 1.5% of loan amount',
      collateral: 'May be waived for premier institutes (IITs/IIMs/NITs)',
      moratorium: 'Course period + 6 months',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required for most cases',
      documentsRequired: [
        'Admission letter',
        'KYC',
        'Income proof',
        'Academic records',
        'Bank statements'
      ],
      processingTime: '1-2 weeks',
      officialUrl: 'https://www.axisbank.com',
    ),
    LoanModel(
      id: 'icici_bank',
      lenderName: 'ICICI Bank Education Loan',
      isNbfc: false,
      interestRateMin: 9.5,
      interestRateMax: 13.25,
      maxLoanAmount: 'Up to ₹1 Cr+ for premier institutes; ₹50L standard',
      processingFee: 'Up to 1-2% of loan amount',
      collateral:
          'Waived for select premier institutes; required otherwise above ₹40L',
      moratorium: 'Course period + 6-12 months',
      repayment: 'Up to 14 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'KYC',
        'Income proof',
        'Collateral documents (if applicable)'
      ],
      processingTime: '1-2 weeks',
      officialUrl: 'https://www.icicibank.com',
    ),
    LoanModel(
      id: 'hdfc_bank',
      lenderName: 'HDFC Bank Education Loan',
      isNbfc: false,
      interestRateMin: 9.55,
      interestRateMax: 13.5,
      maxLoanAmount: 'Up to ₹1 Cr+ (abroad); ₹50L (India)',
      processingFee: 'Up to 1.5% of loan amount',
      collateral:
          'Waived for select top-ranked institutes; required otherwise above ₹40L',
      moratorium: 'Course period + 6-12 months',
      repayment: 'Up to 14 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian national with confirmed admission; co-applicant required',
      documentsRequired: [
        'Admission letter',
        'KYC',
        'Income proof',
        'Academic records'
      ],
      processingTime: '1-2 weeks',
      officialUrl: 'https://www.hdfcbank.com',
    ),
    LoanModel(
      id: 'hdfc_credila',
      lenderName: 'HDFC Credila (NBFC)',
      isNbfc: true,
      interestRateMin: 10.5,
      interestRateMax: 14.5,
      maxLoanAmount: 'Up to 100% of total cost of education (no upper cap)',
      processingFee: 'Up to 1.5-2% of loan amount',
      collateral: 'Flexible — often unsecured for strong academic profiles',
      moratorium: 'Course period + 6 months',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian students studying in India or abroad at recognised institutes',
      documentsRequired: [
        'Admission letter',
        'KYC',
        'Co-applicant income proof',
        'Academic records'
      ],
      processingTime: '5-10 working days (faster than most PSU banks)',
      officialUrl: 'https://www.hdfccredila.com',
    ),
    LoanModel(
      id: 'avanse',
      lenderName: 'Avanse Financial Services (NBFC)',
      isNbfc: true,
      interestRateMin: 10.75,
      interestRateMax: 14.75,
      maxLoanAmount: 'Up to 100% of total cost of education',
      processingFee: 'Up to 2% of loan amount',
      collateral:
          'Often unsecured, based on co-applicant profile and course/institute',
      moratorium: 'Course period + 6 months',
      repayment: 'Up to 15 years',
      taxBenefit: 'Interest eligible for deduction under Section 80E',
      eligibility:
          'Indian students studying in India or abroad at recognised institutes',
      documentsRequired: [
        'Admission letter',
        'KYC',
        'Co-applicant income proof',
        'Academic records'
      ],
      processingTime: '5-10 working days',
      officialUrl: 'https://www.avanse.com',
    ),
  ];
}
