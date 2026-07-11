/// A single bank/NBFC education loan product. Firebase-ready — `toMap`/
/// `fromMap` mirror an intended `loanProducts/{id}` Firestore document.
class LoanModel {
  final String id;
  final String lenderName;
  final bool isNbfc;
  final double interestRateMin;
  final double interestRateMax;
  final String maxLoanAmount;
  final String processingFee;
  final String collateral;
  final String moratorium;
  final String repayment;
  final String taxBenefit;
  final String eligibility;
  final List<String> documentsRequired;
  final String processingTime;
  final String officialUrl;

  const LoanModel({
    required this.id,
    required this.lenderName,
    required this.isNbfc,
    required this.interestRateMin,
    required this.interestRateMax,
    required this.maxLoanAmount,
    required this.processingFee,
    required this.collateral,
    required this.moratorium,
    required this.repayment,
    required this.taxBenefit,
    required this.eligibility,
    this.documentsRequired = const [],
    required this.processingTime,
    this.officialUrl = '',
  });

  String get interestRateLabel => interestRateMin == interestRateMax
      ? '$interestRateMin%'
      : '$interestRateMin% – $interestRateMax%';

  Map<String, dynamic> toMap() => {
        'id': id,
        'lenderName': lenderName,
        'isNbfc': isNbfc,
        'interestRateMin': interestRateMin,
        'interestRateMax': interestRateMax,
        'maxLoanAmount': maxLoanAmount,
        'processingFee': processingFee,
        'collateral': collateral,
        'moratorium': moratorium,
        'repayment': repayment,
        'taxBenefit': taxBenefit,
        'eligibility': eligibility,
        'documentsRequired': documentsRequired,
        'processingTime': processingTime,
        'officialUrl': officialUrl,
      };

  factory LoanModel.fromMap(Map<String, dynamic> map) => LoanModel(
        id: map['id'] as String,
        lenderName: map['lenderName'] as String,
        isNbfc: map['isNbfc'] as bool? ?? false,
        interestRateMin: (map['interestRateMin'] as num?)?.toDouble() ?? 0,
        interestRateMax: (map['interestRateMax'] as num?)?.toDouble() ?? 0,
        maxLoanAmount: map['maxLoanAmount'] as String? ?? '',
        processingFee: map['processingFee'] as String? ?? '',
        collateral: map['collateral'] as String? ?? '',
        moratorium: map['moratorium'] as String? ?? '',
        repayment: map['repayment'] as String? ?? '',
        taxBenefit: map['taxBenefit'] as String? ?? '',
        eligibility: map['eligibility'] as String? ?? '',
        documentsRequired:
            (map['documentsRequired'] as List?)?.cast<String>() ?? const [],
        processingTime: map['processingTime'] as String? ?? '',
        officialUrl: map['officialUrl'] as String? ?? '',
      );
}
