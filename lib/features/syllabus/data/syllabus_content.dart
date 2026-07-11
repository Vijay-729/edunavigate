import '../models/syllabus_models.dart';
import 'content_cbse.dart';
import 'content_icse.dart';
import 'content_state.dart';

/// Thin board-aware router.
/// All actual syllabus data lives in content_cbse.dart / content_icse.dart /
/// content_state.dart. Adding or updating content never requires touching this
/// file or any provider — just update the relevant board data file.
class SyllabusContent {
  SyllabusContent._();

  static List<SyllabusSubject> subjectsForBoard(Board board, String classCode) {
    switch (board) {
      case Board.icse:
        return ContentIcse.forClass(classCode);
      case Board.stateBoard:
        return ContentState.forClass(classCode);
      case Board.cbse:
        return ContentCbse.forClass(classCode);
    }
  }

  /// Kept for backward-compat — defaults to CBSE.
  static List<SyllabusSubject> subjectsForClass(String classCode) =>
      ContentCbse.forClass(classCode);
}
