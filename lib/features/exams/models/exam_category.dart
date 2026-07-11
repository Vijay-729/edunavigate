import 'package:flutter/material.dart';

enum ExamCategory {
  engineering,
  medical,
  commerce,
  arts,
  science,
  management,
  law,
  agriculture,
  architecture,
  design,
  hotelManagement,
  paramedical,
  defence,
  government,
  scholarships,
  biotechnology,
  railway,
  banking,
  teaching,
  foreignStudies,
  higherStudies,
}

extension ExamCategoryX on ExamCategory {
  String get label {
    switch (this) {
      case ExamCategory.engineering:
        return 'Engineering';
      case ExamCategory.medical:
        return 'Medical';
      case ExamCategory.commerce:
        return 'Commerce';
      case ExamCategory.arts:
        return 'Arts';
      case ExamCategory.science:
        return 'Science';
      case ExamCategory.management:
        return 'Management';
      case ExamCategory.law:
        return 'Law';
      case ExamCategory.agriculture:
        return 'Agriculture';
      case ExamCategory.architecture:
        return 'Architecture';
      case ExamCategory.design:
        return 'Design';
      case ExamCategory.hotelManagement:
        return 'Hotel Management';
      case ExamCategory.paramedical:
        return 'Paramedical';
      case ExamCategory.defence:
        return 'Defence';
      case ExamCategory.government:
        return 'Government';
      case ExamCategory.scholarships:
        return 'Scholarships';
      case ExamCategory.biotechnology:
        return 'Biotechnology';
      case ExamCategory.railway:
        return 'Railway';
      case ExamCategory.banking:
        return 'Banking';
      case ExamCategory.teaching:
        return 'Teaching';
      case ExamCategory.foreignStudies:
        return 'Foreign Studies';
      case ExamCategory.higherStudies:
        return 'Higher Studies';
    }
  }

  IconData get icon {
    switch (this) {
      case ExamCategory.engineering:
        return Icons.precision_manufacturing_outlined;
      case ExamCategory.medical:
        return Icons.local_hospital_outlined;
      case ExamCategory.commerce:
        return Icons.account_balance_outlined;
      case ExamCategory.arts:
        return Icons.palette_outlined;
      case ExamCategory.science:
        return Icons.science_outlined;
      case ExamCategory.management:
        return Icons.groups_outlined;
      case ExamCategory.law:
        return Icons.gavel_outlined;
      case ExamCategory.agriculture:
        return Icons.agriculture_outlined;
      case ExamCategory.architecture:
        return Icons.architecture_outlined;
      case ExamCategory.design:
        return Icons.design_services_outlined;
      case ExamCategory.hotelManagement:
        return Icons.restaurant_outlined;
      case ExamCategory.paramedical:
        return Icons.medical_services_outlined;
      case ExamCategory.defence:
        return Icons.military_tech_outlined;
      case ExamCategory.government:
        return Icons.account_balance;
      case ExamCategory.scholarships:
        return Icons.workspace_premium_outlined;
      case ExamCategory.biotechnology:
        return Icons.biotech_outlined;
      case ExamCategory.railway:
        return Icons.train_outlined;
      case ExamCategory.banking:
        return Icons.account_balance_wallet_outlined;
      case ExamCategory.teaching:
        return Icons.school_outlined;
      case ExamCategory.foreignStudies:
        return Icons.public_outlined;
      case ExamCategory.higherStudies:
        return Icons.auto_stories_outlined;
    }
  }
}

enum ExamDifficulty { easy, moderate, hard, veryHard }

extension ExamDifficultyX on ExamDifficulty {
  String get label {
    switch (this) {
      case ExamDifficulty.easy:
        return 'Easy';
      case ExamDifficulty.moderate:
        return 'Moderate';
      case ExamDifficulty.hard:
        return 'Hard';
      case ExamDifficulty.veryHard:
        return 'Very Hard';
    }
  }
}

enum ExamApplicationStatus { upcoming, ongoing, closed, completed }

extension ExamApplicationStatusX on ExamApplicationStatus {
  String get label {
    switch (this) {
      case ExamApplicationStatus.upcoming:
        return 'Upcoming';
      case ExamApplicationStatus.ongoing:
        return 'Applications Open';
      case ExamApplicationStatus.closed:
        return 'Applications Closed';
      case ExamApplicationStatus.completed:
        return 'Completed';
    }
  }
}

enum ExamMode { online, offline, hybrid }

extension ExamModeX on ExamMode {
  String get label {
    switch (this) {
      case ExamMode.online:
        return 'Online';
      case ExamMode.offline:
        return 'Offline (Pen & Paper)';
      case ExamMode.hybrid:
        return 'Hybrid';
    }
  }
}
