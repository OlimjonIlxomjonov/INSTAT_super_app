import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';

import '../../../../core/utils/constants/colors/app_colors.dart';

class QrLoginScannerPage extends StatefulWidget {
  const QrLoginScannerPage({super.key});

  @override
  State<QrLoginScannerPage> createState() => _QrLoginScannerPageState();
}

class _QrLoginScannerPageState extends State<QrLoginScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QrLoginScanner');
  QRViewController? controller;
  StreamSubscription<Barcode>? _subscription;
  bool _handled = false;
  bool _flashOn = false;

  @override
  void dispose() {
    _subscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _toggleFlash() async {
    await controller?.toggleFlash();
    final status = await controller?.getFlashStatus();
    if (mounted) {
      setState(() {
        _flashOn = status ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cutOutSize = MediaQuery.of(context).size.width * 0.72;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.primaryColor,
              borderRadius: 16,
              borderLength: 32,
              borderWidth: 6,
              cutOutSize: cutOutSize,
              overlayColor: Colors.black.withValues(alpha: 0.7),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          FlutterRemix.arrow_left_line,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'QR-kodni skanerlash',
                        style: AppTextStyles.source.semiBold(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          shape: const CircleBorder(),
                        ),
                        onPressed: _toggleFlash,
                        icon: Icon(
                          _flashOn
                              ? FlutterRemix.flashlight_fill
                              : FlutterRemix.flashlight_line,
                          color: _flashOn ? Colors.yellow : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    bottom: 48,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white24,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FlutterRemix.qr_code_line,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tizimga kirish uchun kompyuter ekranidagi QR-kodni moslang',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.source.regular(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    _subscription = controller.scannedDataStream.listen((scanData) async {
      if (_handled || !mounted) return;

      final code = scanData.code;
      if (code == null || code.isEmpty) return;

      logger.i('RAW QR scanned value: "$code"');
      logger.i('RAW QR scanned format: ${scanData.format}');

      _handled = true;
      await _subscription?.cancel();
      controller.pauseCamera();

      if (!mounted) return;
      Navigator.of(context).pop(code);
    });
  }
}
