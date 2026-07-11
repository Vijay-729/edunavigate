/// Returns the correct subject list based on the student's class, stream, and board.
/// Never shows college-level subjects (DSA, DBMS, OS, CN, etc.).
class SubjectData {
  SubjectData._();

  static List<String> getSubjects({
    required String classOrYear,
    required String branch,
    required String educationLevel,
  }) {
    final classNum = _classNum(classOrYear);
    final b = branch.toLowerCase();

    // Class 6–8
    if (classNum >= 6 && classNum <= 8) {
      return [
        'Mathematics',
        'Science',
        'English',
        'Hindi',
        'Social Science',
        'Sanskrit',
        'Computer Science',
      ];
    }

    // Class 9–10
    if (classNum == 9 || classNum == 10) {
      return [
        'Mathematics',
        'Science',
        'English',
        'Hindi',
        'Social Science',
        'Sanskrit',
        'Computer Science',
        'Physical Education',
      ];
    }

    // Class 11–12
    if (classNum == 11 || classNum == 12) {
      return _streamSubjects(b);
    }

    // Fallback (unknown class string)
    return ['Mathematics', 'Science', 'English', 'Hindi', 'Social Science'];
  }

  static List<String> _streamSubjects(String branch) {
    // PCM / Engineering / Maths stream
    if (_has(branch, ['pcm', 'engineering', 'jee']) ||
        (_has(branch, ['science', 'sci']) &&
            !_has(branch, ['bio', 'pcb', 'medical', 'neet']))) {
      return [
        'Physics',
        'Chemistry',
        'Mathematics',
        'English',
        'Computer Science',
        'Physical Education',
      ];
    }

    // PCB / Medical / Biology stream
    if (_has(branch, ['pcb', 'bio', 'medical', 'neet'])) {
      return [
        'Physics',
        'Chemistry',
        'Biology',
        'English',
        'Computer Science',
        'Physical Education',
      ];
    }

    // Commerce
    if (_has(branch, ['commerce', 'account', 'business', 'eco', 'ca', 'cs'])) {
      return [
        'Accountancy',
        'Business Studies',
        'Economics',
        'English',
        'Mathematics',
        'Computer Science',
      ];
    }

    // Humanities / Arts
    if (_has(branch, [
      'humanities',
      'arts',
      'history',
      'political',
      'geography',
      'sociology',
      'psychology',
      'law',
      'upsc',
    ])) {
      return [
        'History',
        'Political Science',
        'Geography',
        'English',
        'Psychology',
        'Sociology',
        'Economics',
      ];
    }

    // Default — general science
    return [
      'Physics',
      'Chemistry',
      'Mathematics',
      'Biology',
      'English',
      'Computer Science',
    ];
  }

  static bool _has(String text, List<String> keywords) =>
      keywords.any((k) => text.contains(k));

  static int _classNum(String classOrYear) {
    final match = RegExp(r'(\d+)').firstMatch(classOrYear);
    if (match == null) return -1;
    return int.tryParse(match.group(1)!) ?? -1;
  }
}
