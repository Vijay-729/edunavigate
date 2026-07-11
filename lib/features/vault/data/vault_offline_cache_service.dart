import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Local on-device cache of decrypted document bytes, keyed by document id —
/// backs "Offline support: cache recently viewed files, offline viewing,
/// auto sync later." Lives in the app's private support directory, so it's
/// still sandboxed to this app even though it's unencrypted at rest (same
/// trust boundary as any other app cache).
class VaultOfflineCacheService {
  Future<Directory> _dir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/vault_cache');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _fileFor(String documentId) async {
    final dir = await _dir();
    return File('${dir.path}/$documentId.bin');
  }

  Future<void> write(String documentId, Uint8List bytes) async {
    final file = await _fileFor(documentId);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<Uint8List?> read(String documentId) async {
    final file = await _fileFor(documentId);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<void> remove(String documentId) async {
    final file = await _fileFor(documentId);
    if (await file.exists()) await file.delete();
  }

  Future<void> clearAll() async {
    final dir = await _dir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  Future<int> cacheSizeBytes() async {
    final dir = await _dir();
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }
}

final vaultOfflineCacheServiceProvider = Provider<VaultOfflineCacheService>(
  (ref) => VaultOfflineCacheService(),
);
