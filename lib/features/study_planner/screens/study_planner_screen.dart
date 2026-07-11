import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/study_task_repository.dart';
import '../data/subject_data.dart';
import '../models/study_task.dart';
import '../providers/study_planner_providers.dart';
import 'focus_mode_screen.dart';
import 'planner_helpers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Root screen
// ─────────────────────────────────────────────────────────────────────────────

class StudyPlannerScreen extends ConsumerStatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  ConsumerState<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends ConsumerState<StudyPlannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _uid => ref.read(authStateProvider).asData?.value?.uid ?? '';

  Future<void> _showAddSessionDialog(DateTime selectedDay) async {
    final profile = ref.read(currentProfileProvider).asData?.value;
    final subjects = SubjectData.getSubjects(
      classOrYear: profile?.classOrYear ?? '',
      branch: profile?.branch ?? '',
      educationLevel: profile?.educationLevel ?? '',
    );

    String selectedSubject =
        subjects.isNotEmpty ? subjects.first : 'Mathematics';
    final chapterCtrl = TextEditingController();
    int durationMinutes = 45;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0D1F3C),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_task_rounded,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Study Session',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject dropdown
                  const Text('Subject',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSubject,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF0D1F3C),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54),
                        items: subjects
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Row(
                                    children: [
                                      Icon(subjectIcon(s),
                                          color: subjectColor(s), size: 16),
                                      const SizedBox(width: 8),
                                      Text(s),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setDlg(() => selectedSubject = v);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Chapter / Topic field
                  const Text('Chapter / Topic',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: chapterCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. Chapter 5 – Laws of Motion',
                      hintStyle:
                          const TextStyle(color: Colors.white30, fontSize: 13),
                      prefixIcon: const Icon(Icons.menu_book_outlined,
                          color: Colors.white30, size: 18),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Duration slider
                  Row(children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.white54, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Duration: ${formatMinutes(durationMinutes)}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ]),
                  Slider(
                    value: durationMinutes.toDouble(),
                    min: 15,
                    max: 180,
                    divisions: 11,
                    activeColor: AppColors.primary,
                    inactiveColor: Colors.white12,
                    onChanged: (v) => setDlg(() => durationMinutes = v.round()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.white38)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final chapter = chapterCtrl.text.trim();
                  if (chapter.isEmpty) return;

                  final now = DateTime.now();
                  final task = StudyTask(
                    id: '${_uid}_${now.millisecondsSinceEpoch}',
                    subject: selectedSubject,
                    goal: chapter,
                    date: selectedDay,
                    durationMinutes: durationMinutes,
                    isCompleted: false,
                    createdAt: now,
                  );

                  await ref
                      .read(studyTaskRepositoryProvider)
                      .addTask(_uid, task);

                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Add Session',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
    chapterCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedPlannerDayProvider);
    final tasksAsync = ref.watch(plannerTasksProvider);
    final goalMinutes = ref.watch(dailyGoalMinutesProvider);
    final studiedMinutes = ref.watch(studiedTodayMinutesProvider);
    final weeklyAsync = ref.watch(weeklyTasksProvider);

    final progressRatio =
        goalMinutes == 0 ? 0.0 : (studiedMinutes / goalMinutes).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.bgTop,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'study-planner-fab',
        onPressed: () => _showAddSessionDialog(selectedDay),
        backgroundColor: AppColors.primary,
        elevation: 6,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          // Decorative glow blob
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: const Color(0xFF0D1F3C),
              onRefresh: () async {
                ref.invalidate(plannerTasksProvider);
                ref.invalidate(weeklyTasksProvider);
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // ── AppBar ────────────────────────────────────────────────
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    floating: true,
                    elevation: 0,
                    title: const Text(
                      'Study Planner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Week Calendar ─────────────────────────────────
                          _WeekCalendar(
                            selectedDay: selectedDay,
                            weeklyTasks: weeklyAsync.asData?.value ?? [],
                            onDayTap: (day) => ref
                                .read(selectedPlannerDayProvider.notifier)
                                .state = day,
                          ),
                          const SizedBox(height: 20),

                          // ── Today's Goal ──────────────────────────────────
                          _TodaysGoalCard(
                            progressRatio: progressRatio,
                            studiedMinutes: studiedMinutes,
                            goalMinutes: goalMinutes,
                          ),
                          const SizedBox(height: 24),

                          // ── Day label ─────────────────────────────────────
                          Text(
                            _dayLabel(selectedDay),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Tasks / Empty ─────────────────────────────────
                          tasksAsync.when(
                            loading: () => const _LoadingShimmer(),
                            error: (e, _) => Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Text('Error: $e',
                                    style:
                                        const TextStyle(color: Colors.white54)),
                              ),
                            ),
                            data: (tasks) => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: tasks.isEmpty
                                  ? _EmptyState(
                                      key: const ValueKey('empty'),
                                      onAdd: () =>
                                          _showAddSessionDialog(selectedDay),
                                    )
                                  : _TaskList(
                                      key: const ValueKey('tasks'),
                                      tasks: tasks,
                                      uid: _uid,
                                      ref: ref,
                                      entrance: _entranceCtrl,
                                      selectedDay: selectedDay,
                                    ),
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return "Today's Tasks";
    if (day == today.add(const Duration(days: 1))) return "Tomorrow's Tasks";
    const wd = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return "${wd[day.weekday - 1]}'s Tasks";
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's Goal Card  –  single simple progress section
// ─────────────────────────────────────────────────────────────────────────────

class _TodaysGoalCard extends StatelessWidget {
  const _TodaysGoalCard({
    required this.progressRatio,
    required this.studiedMinutes,
    required this.goalMinutes,
  });

  final double progressRatio;
  final int studiedMinutes;
  final int goalMinutes;

  @override
  Widget build(BuildContext context) {
    final pct = (progressRatio * 100).round();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            const Color(0xFF8B5CF6).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Today's Goal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progressRatio),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${formatMinutes(studiedMinutes)} / ${formatMinutes(goalMinutes)}',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Week Calendar
// ─────────────────────────────────────────────────────────────────────────────

class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar({
    required this.selectedDay,
    required this.weeklyTasks,
    required this.onDayTap,
  });

  final DateTime selectedDay;
  final List<StudyTask> weeklyTasks;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(7, (i) => today.add(Duration(days: i)));
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final taskDays = weeklyTasks.map((t) {
      final d = t.date;
      return DateTime(d.year, d.month, d.day);
    }).toSet();

    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: days.length,
        itemBuilder: (context, i) {
          final day = days[i];
          final isSelected = day == selectedDay;
          final isToday = day == today;
          final hasTasks = taskDays.contains(day);
          final completedCount = weeklyTasks.where((t) {
            final d = t.date;
            return DateTime(d.year, d.month, d.day) == day && t.isCompleted;
          }).length;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onDayTap(day);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 56,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      )
                    : null,
                color: isSelected
                    ? null
                    : isToday
                        ? Colors.white.withValues(alpha: 0.10)
                        : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : isToday
                          ? Colors.white.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.08),
                  width: isToday && !isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    labels[day.weekday - 1],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.87),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (hasTasks)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : completedCount > 0
                                ? const Color(0xFF22C55E)
                                : AppColors.accent,
                      ),
                    )
                  else
                    const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task List
// ─────────────────────────────────────────────────────────────────────────────

class _TaskList extends StatelessWidget {
  const _TaskList({
    super.key,
    required this.tasks,
    required this.uid,
    required this.ref,
    required this.entrance,
    required this.selectedDay,
  });

  final List<StudyTask> tasks;
  final String uid;
  final WidgetRef ref;
  final AnimationController entrance;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(tasks.length, (i) {
        final delay = (i * 0.1).clamp(0.0, 0.5);
        final animation = CurvedAnimation(
          parent: entrance,
          curve: Interval(delay, (delay + 0.5).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic),
        );
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero)
                  .animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: _TaskCard(
              task: tasks[i],
              onToggle: () => ref
                  .read(studyTaskRepositoryProvider)
                  .toggleComplete(uid, tasks[i]),
              onDelete: () => ref
                  .read(studyTaskRepositoryProvider)
                  .deleteTask(uid, tasks[i].id),
              onStart: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => FocusModeScreen(
                    task: tasks[i],
                    uid: uid,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task Card  –  subject, chapter, duration, Start button
// ─────────────────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onStart,
  });

  final StudyTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final color = subjectColor(task.subject);
    final isCompleted = task.isCompleted;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded,
                color: Color(0xFFEF4444), size: 24),
            SizedBox(height: 4),
            Text('Delete',
                style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? Colors.white.withValues(alpha: 0.06)
                : color.withValues(alpha: 0.30),
          ),
        ),
        child: Stack(
          children: [
            // Left color bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: 4,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.white12 : color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Subject icon
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onToggle();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.white.withValues(alpha: 0.05)
                            : color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_rounded
                            : subjectIcon(task.subject),
                        color: isCompleted ? Colors.white24 : color,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.subject,
                          style: TextStyle(
                            color: isCompleted ? Colors.white30 : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.white30,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task.goal,
                          style: TextStyle(
                            color: isCompleted
                                ? Colors.white.withValues(alpha: 0.20)
                                : Colors.white60,
                            fontSize: 12,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(children: [
                          Icon(Icons.timer_outlined,
                              size: 12,
                              color: isCompleted
                                  ? Colors.white24
                                  : AppColors.accent),
                          const SizedBox(width: 3),
                          Text(
                            formatMinutes(task.durationMinutes),
                            style: TextStyle(
                              color: isCompleted
                                  ? Colors.white24
                                  : AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Done ✓',
                                style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ]),
                      ],
                    ),
                  ),
                  // Start button (only if not completed)
                  if (!isCompleted)
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onStart();
                      },
                      child: const Text(
                        'Start',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15), width: 2),
            ),
            child: const Center(
              child: Text('📚', style: TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No sessions yet',
            style: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tap + to add your first study session for the day.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            ),
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            label: const Text(
              'Add Session',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Shimmer
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
