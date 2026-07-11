import 'package:flutter/material.dart';

import 'course_model.dart';

/// An entrance exam a Class 12 student can appear for. Future-ready for a
/// Firestore `exams` collection — `toMap`/`fromMap` mirror the intended
/// document shape.
class ExamModel {
  final String id; // e.g. 'jee_main'
  final String shortName; // 'JEE Main'
  final String fullName; // 'Joint Entrance Examination (Main)'
  final String conductingBody;
  final CourseCategory primaryCategory;
  final String scoreType; // 'rank' | 'score' | 'percentile'
  final IconData icon;

  const ExamModel({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.conductingBody,
    required this.primaryCategory,
    required this.scoreType,
    this.icon = Icons.assignment_outlined,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'shortName': shortName,
        'fullName': fullName,
        'conductingBody': conductingBody,
        'primaryCategory': primaryCategory.name,
        'scoreType': scoreType,
      };

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'] as String,
      shortName: map['shortName'] as String,
      fullName: map['fullName'] as String,
      conductingBody: map['conductingBody'] as String? ?? '',
      primaryCategory: CourseCategory.values.firstWhere(
        (c) => c.name == map['primaryCategory'],
        orElse: () => CourseCategory.engineering,
      ),
      scoreType: map['scoreType'] as String? ?? 'rank',
    );
  }
}
