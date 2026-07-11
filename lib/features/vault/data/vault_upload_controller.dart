import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_fields.dart';
import '../models/vault_document.dart';
import 'vault_ai_service.dart';
import 'vault_ocr_service.dart';
import 'vault_offline_cache_service.dart';
import 'vault_repository.dart';
import 'vault_settings_repository.dart';

/// Shared "upload one file, with all the spec'd feedback and AI follow-up"
/// logic — used by the upload sheet, the scanner (multi-page PDF), and any
/// future "Choose from EduVault" style entry point.
///
/// Returns the created [VaultDocument], or `null` if the upload didn't
/// happen (unsupported format, too large, or the student declined to upload
/// a duplicate).
Future<VaultDocument?> uploadToVaultWithFeedback(
  BuildContext context,
  WidgetRef ref, {
  required Uint8List bytes,
  required String fileName,
  required String mimeType,
  required String folderId,
  String? documentType,
}) async {
  final repo = ref.read(vaultRepositoryProvider);

  Future<VaultDocument?> attemptUpload({bool allowDuplicate = false}) async {
    try {
      return await repo.uploadDocument(
        bytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
        folderId: folderId,
        documentType: documentType,
        allowDuplicate: allowDuplicate,
      );
    } on VaultUnsupportedFormatException catch (e) {
      if (context.mounted) {
        showAppSnack(
            context,
            'Unsupported file type ".${e.extension}". '
            'EduVault accepts PDF, JPG, PNG, WEBP, DOC and DOCX.');
      }
      return null;
    } on VaultFileTooLargeException {
      if (context.mounted) {
        showAppSnack(
            context,
            'That file is larger than 25 MB. Try a smaller '
            'scan or compress it first.');
      }
      return null;
    } on VaultDuplicateDocumentException catch (e) {
      if (!context.mounted) return null;
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF102040),
          title: const Text('Already in your vault',
              style: TextStyle(color: Colors.white)),
          content: Text(
            'This looks identical to "${e.existing.name}", already saved in '
            'your vault. Upload it again anyway?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Upload Anyway'),
            ),
          ],
        ),
      );
      if (proceed == true) return attemptUpload(allowDuplicate: true);
      return null;
    } on VaultNoInternetException {
      if (context.mounted) {
        showAppSnack(
            context,
            'No internet connection. Check your network '
            'and try again.');
      }
      return null;
    } catch (_) {
      if (context.mounted) {
        showAppSnack(context, 'Upload failed. Please try again.');
      }
      return null;
    }
  }

  final document = await attemptUpload();
  if (document != null) {
    // Fire-and-forget: OCR/AI enrichment must never block or fail an
    // upload that already succeeded.
    _runAiEnrichment(ref, document, bytes, mimeType);
    if (await ref.read(vaultSettingsRepositoryProvider).autoBackupEnabled()) {
      unawaited(
          ref.read(vaultOfflineCacheServiceProvider).write(document.id, bytes));
    }
  }
  return document;
}

Future<void> _runAiEnrichment(
  WidgetRef ref,
  VaultDocument document,
  Uint8List bytes,
  String mimeType,
) async {
  final repo = ref.read(vaultRepositoryProvider);
  try {
    final ocr = ref.read(vaultOcrServiceProvider);
    final isOcrCandidate =
        mimeType.startsWith('image/') || mimeType == 'application/pdf';
    if (!ocr.isConfigured || !isOcrCandidate) {
      return;
    }
    final result = await ocr.analyze(bytes,
        mimeType: mimeType, folderHint: document.folderId);
    if (result == null) return;

    final ai = ref.read(vaultAiServiceProvider);
    final summary = await ai.summarize(result.rawText);
    final blurred =
        mimeType.startsWith('image/') ? ai.detectBlur(bytes) : false;

    await repo.updateAiResults(
      document.id,
      ocrText: result.rawText.isEmpty ? null : result.rawText,
      detectedFields: result.fields.isEmpty ? null : result.fields,
      expiryDate: result.expiryDate,
      aiSummary: summary,
      blurDetected: blurred,
    );
    if (result.suggestedFileName != null &&
        result.suggestedFileName!.isNotEmpty &&
        document.name == document.originalFileName) {
      final ext = document.extension;
      final newName = ext.isEmpty
          ? result.suggestedFileName!
          : '${result.suggestedFileName}.$ext';
      await repo.renameDocument(document.id, newName);
    }
  } catch (_) {
    // Best-effort only — a failed AI pass shouldn't surface as an error
    // since the upload itself already succeeded.
  }
}
