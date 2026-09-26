import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:path_provider/path_provider.dart';

const double _minScale = 1.0;
const double _maxScale = 5.0;
const int _outputSize = 1024;
const int _outputQuality = 90;

//! Kesish uchun kirish
class _CropRequest {
  final String sourcePath;
  final double sourceWidth;
  final double sourceHeight;
  final double cropSize;
  final double scale;
  final double offsetX;
  final double offsetY;

  const _CropRequest({
    required this.sourcePath,
    required this.sourceWidth,
    required this.sourceHeight,
    required this.cropSize,
    required this.scale,
    required this.offsetX,
    required this.offsetY,
  });
}

Future<Uint8List?> _cropInIsolate(_CropRequest request) async {
  final decoded = img.decodeImage(File(request.sourcePath).readAsBytesSync());
  if (decoded == null) return null;

  final baseScale = math.max(
    request.cropSize / request.sourceWidth,
    request.cropSize / request.sourceHeight,
  );
  final effectiveScale = baseScale * request.scale;

  final shownWidth = request.sourceWidth * effectiveScale;
  final shownHeight = request.sourceHeight * effectiveScale;

  final left =
      (shownWidth / 2 - request.cropSize / 2 - request.offsetX) /
      effectiveScale;
  final top =
      (shownHeight / 2 - request.cropSize / 2 - request.offsetY) /
      effectiveScale;
  final side = request.cropSize / effectiveScale;

  final cropped = img.copyCrop(
    decoded,
    x: left.round().clamp(0, decoded.width - 1),
    y: top.round().clamp(0, decoded.height - 1),
    width: side.round().clamp(1, decoded.width),
    height: side.round().clamp(1, decoded.height),
  );

  final resized = cropped.width > _outputSize
      ? img.copyResize(cropped, width: _outputSize, height: _outputSize)
      : cropped;

  return Uint8List.fromList(img.encodeJpg(resized, quality: _outputQuality));
}

/// Telegram uslubida: rasmni surib/kattalashtirib doira ichiga moslaydi.
/// Natija — kesilgan kvadrat JPEG fayli, bekor qilinsa `null`.
class AvatarCropperPage extends StatefulWidget {
  final File source;

  const AvatarCropperPage({super.key, required this.source});

  @override
  State<AvatarCropperPage> createState() => _AvatarCropperPageState();
}

class _AvatarCropperPageState extends State<AvatarCropperPage> {
  Size? _imageSize;
  double _scale = _minScale;
  Offset _offset = Offset.zero;
  bool _isCropping = false;

  double _startScale = _minScale;
  Offset _startOffset = Offset.zero;
  Offset _startFocal = Offset.zero;

  @override
  void initState() {
    super.initState();
    _readImageSize();
  }

  Future<void> _readImageSize() async {
    final stream = FileImage(widget.source).resolve(ImageConfiguration.empty);
    final completer = Completer<Size>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) {
          completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()),
          );
        }
        stream.removeListener(listener);
      },
      onError: (_, _) {
        if (!completer.isCompleted) completer.complete(Size.zero);
      },
    );
    stream.addListener(listener);

    final size = await completer.future;
    if (mounted) setState(() => _imageSize = size);
  }

  double _cropSize(BoxConstraints constraints) =>
      math.min(constraints.maxWidth - 48, constraints.maxHeight - 48);

  //! Doira doim rasm bilan to'lsin
  Offset _clampOffset(Offset value, Size shown, double cropSize) {
    final maxX = math.max(0.0, (shown.width - cropSize) / 2);
    final maxY = math.max(0.0, (shown.height - cropSize) / 2);
    return Offset(value.dx.clamp(-maxX, maxX), value.dy.clamp(-maxY, maxY));
  }

  Size _shownSize(double cropSize) {
    final image = _imageSize!;
    final baseScale = math.max(cropSize / image.width, cropSize / image.height);
    return Size(
      image.width * baseScale * _scale,
      image.height * baseScale * _scale,
    );
  }

  Future<void> _apply(double cropSize) async {
    if (_isCropping || _imageSize == null) return;
    setState(() => _isCropping = true);

    final bytes = await compute(
      _cropInIsolate,
      _CropRequest(
        sourcePath: widget.source.path,
        sourceWidth: _imageSize!.width,
        sourceHeight: _imageSize!.height,
        cropSize: cropSize,
        scale: _scale,
        offsetX: _offset.dx,
        offsetY: _offset.dy,
      ),
    );

    if (!mounted) return;
    if (bytes == null) {
      setState(() => _isCropping = false);
      Navigator.of(context).pop();
      return;
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes);

    if (mounted) Navigator.of(context).pop(file);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: Text(
          l.adjustPhotoTitle,
          style: AppTextStyles.source.semiBold(
            fontSize: 17,
            color: AppColors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: _imageSize == null || _imageSize == Size.zero
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final cropSize = _cropSize(constraints);
                final shown = _shownSize(cropSize);

                return GestureDetector(
                  onScaleStart: (details) {
                    _startScale = _scale;
                    _startOffset = _offset;
                    _startFocal = details.focalPoint;
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      _scale = (_startScale * details.scale).clamp(
                        _minScale,
                        _maxScale,
                      );
                      final moved = details.focalPoint - _startFocal;
                      final ratio = _scale / _startScale;
                      _offset = _clampOffset(
                        _startOffset * ratio + moved,
                        _shownSize(cropSize),
                        cropSize,
                      );
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //! Rasm
                      Center(
                        child: Transform.translate(
                          offset: _offset,
                          child: Image.file(
                            widget.source,
                            width: shown.width,
                            height: shown.height,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),

                      //! Doira maskasi
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _CircleMaskPainter(cropSize: cropSize),
                        ),
                      ),

                      //! Izoh
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 110,
                        child: Text(
                          l.adjustPhotoHint,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.source.regular(
                            fontSize: 13,
                            color: AppColors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),

                      //! Tugmalar
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 30,
                        child: SafeArea(
                          top: false,
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                    side: BorderSide(
                                      color: AppColors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  onPressed: _isCropping
                                      ? null
                                      : () => Navigator.of(context).pop(),
                                  child: Text(l.cancel),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isCropping
                                      ? null
                                      : () => _apply(cropSize),
                                  child: _isCropping
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(l.chooseButton),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _CircleMaskPainter extends CustomPainter {
  final double cropSize;

  const _CircleMaskPainter({required this.cropSize});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = cropSize / 2;

    final overlay = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    canvas.drawPath(
      overlay,
      Paint()..color = AppColors.black.withValues(alpha: 0.65),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_CircleMaskPainter oldDelegate) =>
      oldDelegate.cropSize != cropSize;
}
