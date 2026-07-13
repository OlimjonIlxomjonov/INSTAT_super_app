import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

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
        // Some Android devices (CameraX) don't support a Preview +
        // ImageCapture surface combination at `medium` resolution and throw
        // "No supported surface combination is found" — retry at `low`,
        // which uses a smaller/more universally supported surface size.
        try {
          await _controller!.dispose();
        } catch (_) {
          // A controller whose initialize() failed partway through was
          // never fully bound on the CameraX side — disposing it can throw
          // (releaseSurfaceProvider on a surface that was never set up).
          // Safe to ignore; we're discarding this controller either way.
        }
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
      print('Camera init error: $e');
    }
  }

  Future<String?> captureBase64() async {
    if (!isReady) return null;

    try {
      final XFile file = await _controller!.takePicture();
      final jpegBytes = await file.readAsBytes();

      print('📸 Image captured (JPEG): ${jpegBytes.length} bytes');

      // Decode JPEG and encode as PNG
      final image = img.decodeImage(jpegBytes);
      if (image == null) {
        print('❌ Failed to decode image');
        return null;
      }

      final pngBytes = img.encodePng(image);
      print('📸 Converted to PNG: ${pngBytes.length} bytes');

      _lastCaptureBase64 = 'data:image/png;base64,${base64Encode(pngBytes)}';
      print('📸 Base64 length: ${_lastCaptureBase64!.length}');

      notifyListeners();
      return _lastCaptureBase64;
    } catch (e) {
      print('❌ Capture error: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
