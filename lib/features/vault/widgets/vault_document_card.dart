import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/vault_document.dart';

/// Compact card for a document — used in horizontal rails (Recent Uploads,
/// Recently Used, Favourites) and picker grids.
class VaultDocumentCard extends StatelessWidget {
  const VaultDocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    this.width = 148,
    this.selected = false,
  });

  final VaultDocument document;
  final VoidCallback onTap;
  final double width;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: selected ? 0.14 : 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : Colors.white.withValues(alpha: 0.09),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(document.typeIcon,
                      color: AppColors.accent, size: 19),
                ),
                const Spacer(),
                if (document.favorite)
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFBBF24), size: 18),
                if (document.pinned) ...[
                  const SizedBox(width: 2),
                  const Icon(Icons.push_pin_rounded,
                      color: Colors.white38, size: 14),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              document.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              document.sizeLabel,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
            ),
            if (document.isExpired || document.isExpiringSoon) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (document.isExpired ? Colors.red : Colors.orange)
                      .withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  document.isExpired ? 'Expired' : 'Expiring soon',
                  style: TextStyle(
                    color: document.isExpired
                        ? Colors.redAccent
                        : Colors.orangeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full-width list tile variant used inside folder/search screens.
class VaultDocumentListTile extends StatelessWidget {
  const VaultDocumentListTile({
    super.key,
    required this.document,
    required this.onTap,
    this.onLongPress,
    this.trailing,
    this.selected = false,
  });

  final VaultDocument document;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: selected ? 0.14 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: selected ? Border.all(color: AppColors.accent) : null,
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(document.typeIcon, color: AppColors.accent, size: 20),
        ),
        title: Text(
          document.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
        subtitle: Text(
          '${document.documentType ?? document.extension.toUpperCase()} · ${document.sizeLabel}',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
        ),
        trailing: trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (document.favorite)
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFBBF24), size: 18),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              ],
            ),
      ),
    );
  }
}
