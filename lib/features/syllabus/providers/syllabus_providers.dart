import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/syllabus_content.dart';
import '../data/syllabus_repository.dart';
import '../models/syllabus_models.dart';

// ─── Board preference (persisted to SharedPreferences) ────────────────────────

const _kBoardKey = 'selected_board';

/// Persists and restores the user's board choice across app launches.
/// Backed by SharedPreferences — no Firestore overhead.
class BoardPreferenceNotifier extends StateNotifier<Board?> {
  BoardPreferenceNotifier() : super(null);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kBoardKey);
    if (code != null) {
      state = BoardExtension.fromCode(code);
    }
  }

  Future<void> select(Board board) async {
    state = board;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBoardKey, board.code);
  }

  Future<void> clear() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kBoardKey);
  }
}

/// Persists the selected board across sessions.
/// null means "not yet chosen" → BoardSelectionScreen will prompt.
final boardPreferenceProvider =
    StateNotifierProvider<BoardPreferenceNotifier, Board?>((ref) {
  final notifier = BoardPreferenceNotifier();
  notifier.load(); // async load from SharedPreferences on first access
  return notifier;
});

// ─── Current user UID ─────────────────────────────────────────────────────────

final _uidProvider = Provider<String>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';
});

// ─── Subjects for a board + class ─────────────────────────────────────────────

/// Family key: (board, classCode).
final subjectsForBoardProvider =
    Provider.family<List<SyllabusSubject>, (Board, String)>((ref, key) {
  final (board, classCode) = key;
  return SyllabusContent.subjectsForBoard(board, classCode);
});

/// Convenience: reads board from the persistent preference.
/// Falls back to CBSE when no board is selected.
final subjectsForClassProvider =
    Provider.family<List<SyllabusSubject>, String>((ref, classCode) {
  final board = ref.watch(boardPreferenceProvider) ?? Board.cbse;
  return SyllabusContent.subjectsForBoard(board, classCode);
});

// ─── Topic-level progress for one subject ─────────────────────────────────────

/// Family key: (board, classCode, subjectCode).
final syllabusProgressProvider = StreamProvider.autoDispose
    .family<Map<String, bool>, (Board, String, String)>((ref, key) {
  final uid = ref.watch(_uidProvider);
  if (uid.isEmpty) return const Stream.empty();
  final (board, classCode, subjectCode) = key;
  return ref.watch(syllabusRepositoryProvider).watchProgress(
        uid: uid,
        board: board,
        classCode: classCode,
        subjectCode: subjectCode,
      );
});

// ─── Class-wide progress (all subjects) ───────────────────────────────────────

/// Family key: classCode (board is read from the persistent preference).
final classSyllabusProgressProvider = StreamProvider.autoDispose
    .family<({double fraction, int done, int total}), String>((ref, classCode) {
  final uid = ref.watch(_uidProvider);
  final board = ref.watch(boardPreferenceProvider) ?? Board.cbse;

  if (uid.isEmpty) {
    return Stream.value((fraction: 0.0, done: 0, total: 0));
  }

  final repo = ref.watch(syllabusRepositoryProvider);
  final subjects = SyllabusContent.subjectsForBoard(board, classCode);
  final total = subjects.fold<int>(0, (sum, s) => sum + s.totalTopics);

  return repo
      .watchClassProgress(uid: uid, board: board, classCode: classCode)
      .map((progressMap) {
    var done = 0;
    for (final subject in subjects) {
      final docId = '${board.code}_${classCode}_${subject.code}';
      final subjectProgress = progressMap[docId] ?? {};
      for (final chapter in subject.chapters) {
        for (final topic in chapter.topics) {
          final key = topicKey(subject.code, '${chapter.id}_${topic.id}');
          if (subjectProgress[key] == true) done++;
        }
      }
    }
    final fraction = total == 0 ? 0.0 : done / total;
    return (fraction: fraction, done: done, total: total);
  });
});

// ─── Notes ────────────────────────────────────────────────────────────────────

/// Family key: (board, classCode, subjectCode, chapterId).
/// Pass empty string for chapterId to fetch all chapters.
final notesProvider = FutureProvider.autoDispose
    .family<List<ContentItem>, (Board, String, String, String)>((ref, key) {
  final (board, classCode, subjectCode, chapterId) = key;
  return ref.watch(syllabusRepositoryProvider).fetchNotes(
        board: board,
        classCode: classCode,
        subjectCode: subjectCode,
        chapterId: chapterId.isEmpty ? null : chapterId,
      );
});

// ─── PYQs ─────────────────────────────────────────────────────────────────────

/// Family key: (board, classCode, subjectCode, chapterId, pyqBoard).
/// Pass empty strings to fetch without filtering.
final pyqsProvider = FutureProvider.autoDispose
    .family<List<ContentItem>, (Board, String, String, String, String)>(
        (ref, key) {
  final (board, classCode, subjectCode, chapterId, pyqBoard) = key;
  return ref.watch(syllabusRepositoryProvider).fetchPyqs(
        board: board,
        classCode: classCode,
        subjectCode: subjectCode,
        chapterId: chapterId.isEmpty ? null : chapterId,
        pyqBoard: pyqBoard.isEmpty ? null : pyqBoard,
      );
});

// ─── Selected PYQ board filter (screen-local, auto-disposed) ─────────────────

final selectedPyqBoardProvider = StateProvider.autoDispose<String>((ref) => '');
