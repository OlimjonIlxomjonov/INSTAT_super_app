import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/fetch_book_pages_use_case.dart';

const _fullPage = Rect.fromLTWH(0, 0, 1, 1);

class BookPageLoader {
  final int bookId;
  final FetchBookPagesUseCase fetchPages;

  BookPageLoader({required this.bookId, required this.fetchPages});

  static const _maxDecodeWidth = 1800;
  static const _probeWidth = 240;

  final _http = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.bytes,
    ),
  );
  final Map<int, int> _pageIds = {};
  final Map<int, Future<void>> _idRequests = {};
  final Map<int, Rect> _contentRects = {};
  Size _typicalContent = Size.zero;

  Future<ui.Image> renderPage(
    int pageNumber, {
    required bool fitContent,
    required Size pixelSize,
    required EdgeInsets pixelPadding,
    required ImageDecoderCallback decode,
  }) async {
    final id = await _resolvePageId(pageNumber);
    if (id == null) throw StateError('Book page id not found: $pageNumber');

    final source = await _decode(ApiUrls.bookPageImageUrl(id), decode);
    try {
      var content = _contentRects[pageNumber];
      if (content == null) {
        content = await _detectContent(source);
        _contentRects[pageNumber] = content;
        _updateTypicalContent();
      }
      return await _paintPage(
        source,
        _visibleRect(content, fitContent: fitContent),
        pixelSize,
        pixelPadding,
      );
    } finally {
      source.dispose();
    }
  }

  Future<int?> _resolvePageId(int pageNumber) async {
    for (final candidate in [pageNumber, pageNumber - 1, pageNumber + 1]) {
      if (_pageIds.containsKey(pageNumber)) break;
      final pending = _idRequests[candidate];
      if (pending == null) continue;
      try {
        await pending;
      } catch (e) {
        logger.e(e);
      }
    }
    final cached = _pageIds[pageNumber];
    if (cached != null) return cached;

    await _idRequests.putIfAbsent(pageNumber, () async {
      try {
        final pages = await fetchPages(
          BookPagesParams(bookId: bookId, pageNumber: pageNumber),
        );
        for (final page in pages) {
          _pageIds[page.pageNumber] = page.id;
        }
      } finally {
        _idRequests.remove(pageNumber);
      }
    });
    return _pageIds[pageNumber];
  }

  Future<ui.Image> _decode(String url, ImageDecoderCallback decode) async {
    final token = TokenStorageServiceImpl().getAccessToken();
    final response = await _http.get<List<int>>(
      url,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
    final data = response.data;
    if (data == null || data.isEmpty) throw StateError('Empty page: $url');

    final buffer = await ui.ImmutableBuffer.fromUint8List(
      data is Uint8List ? data : Uint8List.fromList(data),
    );
    final codec = await decode(
      buffer,
      getTargetSize: (width, height) => width > _maxDecodeWidth
          ? const ui.TargetImageSize(width: _maxDecodeWidth)
          : ui.TargetImageSize(width: width, height: height),
    );
    try {
      final frame = await codec.getNextFrame();
      return frame.image;
    } finally {
      codec.dispose();
    }
  }

  Future<ui.Image> _paintPage(
    ui.Image source,
    Rect visible,
    Size pixelSize,
    EdgeInsets pixelPadding,
  ) async {
    final width = math.max(1, pixelSize.width.round());
    final height = math.max(1, pixelSize.height.round());
    final bounds = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final sourceWidth = source.width.toDouble();
    final sourceHeight = source.height.toDouble();
    final sourceRect = Rect.fromLTWH(
      visible.left * sourceWidth,
      visible.top * sourceHeight,
      visible.width * sourceWidth,
      visible.height * sourceHeight,
    );
    final area = pixelPadding.deflateRect(bounds);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..drawRect(bounds, Paint()..color = const Color(0xFFFFFFFF));
    if (!sourceRect.isEmpty && !area.isEmpty) {
      final scale = math.min(
        area.width / sourceRect.width,
        area.height / sourceRect.height,
      );
      canvas.drawImageRect(
        source,
        sourceRect,
        Rect.fromCenter(
          center: area.center,
          width: sourceRect.width * scale,
          height: sourceRect.height * scale,
        ),
        Paint()
          ..filterQuality = FilterQuality.high
          ..isAntiAlias = true,
      );
    }

    final picture = recorder.endRecording();
    try {
      return await picture.toImage(width, height);
    } finally {
      picture.dispose();
    }
  }

  Rect _visibleRect(Rect content, {required bool fitContent}) {
    if (!fitContent || _isFullBleed(content)) return _fullPage;

    final width = math
        .max(content.width, math.max(_typicalContent.width, 0.45))
        .clamp(0.0, 1.0);
    final height = math
        .max(content.height, math.max(_typicalContent.height, 0.3))
        .clamp(0.0, 1.0);
    final left = (content.center.dx - width / 2).clamp(0.0, 1.0 - width);
    final top = content.top.clamp(0.0, 1.0 - height);
    return Rect.fromLTWH(left, top, width, height);
  }

  Future<Rect> _detectContent(ui.Image image) async {
    try {
      final width = math.min(_probeWidth, image.width);
      final height = math.max(1, (image.height * width / image.width).round());

      final recorder = ui.PictureRecorder();
      Canvas(recorder).drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        Paint()..filterQuality = FilterQuality.low,
      );
      final picture = recorder.endRecording();
      final probe = await picture.toImage(width, height);
      picture.dispose();
      final bytes = await probe.toByteData(format: ui.ImageByteFormat.rawRgba);
      probe.dispose();
      if (bytes == null) return _fullPage;

      return await compute(
        _findContentBounds,
        _ContentProbe(bytes.buffer.asUint8List(), width, height),
      );
    } catch (e) {
      logger.e(e);
      return _fullPage;
    }
  }

  void _updateTypicalContent() {
    final rects = _contentRects.values.where((r) => !_isFullBleed(r)).toList();
    if (rects.isEmpty) return;
    double median(List<double> values) {
      values.sort();
      return values[values.length ~/ 2];
    }

    _typicalContent = Size(
      median(rects.map((r) => r.width).toList()),
      median(rects.map((r) => r.height).toList()),
    );
  }

  static bool _isFullBleed(Rect rect) =>
      rect.width >= 0.9 && rect.height >= 0.9;

  void dispose() => _http.close();
}

@immutable
class BookPageImage extends ImageProvider<BookPageImage> {
  final BookPageLoader loader;
  final int pageNumber;
  final bool fitContent;
  final Size pixelSize;
  final EdgeInsets pixelPadding;
  final int generation;

  const BookPageImage({
    required this.loader,
    required this.pageNumber,
    required this.fitContent,
    required this.pixelSize,
    required this.pixelPadding,
    this.generation = 0,
  });

  @override
  Future<BookPageImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    BookPageImage key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(_load(decode));
  }

  Future<ImageInfo> _load(ImageDecoderCallback decode) async {
    final image = await loader.renderPage(
      pageNumber,
      fitContent: fitContent,
      pixelSize: pixelSize,
      pixelPadding: pixelPadding,
      decode: decode,
    );
    return ImageInfo(image: image);
  }

  @override
  bool operator ==(Object other) =>
      other is BookPageImage &&
      other.loader.bookId == loader.bookId &&
      other.pageNumber == pageNumber &&
      other.fitContent == fitContent &&
      other.pixelSize == pixelSize &&
      other.pixelPadding == pixelPadding &&
      other.generation == generation;

  @override
  int get hashCode => Object.hash(
    loader.bookId,
    pageNumber,
    fitContent,
    pixelSize,
    pixelPadding,
    generation,
  );
}

class _ContentProbe {
  final Uint8List pixels;
  final int width;
  final int height;

  const _ContentProbe(this.pixels, this.width, this.height);
}

Rect _findContentBounds(_ContentProbe probe) {
  final width = probe.width;
  final height = probe.height;
  final pixels = probe.pixels;
  final rows = List<int>.filled(height, 0);
  final columns = List<int>.filled(width, 0);

  for (var y = 0; y < height; y++) {
    var i = y * width * 4;
    for (var x = 0; x < width; x++, i += 4) {
      if (pixels[i + 3] < 128) continue;
      final luminance =
          (pixels[i] * 299 + pixels[i + 1] * 587 + pixels[i + 2] * 114) ~/ 1000;
      if (luminance < 210) {
        rows[y]++;
        columns[x]++;
      }
    }
  }

  final rowThreshold = math.max(1, (width * 0.004).ceil());
  final columnThreshold = math.max(1, (height * 0.004).ceil());
  final top = rows.indexWhere((c) => c >= rowThreshold);
  final bottom = rows.lastIndexWhere((c) => c >= rowThreshold);
  final left = columns.indexWhere((c) => c >= columnThreshold);
  final right = columns.lastIndexWhere((c) => c >= columnThreshold);
  if (top < 0 || left < 0) return _fullPage;

  const padding = 0.025;
  return Rect.fromLTRB(
    (left / width - padding).clamp(0.0, 1.0),
    (top / height - padding).clamp(0.0, 1.0),
    ((right + 1) / width + padding).clamp(0.0, 1.0),
    ((bottom + 1) / height + padding).clamp(0.0, 1.0),
  );
}
