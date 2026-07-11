import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../data/vault_mime.dart';
import '../data/vault_repository.dart';
import '../data/vault_upload_controller.dart';
import '../screens/vault_scanner_screen.dart';

/// Opens the "Upload Document" bottom sheet for [folderId] — gallery, camera,
/// PDF/DOC file picker (with multi-select), and a hand-off to the built-in
/// scanner. Every option actually uploads through [uploadToVaultWithFeedback].
Future<void> showVaultUploadSheet(
  BuildContext context, {
  required String folderId,
  String? documentTypeHint,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VaultUploadSheet(
        folderId: folderId, documentTypeHint: documentTypeHint),
  );
}

class _VaultUploadSheet extends ConsumerStatefulWidget {
  const _VaultUploadSheet({required this.folderId, this.documentTypeHint});

  final String folderId;
  final String? documentTypeHint;

  @override
  ConsumerState<_VaultUploadSheet> createState() => _VaultUploadSheetState();
}

class _VaultUploadSheetState extends ConsumerState<_VaultUploadSheet> {
  bool _busy = false;

  Future<void> _uploadBytes(Uint8List bytes, String name) async {
    setState(() => _busy = true);
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    await uploadToVaultWithFeedback(
      context,
      ref,
      bytes: bytes,
      fileName: name,
      mimeType: vaultMimeTypeFor(ext),
      folderId: widget.folderId,
      documentType: widget.documentTypeHint,
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _fromCamera() async {
    final file = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 88, maxWidth: 2200);
    if (file == null) return;
    await _uploadBytes(await file.readAsBytes(), file.name);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _fromGallery() async {
    final files =
        await ImagePicker().pickMultiImage(imageQuality: 88, maxWidth: 2200);
    if (files.isEmpty) return;
    for (final file in files) {
      await _uploadBytes(await file.readAsBytes(), file.name);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _fromFilePicker() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: vaultSupportedExtensions,
    );
    if (result == null) return;
    for (final f in result.files) {
      final bytes = await f.readAsBytes();
      await _uploadBytes(bytes, f.name);
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _openScanner() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VaultScannerScreen(
          folderId: widget.folderId,
          documentTypeHint: widget.documentTypeHint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Upload Document',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('PDF, JPG, PNG, WEBP, DOC, DOCX · up to 25 MB',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12.5)),
            const SizedBox(height: 20),
            if (_busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              )
            else ...[
              _UploadOption(
                icon: Icons.document_scanner_rounded,
                label: 'Scan Document',
                subtitle: 'Camera scan with auto filters',
                onTap: _openScanner,
              ),
              const SizedBox(height: 10),
              _UploadOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                subtitle: 'Quick single photo capture',
                onTap: _fromCamera,
              ),
              const SizedBox(height: 10),
              _UploadOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                subtitle: 'Select one or more images',
                onTap: _fromGallery,
              ),
              const SizedBox(height: 10),
              _UploadOption(
                icon: Icons.insert_drive_file_rounded,
                label: 'Choose PDF / DOC File',
                subtitle: 'Import existing files, multi-select supported',
                onTap: _fromFilePicker,
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  const _UploadOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: AppColors.accent, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}
