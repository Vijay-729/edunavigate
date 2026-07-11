import 'package:flutter/material.dart';

/// One column (item being compared) in a [ComparisonTable].
class ComparisonColumn {
  final String title;
  final Color accent;

  /// Values aligned 1:1 with the parent table's `rowLabels`.
  final List<String> values;
  final VoidCallback? onRemove;

  const ComparisonColumn({
    required this.title,
    required this.accent,
    required this.values,
    this.onRemove,
  });
}

/// Horizontally-scrollable side-by-side comparison grid — a fixed label
/// column plus up to N item columns. Shared by College/Exam/Career compare
/// screens so the layout and interaction stay identical everywhere.
class ComparisonTable extends StatelessWidget {
  const ComparisonTable({
    super.key,
    required this.rowLabels,
    required this.columns,
    this.columnWidth = 170,
    this.rowHeight = 56,
    this.headerHeight = 130,
  });

  final List<String> rowLabels;
  final List<ComparisonColumn> columns;
  final double columnWidth;
  final double rowHeight;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8, top: headerHeight + 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowLabels
                  .map((l) => Container(
                        width: 120,
                        height: rowHeight,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          ...columns.map((col) => _ColumnView(
                column: col,
                rowLabelsCount: rowLabels.length,
                width: columnWidth,
                rowHeight: rowHeight,
                headerHeight: headerHeight,
              )),
        ],
      ),
    );
  }
}

class _ColumnView extends StatelessWidget {
  const _ColumnView({
    required this.column,
    required this.rowLabelsCount,
    required this.width,
    required this.rowHeight,
    required this.headerHeight,
  });

  final ComparisonColumn column;
  final int rowLabelsCount;
  final double width;
  final double rowHeight;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: column.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (column.onRemove != null)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: column.onRemove,
                child: const Icon(Icons.close, size: 16, color: Colors.white38),
              ),
            ),
          SizedBox(
            height: headerHeight,
            child: Text(
              column.title,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: column.accent,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          for (var i = 0; i < rowLabelsCount; i++)
            Container(
              height: rowHeight,
              alignment: Alignment.centerLeft,
              child: Text(
                i < column.values.length ? column.values[i] : '—',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
