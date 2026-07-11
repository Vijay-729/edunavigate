import 'package:flutter/material.dart';

import 'course_model.dart';

/// The five Class 12 streams the College Explorer/Predictor gate content on.
///
/// Every college shown to a student is filtered down to [CourseCategory]s
/// relevant to their stream — spec requirement: "College Explorer MUST NOT
/// show every college in India."
enum StudentStream { pcm, pcb, commerce, humanities, agriculture }

extension StudentStreamX on StudentStream {
  String get code => name;

  String get label {
    switch (this) {
      case StudentStream.pcm:
        return 'PCM';
      case StudentStream.pcb:
        return 'PCB';
      case StudentStream.commerce:
        return 'Commerce';
      case StudentStream.humanities:
        return 'Humanities';
      case StudentStream.agriculture:
        return 'Agriculture';
    }
  }

  String get tagline {
    switch (this) {
      case StudentStream.pcm:
        return 'Engineering, Architecture & Tech';
      case StudentStream.pcb:
        return 'Medical, Allied Health & Life Sciences';
      case StudentStream.commerce:
        return 'Business, Finance & Management';
      case StudentStream.humanities:
        return 'Arts, Law & Social Sciences';
      case StudentStream.agriculture:
        return 'Agriculture & Allied Sciences';
    }
  }

  IconData get icon {
    switch (this) {
      case StudentStream.pcm:
        return Icons.functions_rounded;
      case StudentStream.pcb:
        return Icons.biotech_outlined;
      case StudentStream.commerce:
        return Icons.show_chart_rounded;
      case StudentStream.humanities:
        return Icons.gavel_outlined;
      case StudentStream.agriculture:
        return Icons.agriculture_outlined;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case StudentStream.pcm:
        return const [Color(0xFF3B82F6), Color(0xFF60A5FA)];
      case StudentStream.pcb:
        return const [Color(0xFF22C55E), Color(0xFF4ADE80)];
      case StudentStream.commerce:
        return const [Color(0xFFF97316), Color(0xFFFB923C)];
      case StudentStream.humanities:
        return const [Color(0xFFA855F7), Color(0xFFC084FC)];
      case StudentStream.agriculture:
        return const [Color(0xFF14B8A6), Color(0xFF2DD4BF)];
    }
  }

  /// Course categories a student in this stream is eligible to explore.
  ///
  /// This is the single source of truth for the stream → course gating rule.
  List<CourseCategory> get eligibleCategories {
    switch (this) {
      case StudentStream.pcm:
        return const [
          CourseCategory.engineering,
          CourseCategory.architecture,
          CourseCategory.science,
          CourseCategory.design,
        ];
      case StudentStream.pcb:
        return const [
          CourseCategory.medical,
          CourseCategory.science,
        ];
      case StudentStream.commerce:
        return const [
          CourseCategory.commerce,
          CourseCategory.management,
        ];
      case StudentStream.humanities:
        return const [
          CourseCategory.arts,
          CourseCategory.law,
          CourseCategory.design,
          CourseCategory.management,
        ];
      case StudentStream.agriculture:
        return const [
          CourseCategory.agriculture,
        ];
    }
  }

  /// Entrance exam ids most relevant to this stream (used for quick filters
  /// and the predictor's exam dropdown ordering).
  List<String> get relevantExamIds {
    switch (this) {
      case StudentStream.pcm:
        return const ['jee_main', 'jee_advanced', 'cuet'];
      case StudentStream.pcb:
        return const ['neet', 'gat_b', 'icar'];
      case StudentStream.commerce:
        return const ['cuet'];
      case StudentStream.humanities:
        return const ['cuet', 'clat', 'nda'];
      case StudentStream.agriculture:
        return const ['icar', 'state_cet'];
    }
  }
}

/// Maps free-text data (e.g. [UserProfile.branch], which is a raw text field
/// filled in during onboarding) onto a [StudentStream]. Falls back to `null`
/// when nothing matches, so callers can prompt the student to pick manually.
class StreamClassifier {
  StreamClassifier._();

  static StudentStream? fromBranchText(String? branch) {
    if (branch == null) return null;
    final b = branch.trim().toLowerCase();
    if (b.isEmpty) return null;

    bool has(List<String> needles) => needles.any(b.contains);

    if (has(['pcb', 'bio']) &&
        !has(['pcm']) &&
        (has(['bio']) || has(['medical']))) {
      return StudentStream.pcb;
    }
    if (has(['pcm']) || (has(['physics']) && has(['math']))) {
      return StudentStream.pcm;
    }
    if (has(['pcb']) || has(['biology']) || has(['medical'])) {
      return StudentStream.pcb;
    }
    if (has(['commerce']) || has(['business']) || has(['accountancy'])) {
      return StudentStream.commerce;
    }
    if (has(['agriculture']) || has(['agri']) || has(['horticulture'])) {
      return StudentStream.agriculture;
    }
    if (has(['humanities']) ||
        has(['arts']) ||
        has(['science']) && has(['general'])) {
      return StudentStream.humanities;
    }
    if (b == 'science') return StudentStream.pcm;
    return null;
  }
}
