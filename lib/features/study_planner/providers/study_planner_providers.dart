import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/study_task_repository.dart';
import '../models/study_task.dart';

/// The day currently selected in the planner week strip.
final selectedPlannerDayProvider = StateProvider<DateTime>(
  (ref) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  },
);

/// Daily study goal in minutes (default 240 = 4 hours).
final dailyGoalMinutesProvider = StateProvider<int>((ref) => 240);

/// Elapsed seconds of the currently-active focus session (0 when no session
/// is running). Updated every second by FocusModeScreen and reset to 0 on exit.
final activeSessionElapsedSecondsProvider = StateProvider<int>((ref) => 0);

/// Live stream of tasks for the selected day and the current user.
final plannerTasksProvider = StreamProvider.autoDispose<List<StudyTask>>((ref) {
  final uid = ref.watch(authStateProvider).asData?.value?.uid;
  if (uid == null) return const Stream.empty();

  final day = ref.watch(selectedPlannerDayProvider);
  return ref.watch(studyTaskRepositoryProvider).watchTasksForDay(uid, day);
});

/// Live stream of tasks for the current week (Monday → Sunday).
final weeklyTasksProvider = StreamProvider.autoDispose<List<StudyTask>>((ref) {
  final uid = ref.watch(authStateProvider).asData?.value?.uid;
  if (uid == null) return const Stream.empty();

  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  final weekStart = DateTime(monday.year, monday.month, monday.day);

  return ref
      .watch(studyTaskRepositoryProvider)
      .watchTasksForWeek(uid, weekStart);
});

/// Minutes studied today (completed tasks) + seconds currently elapsed in the
/// active focus session. Updates in real-time while a session is running.
final studiedTodayMinutesProvider = Provider.autoDispose<int>((ref) {
  final tasks = ref.watch(plannerTasksProvider).asData?.value ?? [];
  final completedMinutes = tasks
      .where((t) => t.isCompleted)
      .fold(0, (sum, t) => sum + t.durationMinutes);
  final activeSeconds = ref.watch(activeSessionElapsedSecondsProvider);
  return completedMinutes + (activeSeconds ~/ 60);
});

/// Sessions completed today vs total.
final todaySessionsProvider = Provider.autoDispose<(int, int)>((ref) {
  final tasks = ref.watch(plannerTasksProvider).asData?.value ?? [];
  final done = tasks.where((t) => t.isCompleted).length;
  return (done, tasks.length);
});
