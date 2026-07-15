import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(AppLocalizations.of(context)!.attendanceLabel),
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
