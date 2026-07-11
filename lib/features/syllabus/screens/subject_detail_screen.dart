import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/providers/firebase_providers.dart';
import '../models/syllabus_models.dart';
import '../data/syllabus_repository.dart';
import '../providers/syllabus_providers.dart';
import 'pdf_viewer_screen.dart';

/// Opens a Notes link in an in-app browser tab, falling back to the device
/// browser if that fails. Shows a snackbar if the link can't be opened.
Future<void> _openNoteLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes not available yet.')),
    );
    return;
  }
  final opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView) ||
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this link.')),
    );
  }
}

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({
    super.key,
    required this.classCode,
    required this.subject,
    this.board,
  });

  final String classCode;
  final SyllabusSubject subject;

  /// Falls back to the persisted boardPreferenceProvider when null.
  final Board? board;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            subject.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: false,
          bottom: TabBar(
            indicatorColor: subject.color,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
            tabs: const [
              Tab(text: 'Theory'),
              Tab(text: 'Notes'),
              Tab(text: 'PYQs'),
            ],
          ),
        ),
        body: GradientBackground(
          extendBehindAppBar: true,
          child: TabBarView(
            children: [
              _TheoryTab(classCode: classCode, subject: subject, board: board),
              _NotesTab(classCode: classCode, subject: subject, board: board),
              _PyqsTab(classCode: classCode, subject: subject, board: board),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Theory Tab ───────────────────────────────────────────────────────────────

class _TheoryTab extends ConsumerWidget {
  const _TheoryTab({
    required this.classCode,
    required this.subject,
    this.board,
  });

  final String classCode;
  final SyllabusSubject subject;
  final Board? board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';
    final resolvedBoard =
        board ?? ref.watch(boardPreferenceProvider) ?? Board.cbse;
    final progressAsync = ref.watch(
        syllabusProgressProvider((resolvedBoard, classCode, subject.code)));

    return progressAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => _ErrorState(
        onRetry: () => ref.invalidate(
          syllabusProgressProvider((resolvedBoard, classCode, subject.code)),
        ),
      ),
      data: (progress) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
          itemCount: subject.chapters.length,
          itemBuilder: (context, i) {
            return _ChapterAccordion(
              classCode: classCode,
              subject: subject,
              chapter: subject.chapters[i],
              progress: progress,
              uid: uid,
              board: resolvedBoard,
              ref: ref,
            );
          },
        );
      },
    );
  }
}

class _ChapterAccordion extends StatefulWidget {
  const _ChapterAccordion({
    required this.classCode,
    required this.subject,
    required this.chapter,
    required this.progress,
    required this.uid,
    required this.board,
    required this.ref,
  });

  final String classCode;
  final SyllabusSubject subject;
  final SyllabusChapter chapter;
  final Map<String, bool> progress;
  final String uid;
  final Board board;
  final WidgetRef ref;

  @override
  State<_ChapterAccordion> createState() => _ChapterAccordionState();
}

class _ChapterAccordionState extends State<_ChapterAccordion>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconTurn = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _doneCount() {
    var count = 0;
    for (final topic in widget.chapter.topics) {
      final key =
          topicKey(widget.subject.code, '${widget.chapter.id}_${topic.id}');
      if (widget.progress[key] == true) count++;
    }
    return count;
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.chapter.topics.length;
    final done = _doneCount();
    final allDone = done == total;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allDone
              ? widget.subject.color.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: allDone
                          ? widget.subject.color.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      allDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: allDone ? widget.subject.color : Colors.white38,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chapter.title,
                          style: TextStyle(
                            color:
                                allDone ? widget.subject.color : Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$done / $total topics done',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _iconTurn,
                    child: const Icon(Icons.expand_more, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _expanded
                ? Column(
                    children: [
                      Divider(
                        color: Colors.white.withValues(alpha: 0.07),
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                      ),
                      ...widget.chapter.topics.map((topic) {
                        final key = topicKey(
                          widget.subject.code,
                          '${widget.chapter.id}_${topic.id}',
                        );
                        final checked = widget.progress[key] ?? false;
                        return _TopicRow(
                          topic: topic,
                          isChecked: checked,
                          accentColor: widget.subject.color,
                          onChanged: (val) {
                            HapticFeedback.selectionClick();
                            widget.ref
                                .read(syllabusRepositoryProvider)
                                .setTopicDone(
                                  uid: widget.uid,
                                  board: widget.board,
                                  classCode: widget.classCode,
                                  subjectCode: widget.subject.code,
                                  key: key,
                                  value: val ?? false,
                                );
                          },
                        );
                      }),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.topic,
    required this.isChecked,
    required this.accentColor,
    required this.onChanged,
  });

  final SyllabusTopic topic;
  final bool isChecked;
  final Color accentColor;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: accentColor,
                checkColor: Colors.white,
                side: BorderSide(
                  color: isChecked ? accentColor : Colors.white30,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                topic.title,
                style: TextStyle(
                  color: isChecked
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.white,
                  fontSize: 13.5,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notes Tab ────────────────────────────────────────────────────────────────

class _NotesTab extends ConsumerWidget {
  const _NotesTab({
    required this.classCode,
    required this.subject,
    this.board,
  });

  final String classCode;
  final SyllabusSubject subject;
  final Board? board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedBoard =
        board ?? ref.watch(boardPreferenceProvider) ?? Board.cbse;
    final notesAsync =
        ref.watch(notesProvider((resolvedBoard, classCode, subject.code, '')));

    return notesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => _ErrorState(
        onRetry: () => ref.invalidate(
          notesProvider((resolvedBoard, classCode, subject.code, '')),
        ),
      ),
      data: (notes) {
        if (subject.chapters.isEmpty) {
          return const _EmptyState(
            icon: Icons.menu_book_outlined,
            title: 'No chapters found',
            message: 'This subject has no chapters yet.',
          );
        }
        final byChapter = <String, List<ContentItem>>{};
        for (final note in notes) {
          byChapter.putIfAbsent(note.chapterId, () => []).add(note);
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
          itemCount: subject.chapters.length,
          itemBuilder: (context, i) {
            final chapter = subject.chapters[i];
            return _NoteChapterCard(
              index: i + 1,
              chapter: chapter,
              items: byChapter[chapter.id] ?? const [],
              accentColor: subject.color,
            );
          },
        );
      },
    );
  }
}

class _NoteChapterCard extends StatelessWidget {
  const _NoteChapterCard({
    required this.index,
    required this.chapter,
    required this.items,
    required this.accentColor,
  });

  final int index;
  final SyllabusChapter chapter;
  final List<ContentItem> items;
  final Color accentColor;

  bool get _hasNotes => items.isNotEmpty;

  void _open(BuildContext context) {
    if (!_hasNotes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes not available yet.')),
      );
      return;
    }
    if (items.length == 1) {
      _openItem(context, items.first);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgTop,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _NotesPickerSheet(items: items, accentColor: accentColor),
    );
  }

  void _openItem(BuildContext context, ContentItem item) {
    if (item.fileUrl == null || item.fileUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes not available yet.')),
      );
      return;
    }
    _openNoteLink(context, item.fileUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hasNotes
                ? accentColor.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$index',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 14,
                        color: _hasNotes ? accentColor : Colors.white24,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _hasNotes ? 'View Notes' : 'Notes not available yet',
                        style: TextStyle(
                          color: _hasNotes
                              ? accentColor
                              : Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              _hasNotes
                  ? Icons.chevron_right_rounded
                  : Icons.lock_outline_rounded,
              color: _hasNotes
                  ? Colors.white54
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesPickerSheet extends StatelessWidget {
  const _NotesPickerSheet({required this.items, required this.accentColor});

  final List<ContentItem> items;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a note',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.link_rounded, color: accentColor),
                title: Text(item.title,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  if (item.fileUrl == null || item.fileUrl!.isEmpty) return;
                  _openNoteLink(context, item.fileUrl!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PYQs Tab ─────────────────────────────────────────────────────────────────

class _PyqsTab extends ConsumerStatefulWidget {
  const _PyqsTab({
    required this.classCode,
    required this.subject,
    this.board,
  });

  final String classCode;
  final SyllabusSubject subject;
  final Board? board;

  @override
  ConsumerState<_PyqsTab> createState() => _PyqsTabState();
}

class _PyqsTabState extends ConsumerState<_PyqsTab> {
  static const _pyqBoards = ['', 'CBSE', 'ICSE', 'State Board'];
  static const _pyqBoardLabels = ['All Boards', 'CBSE', 'ICSE', 'State Board'];

  @override
  Widget build(BuildContext context) {
    final resolvedBoard =
        widget.board ?? ref.watch(boardPreferenceProvider) ?? Board.cbse;
    final selectedPyqBoard = ref.watch(selectedPyqBoardProvider);
    final pyqsAsync = ref.watch(pyqsProvider((
      resolvedBoard,
      widget.classCode,
      widget.subject.code,
      '',
      selectedPyqBoard
    )));

    return Column(
      children: [
        // Board filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 8),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _pyqBoards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final filterBoard = _pyqBoards[i];
                final isSelected = selectedPyqBoard == filterBoard;
                return GestureDetector(
                  onTap: () => ref
                      .read(selectedPyqBoardProvider.notifier)
                      .state = filterBoard,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.subject.color.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? widget.subject.color
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      _pyqBoardLabels[i],
                      style: TextStyle(
                        color:
                            isSelected ? widget.subject.color : Colors.white60,
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Expanded(
          child: pyqsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (_, __) => _ErrorState(
              onRetry: () => ref.invalidate(pyqsProvider((
                resolvedBoard,
                widget.classCode,
                widget.subject.code,
                '',
                selectedPyqBoard
              ))),
            ),
            data: (pyqs) {
              if (pyqs.isEmpty) {
                return _EmptyState(
                  icon: Icons.history_edu_outlined,
                  title: 'No papers yet',
                  message:
                      'Previous year papers for ${widget.subject.name} haven\'t been uploaded yet.',
                );
              }
              return _ContentList(
                  items: pyqs, accentColor: widget.subject.color);
            },
          ),
        ),
      ],
    );
  }
}

// ─── Shared content list ──────────────────────────────────────────────────────

class _ContentList extends StatelessWidget {
  const _ContentList({required this.items, required this.accentColor});

  final List<ContentItem> items;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, i) {
        return _ContentCard(item: items[i], accentColor: accentColor);
      },
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.item, required this.accentColor});

  final ContentItem item;
  final Color accentColor;

  void _open(BuildContext context) {
    if (!item.isAvailable || item.fileUrl == null || item.fileUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paper not available yet.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PdfViewerScreen(
          title: item.title,
          fileUrl: item.fileUrl!,
          storageKey: item.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isImage = item.fileType == 'image';
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
                color: accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.chapterTitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.chapterTitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                  if (item.board != null || item.year != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (item.board != null)
                          _Tag(label: item.board!, color: accentColor),
                        if (item.board != null && item.year != null)
                          const SizedBox(width: 6),
                        if (item.year != null)
                          _Tag(label: item.year!, color: Colors.white38),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              item.isAvailable
                  ? Icons.open_in_new_rounded
                  : Icons.lock_outline_rounded,
              color: item.isAvailable
                  ? accentColor
                  : Colors.white.withValues(alpha: 0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Shared states ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: Colors.white38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load content. Check your connection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
