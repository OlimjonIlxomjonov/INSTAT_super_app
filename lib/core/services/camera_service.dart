import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../utils/logger/logger.dart';

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  String? _lastCaptureBase64;

  bool get isReady => _controller?.value.isInitialized ?? false;

  CameraController? get controller => _controller;

  String? get lastCaptureBase64 => _lastCaptureBase64;

  Future<void> init() async {
    try {
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
      } on CameraException {
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
      notifyListeners();
    } catch (e) {
      logger.e('Camera init error: $e');
    }
  }

  Future<String?> captureBase64() async {
    if (!isReady) return null;

    try {
      final XFile file = await _controller!.takePicture();
      final jpegBytes = await file.readAsBytes();

      logger.f('📸 Image captured (JPEG): ${jpegBytes.length} bytes');

      // Decode JPEG and encode as PNG
      var image = img.decodeImage(jpegBytes);
      if (image == null) {
        logger.f('❌ Failed to decode image');
        return null;
      }

      logger.f(
        '🔎 sensorOrientation: ${_controller!.description.sensorOrientation}, '
        'lensDirection: ${_controller!.description.lensDirection}',
      );
      logger.f(
        '🔎 Decoded pixel buffer: ${image.width}x${image.height}, '
        'exif orientation tag: ${image.exif.imageIfd.hasOrientation ? image.exif.imageIfd.orientation : 'none'}',
      );

      image = img.bakeOrientation(image);
      logger.f('🔎 After bakeOrientation: ${image.width}x${image.height}');

      final pngBytes = img.encodePng(image);
      logger.f('📸 Converted to PNG: ${pngBytes.length} bytes');

      _lastCaptureBase64 = 'data:image/png;base64,${base64Encode(pngBytes)}';
      logger.f('📸 Base64 length: ${_lastCaptureBase64!.length}');

      notifyListeners();
      return _lastCaptureBase64;
    } catch (e) {
      logger.f('❌ Capture error: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
