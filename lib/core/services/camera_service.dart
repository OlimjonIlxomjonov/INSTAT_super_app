import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

import '../utils/logger/logger.dart';

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  String? _lastCaptureBase64;
  bool _isPermissionDenied = false;

  bool get isReady => _controller?.value.isInitialized ?? false;

  /// True once the camera permission has actually been denied (including
  /// "don't ask again"/permanently-denied) — as opposed to just "not ready
  /// yet" while still initializing, which [isReady] alone can't tell apart.
  bool get isPermissionDenied => _isPermissionDenied;

  CameraController? get controller => _controller;

  String? get lastCaptureBase64 => _lastCaptureBase64;

  Future<void> init() async {
    try {
      // Only *read* the status here — never request through
      // permission_handler. Its iOS request path invokes the Flutter result
      // callback directly from AVCaptureDevice's completion handler, which
      // Apple documents as running on an arbitrary dispatch queue. Touching
      // Flutter off the platform thread froze the app until the iOS
      // watchdog SIGKILLed it. Reading the status is a plain synchronous
      // AVFoundation lookup and openAppSettings() is a main-thread
      // UIApplication call, so both are safe.
      //
      // The actual prompt is left to the camera plugin's own initialize()
      // below (Flutter-team maintained, threads correctly) — which is how
      // this screen worked before permission_handler was introduced.
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
        // This retry exists to fall back to a lower resolution on devices
        // that reject `medium` — it must not fire for permission errors,
        // where a second attempt just fails again for the same reason.
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
      // Camera opened, so permission is granted — clears the overlay when
      // the user grants access from settings and comes back.
      _isPermissionDenied = false;
      notifyListeners();
    } on CameraException catch (e) {
      logger.e('Camera init error: $e');
      // This is now the primary denial signal, not just a safety net: the
      // camera plugin is what actually shows the OS prompt, so a denial
      // surfaces here as CameraAccessDenied / CameraAccessDeniedWithoutPrompt
      // / CameraAccessRestricted.
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
    super.dispose();
    await _controller?.dispose();
    _controller = null;
  }
}
