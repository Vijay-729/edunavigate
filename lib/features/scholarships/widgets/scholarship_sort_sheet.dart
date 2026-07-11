import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/scholarship_providers.dart';

/// Bottom sheet radio-list for picking a [ScholarshipSortOrder].
Future<void> showScholarshipSortSheet(
  BuildContext context, {
  required ScholarshipSortOrder current,
  required ValueChanged<ScholarshipSortOrder> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D2040),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Text('Sort by',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          ...ScholarshipSortOrder.values.map((order) {
            final selected = order == current;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onSelected(order);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: selected ? AppColors.primary : Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(width: 14),
                      Text(order.label,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14.5)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
