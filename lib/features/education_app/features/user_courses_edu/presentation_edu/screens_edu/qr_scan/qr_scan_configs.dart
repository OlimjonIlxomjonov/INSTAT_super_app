import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../../../../../core/utils/constants/textstyles/app_text_style.dart';

class QrScanConfigs extends StatefulWidget {
  const QrScanConfigs({super.key});

  @override
  State<QrScanConfigs> createState() => QrScanConfigsState();
}

class QrScanConfigsState extends State<QrScanConfigs> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  StreamSubscription<Barcode>? _subscription;
  bool _handled = false;

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
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  bool _flashOn = false;

  Future<void> _toggleFlash() async {
    await controller?.toggleFlash();
    final status = await controller?.getFlashStatus();
    if (mounted) setState(() => _flashOn = status ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final cutOut = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.primaryColor,
              borderRadius: 12,
              borderLength: 28,
              borderWidth: 8,
              cutOutSize: cutOut,
              overlayColor: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: _toggleFlash,
                        icon: Icon(
                          _flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Text(
                    AppLocalizations.of(context)!.attendanceLabel,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.source.regular(
                      fontSize: 18,
                      color: AppColors.white,
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

      _handled = true;

      await _subscription?.cancel();

      controller.pauseCamera(); // no need to await

      if (!mounted) return;

      Navigator.of(context).pop(scanData.code);
    });
  }
}
