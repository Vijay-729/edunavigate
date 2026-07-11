import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// Thin wrapper over `share_plus` so every module shares text/files the same
/// way (and so the sharing mechanism can change in one place later).
class ShareService {
  ShareService._();

  static Future<void> shareText(String text, {String? subject}) {
    return SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }

  static Future<void> shareFile(File file, {String? text}) {
    return SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: text),
    );
  }
}
