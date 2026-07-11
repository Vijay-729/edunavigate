import 'package:flutter/material.dart';

/// Broad course category. Drives the stream → course gating rule in
/// [StudentStreamX.eligibleCategories] and doubles as the "Course Filter"
/// chip set on the College Explorer home screen.
enum CourseCategory {
  engineering,
  medical,
  commerce,
  arts,
  law,
  management,
  agriculture,
  science,
  design,
  architecture,
}

extension CourseCategoryX on CourseCategory {
  String get label {
    switch (this) {
      case CourseCategory.engineering:
        return 'Engineering';
      case CourseCategory.medical:
        return 'Medical';
      case CourseCategory.commerce:
        return 'Commerce';
      case CourseCategory.arts:
        return 'Arts';
      case CourseCategory.law:
        return 'Law';
      case CourseCategory.management:
        return 'Management';
      case CourseCategory.agriculture:
        return 'Agriculture';
      case CourseCategory.science:
        return 'Science';
      case CourseCategory.design:
        return 'Design';
      case CourseCategory.architecture:
        return 'Architecture';
    }
  }

  IconData get icon {
    switch (this) {
      case CourseCategory.engineering:
        return Icons.precision_manufacturing_outlined;
      case CourseCategory.medical:
        return Icons.local_hospital_outlined;
      case CourseCategory.commerce:
        return Icons.account_balance_outlined;
      case CourseCategory.arts:
        return Icons.palette_outlined;
      case CourseCategory.law:
        return Icons.gavel_outlined;
      case CourseCategory.management:
        return Icons.groups_outlined;
      case CourseCategory.agriculture:
        return Icons.agriculture_outlined;
      case CourseCategory.science:
        return Icons.science_outlined;
      case CourseCategory.design:
        return Icons.design_services_outlined;
      case CourseCategory.architecture:
        return Icons.architecture_outlined;
    }
  }
}

/// A single course/degree offered by a college (e.g. "B.Tech CSE").
class CourseModel {
  final String id;
  final String name; // "B.Tech in Computer Science & Engineering"
  final String shortName; // "CSE"
  final String degree; // "B.Tech", "MBBS", "B.Com (Hons)"
  final CourseCategory category;
  final int durationYears;
  final String eligibility;

  /// Exam ids (see [ExamModel.id]) accepted for admission to this course.
  final List<String> examIds;

  const CourseModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.degree,
    required this.category,
    required this.durationYears,
    required this.eligibility,
    this.examIds = const [],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'shortName': shortName,
        'degree': degree,
        'category': category.name,
        'durationYears': durationYears,
        'eligibility': eligibility,
        'examIds': examIds,
      };

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      shortName: map['shortName'] as String,
      degree: map['degree'] as String,
      category: CourseCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => CourseCategory.science,
      ),
      durationYears: map['durationYears'] as int? ?? 4,
      eligibility: map['eligibility'] as String? ?? '',
      examIds: (map['examIds'] as List?)?.cast<String>() ?? const [],
    );
  }
}
