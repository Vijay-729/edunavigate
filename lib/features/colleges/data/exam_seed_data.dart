import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../models/exam_model.dart';

/// Static seed list of entrance exams. Swap for a Firestore `exams`
/// collection later — nothing else in the module depends on this being local.
class ExamSeedData {
  ExamSeedData._();

  static const List<ExamModel> all = [
    ExamModel(
      id: 'jee_main',
      shortName: 'JEE Main',
      fullName: 'Joint Entrance Examination (Main)',
      conductingBody: 'NTA',
      primaryCategory: CourseCategory.engineering,
      scoreType: 'rank',
      icon: Icons.functions_rounded,
    ),
    ExamModel(
      id: 'jee_advanced',
      shortName: 'JEE Advanced',
      fullName: 'Joint Entrance Examination (Advanced)',
      conductingBody: 'IIT (rotating zone)',
      primaryCategory: CourseCategory.engineering,
      scoreType: 'rank',
      icon: Icons.functions_rounded,
    ),
    ExamModel(
      id: 'neet',
      shortName: 'NEET',
      fullName: 'National Eligibility cum Entrance Test',
      conductingBody: 'NTA',
      primaryCategory: CourseCategory.medical,
      scoreType: 'rank',
      icon: Icons.biotech_outlined,
    ),
    ExamModel(
      id: 'cuet',
      shortName: 'CUET',
      fullName: 'Common University Entrance Test',
      conductingBody: 'NTA',
      primaryCategory: CourseCategory.arts,
      scoreType: 'score',
      icon: Icons.school_outlined,
    ),
    ExamModel(
      id: 'gat_b',
      shortName: 'GAT-B',
      fullName: 'Graduate Aptitude Test in Biology',
      conductingBody: 'DBT',
      primaryCategory: CourseCategory.science,
      scoreType: 'score',
      icon: Icons.science_outlined,
    ),
    ExamModel(
      id: 'clat',
      shortName: 'CLAT',
      fullName: 'Common Law Admission Test',
      conductingBody: 'Consortium of NLUs',
      primaryCategory: CourseCategory.law,
      scoreType: 'rank',
      icon: Icons.gavel_outlined,
    ),
    ExamModel(
      id: 'nda',
      shortName: 'NDA',
      fullName: 'National Defence Academy Exam',
      conductingBody: 'UPSC',
      primaryCategory: CourseCategory.science,
      scoreType: 'rank',
      icon: Icons.military_tech_outlined,
    ),
    ExamModel(
      id: 'icar',
      shortName: 'ICAR AIEEA',
      fullName: 'All India Entrance Examination for Admission (ICAR)',
      conductingBody: 'NTA / ICAR',
      primaryCategory: CourseCategory.agriculture,
      scoreType: 'rank',
      icon: Icons.agriculture_outlined,
    ),
    ExamModel(
      id: 'state_cet',
      shortName: 'State CET',
      fullName: 'State Common Entrance Test',
      conductingBody: 'State CET Cell',
      primaryCategory: CourseCategory.engineering,
      scoreType: 'rank',
      icon: Icons.map_outlined,
    ),
  ];

  static ExamModel byId(String id) =>
      all.firstWhere((e) => e.id == id, orElse: () => all.first);
}
