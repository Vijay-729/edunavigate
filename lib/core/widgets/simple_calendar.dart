import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// One dated event shown on a [SimpleCalendar] and its agenda list.
class CalendarEvent {
  final DateTime date;
  final String title;
  final Color color;

  const CalendarEvent({
    required this.date,
    required this.title,
    this.color = AppColors.accent,
  });
}

/// A lightweight month-grid calendar (no external package) that marks days
/// with events and lets the student page between months. Tapping a marked
/// day shows its events in a bottom sheet. Shared by Counselling Guide and
/// Exam Universe calendars.
class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({super.key, required this.events, this.initialMonth});

  final List<CalendarEvent> events;
  final DateTime? initialMonth;

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  late DateTime _month;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    final now = widget.initialMonth ?? DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  List<CalendarEvent> _eventsOn(DateTime day) => widget.events
      .where((e) =>
          e.date.year == day.year &&
          e.date.month == day.month &&
          e.date.day == day.day)
      .toList();

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7; // Monday-first grid

    final monthEvents = widget.events
        .where(
            (e) => e.date.year == _month.year && e.date.month == _month.month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1)),
              icon: const Icon(Icons.chevron_left, color: Colors.white70),
            ),
            Text(
              _monthLabel(_month),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            IconButton(
              onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month + 1)),
              icon: const Icon(Icons.chevron_right, color: Colors.white70),
            ),
          ],
        ),
        Row(
          children: _weekdayLabels
              .map((w) => Expanded(
                    child: Center(
                      child: Text(w,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leadingBlanks + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final day =
                DateTime(_month.year, _month.month, index - leadingBlanks + 1);
            final events = _eventsOn(day);
            final isToday = _isSameDay(day, DateTime.now());
            return GestureDetector(
              onTap: events.isEmpty ? null : () => _showAgenda(day, events),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.03),
                  border: events.isNotEmpty
                      ? Border.all(color: events.first.color, width: 1.4)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${day.day}',
                        style: TextStyle(
                            color: isToday ? Colors.white : Colors.white70,
                            fontSize: 12.5,
                            fontWeight:
                                isToday ? FontWeight.w800 : FontWeight.w500)),
                    if (events.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: events.first.color, shape: BoxShape.circle),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        Text('This month',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (monthEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('No dated events this month.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
          )
        else
          ...monthEvents.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: e.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      child: Text('${e.date.day} ${_monthAbbrev(e.date.month)}',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Text(e.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  void _showAgenda(DateTime day, List<CalendarEvent> events) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D2040),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${day.day} ${_monthAbbrev(day.month)} ${day.year}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            ...events.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: e.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(e.title,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _monthLabel(DateTime d) => '${_months[d.month - 1]} ${d.year}';
  String _monthAbbrev(int month) => _months[month - 1].substring(0, 3);
}
