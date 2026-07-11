import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/simple_calendar.dart';
import '../providers/exam_providers.dart';
import 'exam_detail_screen.dart';

/// Month-wise timeline of every exam's registration deadlines, admit-card
/// dates, exam dates, and result dates in one place.
class ExamCalendarScreen extends ConsumerWidget {
  const ExamCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(allExamDateEventsProvider);
    final now = DateTime.now();
    final upcomingEntries = entries
        .where((e) => e.event.date.isAfter(now))
        .toList()
      ..sort((a, b) => a.event.date.compareTo(b.event.date));
    final upcomingTop20 = upcomingEntries.take(20).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Calendar'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFF102846),
                  borderRadius: BorderRadius.circular(20)),
              child: SimpleCalendar(
                events: entries
                    .map((e) => CalendarEvent(
                          date: e.event.date,
                          title: '${e.exam.shortName} — ${e.event.label}',
                          color: AppColors.accent,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('All Upcoming Dates',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...upcomingTop20.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => ExamDetailScreen(examId: e.exam.id)),
                    ),
                    tileColor: Colors.white.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    leading: const Icon(Icons.event_outlined,
                        color: AppColors.accent),
                    title: Text('${e.exam.shortName} — ${e.event.label}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13.5)),
                    subtitle: Text(_formatDate(e.event.date),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
}
