import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/loan_providers.dart';
import '../services/loan_query_service.dart';
import '../widgets/loan_card.dart';
import 'loan_compare_screen.dart';
import 'loan_detail_screen.dart';

/// Search + filter + sort across every loan product (spec §Compare Loans).
class LoanListScreen extends ConsumerStatefulWidget {
  const LoanListScreen({super.key});

  @override
  ConsumerState<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends ConsumerState<LoanListScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredLoansProvider);
    final filter = ref.watch(loanFilterProvider);
    final savedIds =
        ref.watch(loanBookmarkIdsProvider).asData?.value ?? const {};
    final compareIds = ref.watch(loanCompareListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Education Loans'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                onChanged: (v) =>
                    ref.read(loanSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search bank or NBFC…',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterChipPill(
                    label: 'All',
                    selected:
                        filter.nbfcOnly == null && !filter.noCollateralOnly,
                    onTap: () => ref.read(loanFilterProvider.notifier).state =
                        const LoanFilter(),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'Banks',
                    selected: filter.nbfcOnly == false,
                    onTap: () => ref.read(loanFilterProvider.notifier).state =
                        filter.copyWith(nbfcOnly: false),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'NBFCs',
                    selected: filter.nbfcOnly == true,
                    onTap: () => ref.read(loanFilterProvider.notifier).state =
                        filter.copyWith(nbfcOnly: true),
                  ),
                  const SizedBox(width: 8),
                  FilterChipPill(
                    label: 'No Collateral',
                    selected: filter.noCollateralOnly,
                    onTap: () => ref.read(loanFilterProvider.notifier).state =
                        filter.copyWith(
                            noCollateralOnly: !filter.noCollateralOnly),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('${results.length} lenders',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showSortSheet(context),
                    icon: const Icon(Icons.swap_vert, size: 18),
                    label: const Text('Sort'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const EmptyStateView(
                      title: 'No matching lenders',
                      message: 'Try a different keyword or clear your filters.')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final loan = results[index];
                        return LoanCard(
                          loan: loan,
                          isSaved: savedIds.contains(loan.id),
                          isComparing: compareIds.contains(loan.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    LoanDetailScreen(loanId: loan.id)),
                          ),
                          onSave: () => ref
                              .read(loanBookmarkRepositoryProvider)
                              .toggle(loan.id, savedIds.contains(loan.id)),
                          onCompareToggle: () {
                            final ok = ref
                                .read(loanCompareListProvider.notifier)
                                .toggle(loan.id);
                            if (!ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You can compare up to 4 loans.')));
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: compareIds.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const LoanCompareScreen())),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${compareIds.length})'),
            )
          : null,
    );
  }

  void _showSortSheet(BuildContext context) {
    final current = ref.read(loanSortOrderProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0D2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort by',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...LoanSortOrder.values.map((order) {
              final selected = order == current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected ? AppColors.primary : Colors.white38),
                title: Text(order.label,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  ref.read(loanSortOrderProvider.notifier).state = order;
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
