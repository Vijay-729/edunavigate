import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../data/vault_repository.dart';
import '../models/vault_folder.dart';

const List<Color> _vaultFolderColors = [
  Color(0xFF3B82F6),
  Color(0xFF22C55E),
  Color(0xFF8B5CF6),
  Color(0xFFF97316),
  Color(0xFFEC4899),
  Color(0xFFEAB308),
  Color(0xFF14B8A6),
  Color(0xFFEF4444),
];

/// "Create custom folder" bottom sheet — name, icon and colour pickers.
Future<void> showVaultNewFolderSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _VaultNewFolderSheet(),
  );
}

class _VaultNewFolderSheet extends ConsumerStatefulWidget {
  const _VaultNewFolderSheet();

  @override
  ConsumerState<_VaultNewFolderSheet> createState() =>
      _VaultNewFolderSheetState();
}

class _VaultNewFolderSheetState extends ConsumerState<_VaultNewFolderSheet> {
  final _nameController = TextEditingController();
  String _iconKey = 'folder';
  Color _color = _vaultFolderColors.first;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showAppSnack(context, 'Give your folder a name.');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(vaultRepositoryProvider).createCustomFolder(
            name: name,
            iconKey: _iconKey,
            colorValue: _color.toARGB32(),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        showAppSnack(context, 'Could not create the folder. Try again.');
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.dropdownSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('New Folder',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Folder name',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Icon',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: VaultFolderIcons.options.entries.map((entry) {
                  final selected = entry.key == _iconKey;
                  return GestureDetector(
                    onTap: () => setState(() => _iconKey = entry.key),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? _color.withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.06),
                        border: selected
                            ? Border.all(color: _color, width: 1.6)
                            : null,
                      ),
                      child: Icon(entry.value,
                          color: selected ? _color : Colors.white54, size: 20),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const Text('Colour',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _vaultFolderColors.map((c) {
                  final selected = c.toARGB32() == _color.toARGB32();
                  return GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                        border: selected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _create,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Create Folder',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
