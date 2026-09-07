import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// OpenFilex turni kengaytma bo'yicha aniqlaydi — nomida u bo'lmasa,
/// manzildan olamiz.
String _resolveName(String url, String? fileName) {
  final segments = Uri.parse(url).pathSegments;
  final urlName = segments.isEmpty ? '' : segments.last;
  final name = (fileName != null && fileName.isNotEmpty) ? fileName : urlName;

  if (name.contains('.')) return name;
  final dot = urlName.lastIndexOf('.');
  return dot == -1 ? name : '$name${urlName.substring(dot)}';
}

/// Serverdagi faylni vaqtinchalik papkaga yuklab, tizim ilovasida ochadi.
Future<void> openRequestFile(
  BuildContext context, {
  required String? url,
  String? fileName,
}) async {
  final localization = AppLocalizations.of(context)!;

  if (url == null || url.isEmpty) {
    errorFlushBar(context, localization.fileUrlNotFound);
    return;
  }

  try {
    final tempDir = await getTemporaryDirectory();
    // Har xil so'rovlarda fayl nomi bir xil bo'lishi mumkin — manzil kaliti
    // qo'shilmasa, kesh eski faylni qaytaradi.
    final cacheKey = url.hashCode.toRadixString(16);
    final savePath = '${tempDir.path}/$cacheKey-${_resolveName(url, fileName)}';
    final file = File(savePath);

    if (!await file.exists() || await file.length() == 0) {
      await Dio().download(url, savePath);
    }

    final result = await OpenFilex.open(savePath);
    if (result.type != ResultType.done && context.mounted) {
      errorFlushBar(context, localization.fileOpenError(result.message));
    }
  } catch (_) {
    if (context.mounted) {
      errorFlushBar(context, localization.fileDownloadError);
    }
  }
}
