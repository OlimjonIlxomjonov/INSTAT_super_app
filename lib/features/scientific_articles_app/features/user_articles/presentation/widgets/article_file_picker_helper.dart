import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ArticleFilePickerException implements Exception {
  final String message;

  const ArticleFilePickerException(this.message);
}

class ArticleFilePickerHelper {
  ArticleFilePickerHelper._();

  static const int maxFileSizeBytes = 50 * 1024 * 1024;

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static bool isAllowedExtension(String? extension, Set<String> allowed) {
    if (extension == null || extension.isEmpty) return false;
    return allowed.contains(extension.toLowerCase());
  }

  static Future<List<({File file, String name})>> pickFiles({
    required Set<String> allowedExtensions,
    required bool allowMultiple,
    required String invalidExtensionMessage,
    required String noFileChosenMessage,
    required String pickErrorMessage,
    bool useImagePickerFallback = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions.toList(),
        allowMultiple: allowMultiple,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return [];

      final picked = <({File file, String name})>[];
      for (final file in result.files) {
        if (!isAllowedExtension(file.extension, allowedExtensions)) {
          throw ArticleFilePickerException(invalidExtensionMessage);
        }
        final path = file.path;
        if (path == null) {
          throw ArticleFilePickerException(noFileChosenMessage);
        }
        picked.add((file: File(path), name: file.name));
      }
      return picked;
    } on ArticleFilePickerException {
      rethrow;
    } on MissingPluginException {
      if (!useImagePickerFallback || allowMultiple) {
        throw ArticleFilePickerException(pickErrorMessage);
      }
      final imagePicker = ImagePicker();
      final picked = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked == null) return [];
      final file = File(picked.path);
      return [(file: file, name: file.path.split('/').last)];
    } catch (_) {
      throw ArticleFilePickerException(pickErrorMessage);
    }
  }
}
