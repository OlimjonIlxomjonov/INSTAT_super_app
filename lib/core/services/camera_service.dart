import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

import '../utils/logger/logger.dart';

const bool kSilentCapture = true;
const int kLandscapeFrameRotation = 90;
const bool kMirrorFrontFrame = false;

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  String? _lastCaptureBase64;
  bool _isPermissionDenied = false;

  bool get isReady => _controller?.value.isInitialized ?? false;

  bool get isPermissionDenied => _isPermissionDenied;

  CameraController? get controller => _controller;

  String? get lastCaptureBase64 => _lastCaptureBase64;

  Future<void> init() async {
    try {
      final status = await Permission.camera.status;
      if (status.isPermanentlyDenied || status.isRestricted) {
        _isPermissionDenied = true;
        notifyListeners();
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
      } on CameraException catch (e) {
        if (_isPermissionError(e)) rethrow;

        try {
          await _controller!.dispose();
        } catch (_) {}
        _controller = CameraController(
          frontCamera,
          ResolutionPreset.low,
          enableAudio: false,
        );
        await _controller!.initialize();
      }

      await _controller!.setFlashMode(FlashMode.off);
      _isPermissionDenied = false;
      notifyListeners();
    } on CameraException catch (e) {
      logger.e('Camera init error: $e');
      if (_isPermissionError(e)) {
        _isPermissionDenied = true;
      }
      notifyListeners();
    } catch (e) {
      logger.e('Camera init error: $e');
    }
  }

  bool _isPermissionError(CameraException e) {
    final code = e.code.toLowerCase();
    return code.contains('permission') || code.contains('access');
  }

  Future<String?> captureBase64() async {
    if (!isReady) return null;

    try {
      img.Image? image = kSilentCapture ? await _grabStreamFrame() : null;
      image ??= await _takePictureFrame();
      if (image == null) return null;

      final pngBytes = img.encodePng(image);

      _lastCaptureBase64 = 'data:image/png;base64,${base64Encode(pngBytes)}';
      notifyListeners();
      return _lastCaptureBase64;
    } catch (e) {
      logger.f(' Capture error: $e');
      return null;
    }
  }

  //! Ovozsiz kadr
  Future<img.Image?> _grabStreamFrame() async {
    if (_controller!.value.isStreamingImages) {
      logger.e('⚠️ stream: already streaming');
      return null;
    }

    final completer = Completer<CameraImage?>();
    try {
      await _controller!.startImageStream((frame) {
        if (!completer.isCompleted) completer.complete(frame);
      });
    } catch (e) {
      logger.e('⚠️ stream: start failed → $e');
      return null;
    }

    CameraImage? frame;
    try {
      frame = await completer.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );
    } finally {
      try {
        await _controller!.stopImageStream();
      } catch (e) {
        logger.e('⚠️ stream: stop failed → $e');
      }
    }

    if (frame == null) {
      logger.e('⚠️ stream: no frame in 3s');
      return null;
    }

    return compute(
      _decodeFrame,
      _FrameData(
        width: frame.width,
        height: frame.height,
        format: frame.format.group,
        planes: [
          for (final plane in frame.planes)
            _PlaneData(
              bytes: plane.bytes,
              bytesPerRow: plane.bytesPerRow,
              bytesPerPixel: plane.bytesPerPixel ?? 1,
            ),
        ],
        sensorOrientation: _controller!.description.sensorOrientation,
        mirror:
            kMirrorFrontFrame &&
            _controller!.description.lensDirection == CameraLensDirection.front,
      ),
    );
  }

  //! Zaxira usul
  Future<img.Image?> _takePictureFrame() async {
    try {
      final file = await _controller!.takePicture();
      final decoded = img.decodeImage(await file.readAsBytes());
      return decoded == null ? null : img.bakeOrientation(decoded);
    } catch (e) {
      logger.e('takePicture fallback failed: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    super.dispose();
    await _controller?.dispose();
    _controller = null;
  }
}

//! Isolate uchun kadr
class _PlaneData {
  final Uint8List bytes;
  final int bytesPerRow;
  final int bytesPerPixel;

  const _PlaneData({
    required this.bytes,
    required this.bytesPerRow,
    required this.bytesPerPixel,
  });
}

class _FrameData {
  final int width;
  final int height;
  final ImageFormatGroup format;
  final List<_PlaneData> planes;
  final int sensorOrientation;
  final bool mirror;

  const _FrameData({
    required this.width,
    required this.height,
    required this.format,
    required this.planes,
    required this.sensorOrientation,
    required this.mirror,
  });
}

img.Image? _decodeFrame(_FrameData frame) {
  img.Image? decoded;

  switch (frame.format) {
    case ImageFormatGroup.bgra8888:
      decoded = _fromBgra(frame);
    case ImageFormatGroup.yuv420:
      decoded = _fromYuv420(frame);
    case ImageFormatGroup.jpeg:
      decoded = img.decodeImage(frame.planes.first.bytes);
    default:
      decoded = null;
  }

  if (decoded == null) return null;

  //! iOS oqim kadrni tik holda beradi, lekin sensorOrientation 90 deydi —
  //! shuning uchun burish faqat kadr gorizontal kelganda qo'llanadi.
  if (decoded.width > decoded.height) {
    decoded = img.copyRotate(decoded, angle: kLandscapeFrameRotation);
  }
  if (frame.mirror) {
    decoded = img.flipHorizontal(decoded);
  }
  return decoded;
}

img.Image _fromBgra(_FrameData frame) {
  final plane = frame.planes.first;
  final out = img.Image(width: frame.width, height: frame.height);

  for (var y = 0; y < frame.height; y++) {
    final rowStart = y * plane.bytesPerRow;
    for (var x = 0; x < frame.width; x++) {
      final i = rowStart + x * 4;
      out.setPixelRgb(
        x,
        y,
        plane.bytes[i + 2],
        plane.bytes[i + 1],
        plane.bytes[i],
      );
    }
  }
  return out;
}

img.Image _fromYuv420(_FrameData frame) {
  final yPlane = frame.planes[0];
  final uPlane = frame.planes[1];
  final vPlane = frame.planes[2];
  final out = img.Image(width: frame.width, height: frame.height);

  for (var y = 0; y < frame.height; y++) {
    final uvRow = (y >> 1) * uPlane.bytesPerRow;
    final yRow = y * yPlane.bytesPerRow;

    for (var x = 0; x < frame.width; x++) {
      final uvIndex = uvRow + (x >> 1) * uPlane.bytesPerPixel;
      if (uvIndex >= uPlane.bytes.length || uvIndex >= vPlane.bytes.length) {
        continue;
      }

      final yValue = yPlane.bytes[yRow + x];
      final uValue = uPlane.bytes[uvIndex] - 128;
      final vValue = vPlane.bytes[uvIndex] - 128;

      out.setPixelRgb(
        x,
        y,
        (yValue + 1.370705 * vValue).round().clamp(0, 255),
        (yValue - 0.337633 * uValue - 0.698001 * vValue).round().clamp(0, 255),
        (yValue + 1.732446 * uValue).round().clamp(0, 255),
      );
    }
  }
  return out;
}
