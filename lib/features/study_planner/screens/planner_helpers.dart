import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ─── Subject palette ────────────────────────────────────────────────────────

const Map<String, Color> kSubjectColors = {
  'dsa': Color(0xFF2563EB),
  'data structures': Color(0xFF2563EB),
  'data structure': Color(0xFF2563EB),
  'algorithm': Color(0xFF2563EB),
  'dbms': Color(0xFF22C55E),
  'database': Color(0xFF22C55E),
  'sql': Color(0xFF22C55E),
  'ai': Color(0xFF8B5CF6),
  'artificial intelligence': Color(0xFF8B5CF6),
  'machine learning': Color(0xFF8B5CF6),
  'ml': Color(0xFF8B5CF6),
  'os': Color(0xFFF97316),
  'operating system': Color(0xFFF97316),
  'operating systems': Color(0xFFF97316),
  'cn': Color(0xFFEF4444),
  'computer network': Color(0xFFEF4444),
  'computer networks': Color(0xFFEF4444),
  'networking': Color(0xFFEF4444),
  'mathematics': Color(0xFFEAB308),
  'math': Color(0xFFEAB308),
  'maths': Color(0xFFEAB308),
  'calculus': Color(0xFFEAB308),
  'statistics': Color(0xFFEAB308),
  'physics': Color(0xFF06B6D4),
  'chemistry': Color(0xFF10B981),
  'biology': Color(0xFF84CC16),
  'english': Color(0xFFF59E0B),
  'history': Color(0xFFA78BFA),
};

Color subjectColor(String subject) {
  final key = subject.toLowerCase().trim();
  for (final entry in kSubjectColors.entries) {
    if (key.contains(entry.key)) return entry.value;
  }
  return AppColors.primary;
}

IconData subjectIcon(String subject) {
  final key = subject.toLowerCase();
  if (key.contains('math') ||
      key.contains('calculus') ||
      key.contains('stat')) {
    return Icons.calculate_outlined;
  }
  if (key.contains('physics')) return Icons.science_outlined;
  if (key.contains('chem')) return Icons.biotech_outlined;
  if (key.contains('bio')) return Icons.eco_outlined;
  if (key.contains('history')) return Icons.history_edu_outlined;
  if (key.contains('english') || key.contains('literature')) {
    return Icons.menu_book_outlined;
  }
  if (key.contains('ai') || key.contains('machine') || key.contains('ml')) {
    return Icons.psychology_outlined;
  }
  if (key.contains('os') || key.contains('operating')) {
    return Icons.computer_outlined;
  }
  if (key.contains('network') || key.contains('cn')) return Icons.lan_outlined;
  if (key.contains('database') || key.contains('dbms') || key.contains('sql')) {
    return Icons.storage_outlined;
  }
  if (key.contains('dsa') ||
      key.contains('data struct') ||
      key.contains('algorithm')) {
    return Icons.account_tree_outlined;
  }
  return Icons.book_outlined;
}

// ─── Priority helpers ────────────────────────────────────────────────────────

Color priorityColor(String priority) {
  switch (priority) {
    case 'high':
      return const Color(0xFFEF4444);
    case 'low':
      return const Color(0xFF22C55E);
    default:
      return const Color(0xFFF97316);
  }
}

IconData priorityIcon(String priority) {
  switch (priority) {
    case 'high':
      return Icons.keyboard_double_arrow_up_rounded;
    case 'low':
      return Icons.keyboard_double_arrow_down_rounded;
    default:
      return Icons.remove_rounded;
  }
}

// ─── Motivational quotes ─────────────────────────────────────────────────────

const List<String> kMotivationQuotes = [
  '"Small progress every day leads to big success."',
  '"Consistency beats intensity."',
  '"Today\'s effort builds tomorrow\'s future."',
  '"Every expert was once a beginner."',
  '"Study hard in silence, let success make the noise."',
  '"The secret of getting ahead is getting started."',
  '"Don\'t watch the clock — do what it does. Keep going."',
];

// ─── Time formatting ─────────────────────────────────────────────────────────

String formatMinutes(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}
