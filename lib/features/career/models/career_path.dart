import 'package:flutter/material.dart';

class CareerPath {
  const CareerPath({
    required this.id,
    required this.title,
    required this.domain,
    required this.shortDescription,
    required this.fullDescription,
    required this.keySkills,
    required this.minimumQualification,
    required this.topExamsOrPaths,
    required this.salaryRange,
    required this.topRecruiters,
    required this.icon,
    required this.accent,
    required this.relatedCategories,
  });

  final String id;
  final String title;
  final String domain;
  final String shortDescription;
  final String fullDescription;
  final List<String> keySkills;
  final String minimumQualification;
  final String topExamsOrPaths;
  final String salaryRange;
  final List<String> topRecruiters;
  final IconData icon;
  final Color accent;

  /// Matches assessment category keys so the explorer can rank careers by
  /// the student's assessed strengths.
  final List<String> relatedCategories;
}
