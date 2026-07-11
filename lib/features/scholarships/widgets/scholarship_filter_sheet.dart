import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/scholarship_providers.dart';

const _categoryOptions = [
  'SC',
  'ST',
  'OBC',
  'EWS',
  'Minority',
  'Girls',
  'Disabled'
];
const _classLevelOptions = ['Class 10', 'Class 12', 'UG', 'PG'];

/// Full filter bottom sheet — scope (Central/State), reservation category,
/// class/level, and Merit/Income-based toggles. Works on a local draft and
/// only commits via [onApply] so cancelling doesn't mutate provider state.
Future<void> showScholarshipFilterSheet(
  BuildContext context, {
  required ScholarshipFilter current,
  required ValueChanged<ScholarshipFilter> onApply,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheetBody(initial: current, onApply: onApply),
  );
}

class _FilterSheetBody extends StatefulWidget {
  const _FilterSheetBody({required this.initial, required this.onApply});

  final ScholarshipFilter initial;
  final ValueChanged<ScholarshipFilter> onApply;

  @override
  State<_FilterSheetBody> createState() => _FilterSheetBodyState();
}

class _FilterSheetBodyState extends State<_FilterSheetBody> {
  late ScholarshipFilter _draft = widget.initial;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D2040),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filters',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        TextButton(
                          onPressed: () =>
                              setState(() => _draft = _draft.clearAdvanced()),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _label('Scope'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChipPill(
                          label: 'Central',
                          selected: _draft.scopeKind == 'Central',
                          onTap: () => setState(() {
                            _draft = _draft.scopeKind == 'Central'
                                ? _draft.copyWith(clearScopeKind: true)
                                : _draft.copyWith(scopeKind: 'Central');
                          }),
                        ),
                        FilterChipPill(
                          label: 'State',
                          selected: _draft.scopeKind == 'State',
                          onTap: () => setState(() {
                            _draft = _draft.scopeKind == 'State'
                                ? _draft.copyWith(clearScopeKind: true)
                                : _draft.copyWith(scopeKind: 'State');
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _label('Basis'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChipPill(
                          label: 'Merit Based',
                          selected: _draft.meritBased,
                          onTap: () => setState(() => _draft =
                              _draft.copyWith(meritBased: !_draft.meritBased)),
                        ),
                        FilterChipPill(
                          label: 'Income Based',
                          selected: _draft.incomeBased,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              incomeBased: !_draft.incomeBased)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _label('Category'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categoryOptions.map((c) {
                        final selected = _draft.categories.contains(c);
                        return FilterChipPill(
                          label: c,
                          selected: selected,
                          onTap: () => setState(() {
                            final next = Set<String>.from(_draft.categories);
                            selected ? next.remove(c) : next.add(c);
                            _draft = _draft.copyWith(categories: next);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    _label('Class / Level'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _classLevelOptions.map((c) {
                        final selected = _draft.classLevels.contains(c);
                        return FilterChipPill(
                          label: c,
                          selected: selected,
                          onTap: () => setState(() {
                            final next = Set<String>.from(_draft.classLevels);
                            selected ? next.remove(c) : next.add(c);
                            _draft = _draft.copyWith(classLevels: next);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: PrimaryButton(
                  label: 'Apply Filters',
                  onPressed: () {
                    widget.onApply(_draft);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w700),
        ),
      );
}
