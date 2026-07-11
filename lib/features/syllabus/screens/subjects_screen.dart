import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/syllabus_models.dart';
import '../providers/syllabus_providers.dart';
import 'subject_detail_screen.dart';

class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({
    super.key,
    required this.classCode,
    required this.className,
    this.board,
  });

  final String classCode;
  final String className;

  /// When provided, overrides the persisted board preference for this session.
  final Board? board;

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board =
        widget.board ?? ref.watch(boardPreferenceProvider) ?? Board.cbse;

    final subjects =
        ref.watch(subjectsForBoardProvider((board, widget.classCode)));
    final classProgressAsync =
        ref.watch(classSyllabusProgressProvider(widget.classCode));

    final filtered = _query.isEmpty
        ? subjects
        : subjects
            .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${widget.className} Syllabus',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _changeBoard(context, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  board.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: Column(
            children: [
              // ─── Overall progress banner ──────────────────────────────────
              classProgressAsync.when(
                data: (prog) => _ProgressBanner(
                  fraction: prog.fraction,
                  done: prog.done,
                  total: prog.total,
                  className: widget.className,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // ─── Search bar ───────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search subjects…',
                    hintStyle:
                        TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.white54, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white54, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.07),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // ─── Subject grid ─────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptySearch()
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final subject = filtered[i];
                          return _SubjectCard(
                            subject: subject,
                            classCode: widget.classCode,
                            board: board,
                            onTap: () => _openSubject(context, subject, board),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSubject(
      BuildContext context, SyllabusSubject subject, Board board) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SubjectDetailScreen(
          classCode: widget.classCode,
          subject: subject,
          board: board,
        ),
      ),
    );
  }

  Future<void> _changeBoard(BuildContext context, WidgetRef ref) async {
    await ref.read(boardPreferenceProvider.notifier).clear();
    if (!context.mounted) return;
    // Pop back to the dashboard — BoardSelectionScreen will show next time.
    Navigator.of(context).pop();
  }
}

// ─── Overall progress banner ──────────────────────────────────────────────────

class _ProgressBanner extends StatelessWidget {
  const _ProgressBanner({
    required this.fraction,
    required this.done,
    required this.total,
    required this.className,
  });

  final double fraction;
  final int done;
  final int total;
  final String className;

  @override
  Widget build(BuildContext context) {
    final pct = (fraction * 100).round();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$className Overall Progress',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$done of $total topics completed',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Subject card ─────────────────────────────────────────────────────────────

class _SubjectCard extends ConsumerWidget {
  const _SubjectCard({
    required this.subject,
    required this.classCode,
    required this.board,
    required this.onTap,
  });

  final SyllabusSubject subject;
  final String classCode;
  final Board board;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync =
        ref.watch(syllabusProgressProvider((board, classCode, subject.code)));

    final completedTopics = progressAsync.maybeWhen(
      data: (map) {
        var count = 0;
        for (final chapter in subject.chapters) {
          for (final topic in chapter.topics) {
            final key = topicKey(subject.code, '${chapter.id}_${topic.id}');
            if (map[key] == true) count++;
          }
        }
        return count;
      },
      orElse: () => 0,
    );

    final total = subject.totalTopics;
    final fraction = total == 0 ? 0.0 : completedTopics / total;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: subject.color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(subject.icon, color: subject.color, size: 22),
            ),
            const Spacer(),
            Text(
              subject.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(subject.color),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$completedTopics / $total topics',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_outlined,
              size: 54, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          Text(
            'No subjects match your search',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
