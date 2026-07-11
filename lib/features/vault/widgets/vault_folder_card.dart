import 'package:flutter/material.dart';

import '../models/vault_folder.dart';

/// Grid card for a folder — preset or custom — showing its icon, name and
/// document count.
class VaultFolderCard extends StatelessWidget {
  const VaultFolderCard({
    super.key,
    required this.folder,
    required this.count,
    required this.onTap,
  });

  final VaultFolder folder;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: folder.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: folder.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: folder.color.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(folder.icon, color: folder.color, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              folder.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count == 1 ? '1 file' : '$count files',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}
