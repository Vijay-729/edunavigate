import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Generic "nothing to show" state for the explorer and predictor, with
/// optional actionable suggestions (spec: "suggest nearby colleges, similar
/// courses, alternative states, alternative exams").
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            child: Icon(icon, color: Colors.white38, size: 38),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 13.5,
                height: 1.4),
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions
                  .map((s) => GestureDetector(
                        onTap: () => onSuggestionTap?.call(s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: 18),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
