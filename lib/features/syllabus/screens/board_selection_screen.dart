import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/syllabus_models.dart';
import '../providers/syllabus_providers.dart';
import 'subjects_screen.dart';

/// Shown the first time a user opens the Syllabus from the dashboard.
/// If a board is already saved in SharedPreferences, we skip straight to
/// SubjectsScreen without showing this screen (handled at call site).
class BoardSelectionScreen extends ConsumerWidget {
  const BoardSelectionScreen({
    super.key,
    required this.classCode,
    required this.className,
  });

  final String classCode;
  final String className;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBoard = ref.watch(boardPreferenceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '$className — Select Board',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Which board are you studying?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This sets the syllabus, chapters, and content '
                  'for all subjects. You can change it later.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                ...Board.values.map(
                  (board) => _BoardCard(
                    board: board,
                    isSelected: currentBoard == board,
                    onTap: () => _select(context, ref, board),
                  ),
                ),
                const Spacer(),
                if (currentBoard != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _proceed(context, currentBoard),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _select(BuildContext context, WidgetRef ref, Board board) async {
    await ref.read(boardPreferenceProvider.notifier).select(board);
    if (!context.mounted) return;
    _proceed(context, board);
  }

  void _proceed(BuildContext context, Board board) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SubjectsScreen(
          classCode: classCode,
          className: className,
          board: board,
        ),
      ),
    );
  }
}

// ─── Board option card ────────────────────────────────────────────────────────

class _BoardCard extends StatelessWidget {
  const _BoardCard({
    required this.board,
    required this.isSelected,
    required this.onTap,
  });

  final Board board;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, subtitle, color) = _meta(board);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 24)
            else
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.25), size: 16),
          ],
        ),
      ),
    );
  }

  (IconData, String, Color) _meta(Board b) {
    switch (b) {
      case Board.cbse:
        return (
          Icons.school_outlined,
          'Central Board of Secondary Education — NCERT curriculum',
          const Color(0xFF3B82F6),
        );
      case Board.icse:
        return (
          Icons.menu_book_outlined,
          'Council for the Indian School Certificate Examinations',
          const Color(0xFF22C55E),
        );
      case Board.stateBoard:
        return (
          Icons.map_outlined,
          'State Government Board — Maharashtra (MSBSHSE) pattern',
          const Color(0xFFF97316),
        );
    }
  }
}
