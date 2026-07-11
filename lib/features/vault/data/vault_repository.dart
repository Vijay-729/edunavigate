import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/vault_document.dart';
import '../models/vault_folder.dart';
import 'vault_encryption_service.dart';

/// Extensions EduVault accepts for upload (spec: "Supported Files").
const vaultSupportedExtensions = [
  'pdf',
  'jpg',
  'jpeg',
  'png',
  'doc',
  'docx',
  'webp'
];

/// 25 MB per file — generous for scanned certificates/marksheets while
/// keeping storage costs sane.
const vaultMaxFileSizeBytes = 25 * 1024 * 1024;

class VaultUnsupportedFormatException implements Exception {
  const VaultUnsupportedFormatException(this.extension);
  final String extension;
}

class VaultFileTooLargeException implements Exception {
  const VaultFileTooLargeException(this.sizeBytes);
  final int sizeBytes;
}

/// Thrown by [VaultRepository.uploadDocument] when a document with the same
/// content already exists (spec: "The student should never need to upload
/// the same document twice").
class VaultDuplicateDocumentException implements Exception {
  const VaultDuplicateDocumentException(this.existing);
  final VaultDocument existing;
}

/// No network reachable at all.
class VaultNoInternetException implements Exception {}

/// Firestore/Storage metadata + encrypted-blob CRUD for EduVault. Every
/// document lives at `/users/{uid}/vaultDocuments/{docId}` (Firestore) and
/// `users/{uid}/vault/{docId}` (Storage) — both already scoped to
/// owner-only access by the app's existing security rules, so no rules
/// changes were needed for this feature.
class VaultRepository {
  VaultRepository(this._firestore, this._auth, this._storage, this._encryption);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final VaultEncryptionService _encryption;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user for EduVault.');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _docsCol =>
      _firestore.collection('users').doc(_uid).collection('vaultDocuments');

  CollectionReference<Map<String, dynamic>> get _foldersCol =>
      _firestore.collection('users').doc(_uid).collection('vaultFolders');

  Reference _storageRef(String docId) =>
      _storage.ref().child('users').child(_uid).child('vault').child(docId);

  Stream<List<VaultDocument>> watchDocuments() {
    return _docsCol.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => VaultDocument.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<VaultFolder>> watchCustomFolders() {
    return _foldersCol.orderBy('name').snapshots().map(
          (snap) => snap.docs
              .map((d) => VaultFolder.fromMap({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Future<VaultFolder> createCustomFolder({
    required String name,
    required String iconKey,
    required int colorValue,
  }) async {
    final ref = await _foldersCol.add({
      'name': name,
      'iconKey': iconKey,
      'colorValue': colorValue,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return VaultFolder.fromMap({
      'id': ref.id,
      'name': name,
      'iconKey': iconKey,
      'colorValue': colorValue,
    });
  }

  /// Documents in a deleted custom folder fall back to "Other" rather than
  /// disappearing.
  Future<void> deleteCustomFolder(String folderId) async {
    final docsInFolder =
        await _docsCol.where('folderId', isEqualTo: folderId).get();
    final batch = _firestore.batch();
    for (final doc in docsInFolder.docs) {
      batch.update(doc.reference, {'folderId': VaultFolders.other.id});
    }
    batch.delete(_foldersCol.doc(folderId));
    await batch.commit();
  }

  Future<VaultDocument?> findBySha256(String hash) async {
    final snap = await _docsCol.where('sha256', isEqualTo: hash).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return VaultDocument.fromMap(snap.docs.first.id, snap.docs.first.data());
  }

  /// Encrypts [bytes] and uploads them, then writes the Firestore metadata
  /// doc. Throws [VaultUnsupportedFormatException], [VaultFileTooLargeException]
  /// or [VaultDuplicateDocumentException] before touching the network when
  /// the corresponding problem is detected.
  Future<VaultDocument> uploadDocument({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    required String folderId,
    String? documentType,
    bool allowDuplicate = false,
  }) async {
    final ext =
        fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
    if (!vaultSupportedExtensions.contains(ext)) {
      throw VaultUnsupportedFormatException(ext);
    }
    if (bytes.lengthInBytes > vaultMaxFileSizeBytes) {
      throw VaultFileTooLargeException(bytes.lengthInBytes);
    }

    final hash = sha256.convert(bytes).toString();
    if (!allowDuplicate) {
      final existing = await findBySha256(hash);
      if (existing != null) throw VaultDuplicateDocumentException(existing);
    }

    final docRef = _docsCol.doc();
    Uint8List encrypted;
    try {
      encrypted = await _encryption.encryptBytes(bytes);
      await _storageRef(docRef.id).putData(
        encrypted,
        SettableMetadata(contentType: 'application/octet-stream'),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'unauthorized' || e.code == 'permission-denied') rethrow;
      throw VaultNoInternetException();
    }

    final now = DateTime.now();
    final document = VaultDocument(
      id: docRef.id,
      name: fileName,
      originalFileName: fileName,
      folderId: folderId,
      documentType: documentType,
      mimeType: mimeType,
      sizeBytes: bytes.lengthInBytes,
      storagePath: _storageRef(docRef.id).fullPath,
      sha256: hash,
      createdAt: now,
      updatedAt: now,
    );
    await docRef.set(document.toMap());
    return document;
  }

  /// Downloads and decrypts a document's bytes. Reads the blob directly
  /// through the authenticated Storage SDK ([Reference.getData]) rather than
  /// ever minting a `getDownloadURL()` link — spec: "Never expose download
  /// URLs publicly."
  Future<Uint8List> downloadDecryptedBytes(VaultDocument doc) async {
    try {
      final data = await _storage
          .ref(doc.storagePath)
          .getData(vaultMaxFileSizeBytes * 2);
      if (data == null) throw VaultNoInternetException();
      return _encryption.decryptBytes(data);
    } on FirebaseException {
      throw VaultNoInternetException();
    }
  }

  Future<void> _update(String id, Map<String, dynamic> patch) {
    return _docsCol.doc(id).update({
      ...patch,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> renameDocument(String id, String newName) =>
      _update(id, {'name': newName});

  Future<void> moveDocument(String id, String newFolderId) =>
      _update(id, {'folderId': newFolderId});

  Future<void> toggleFavorite(String id, bool current) =>
      _update(id, {'favorite': !current});

  Future<void> togglePinned(String id, bool current) =>
      _update(id, {'pinned': !current});

  Future<void> updateNotes(String id, String notes) =>
      _update(id, {'notes': notes});

  Future<void> updateTags(String id, List<String> tags) =>
      _update(id, {'tags': tags});

  Future<void> updateExpiryDate(String id, DateTime? date) => _update(id, {
        'expiryDate': date == null ? null : Timestamp.fromDate(date),
      });

  /// Patches OCR/AI results after upload (see `VaultOcrService`,
  /// `VaultAiService`) — kept separate from [uploadDocument] so a slow/failed
  /// AI pass never blocks the upload itself from succeeding.
  Future<void> updateAiResults(
    String id, {
    String? ocrText,
    Map<String, String>? detectedFields,
    DateTime? expiryDate,
    String? aiSummary,
    bool? blurDetected,
  }) {
    return _update(id, {
      if (ocrText != null) 'ocrText': ocrText,
      if (detectedFields != null) 'detectedFields': detectedFields,
      if (expiryDate != null) 'expiryDate': Timestamp.fromDate(expiryDate),
      if (aiSummary != null) 'aiSummary': aiSummary,
      if (blurDetected != null) 'blurDetected': blurDetected,
    });
  }

  Future<void> recordViewed(String id) => _docsCol
      .doc(id)
      .update({'lastViewedAt': Timestamp.fromDate(DateTime.now())});

  Future<VaultDocument> copyDocument(VaultDocument doc,
      {String? toFolderId}) async {
    final encryptedBytes =
        await _storage.ref(doc.storagePath).getData(vaultMaxFileSizeBytes * 2);
    if (encryptedBytes == null) throw VaultNoInternetException();

    final newRef = _docsCol.doc();
    await _storageRef(newRef.id).putData(
      encryptedBytes,
      SettableMetadata(contentType: 'application/octet-stream'),
    );
    final now = DateTime.now();
    final copy = VaultDocument(
      id: newRef.id,
      name: '${doc.name} (Copy)',
      originalFileName: doc.originalFileName,
      folderId: toFolderId ?? doc.folderId,
      documentType: doc.documentType,
      mimeType: doc.mimeType,
      sizeBytes: doc.sizeBytes,
      storagePath: _storageRef(newRef.id).fullPath,
      sha256: doc.sha256,
      tags: doc.tags,
      ocrText: doc.ocrText,
      detectedFields: doc.detectedFields,
      expiryDate: doc.expiryDate,
      createdAt: now,
      updatedAt: now,
    );
    await newRef.set(copy.toMap());
    return copy;
  }

  Future<void> deleteDocument(VaultDocument doc) async {
    try {
      await _storage.ref(doc.storagePath).delete();
    } on FirebaseException {
      // Already-missing blob shouldn't block removing the metadata row.
    }
    await _docsCol.doc(doc.id).delete();
  }

  /// "Delete Vault" (Settings) — removes every document + custom folder.
  /// The PIN/biometric flag reset is handled separately by
  /// `VaultAuthService.resetSecurity()`.
  Future<void> deleteEverything() async {
    final docs = await _docsCol.get();
    for (final d in docs.docs) {
      final doc = VaultDocument.fromMap(d.id, d.data());
      await deleteDocument(doc);
    }
    final folders = await _foldersCol.get();
    final batch = _firestore.batch();
    for (final f in folders.docs) {
      batch.delete(f.reference);
    }
    await batch.commit();
  }
}

final vaultRepositoryProvider = Provider<VaultRepository>(
  (ref) => VaultRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseStorageProvider),
    ref.watch(vaultEncryptionServiceProvider),
  ),
);
