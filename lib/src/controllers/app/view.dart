import 'package:bizne_flutter_app/src/controllers/app/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

class AppPage extends LayoutRouteWidget<AppController> {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    var scanArea = 70.w;
    return Expanded(
        child: Center(
            child: SizedBox(
                height: 85.h,
                width: 90.w,
                child: ClipRRect(
                    borderRadius: AppThemes().borderRadius,
                    child: QRView(
                        key: controller.qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                            borderColor: Colors.red,
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: scanArea),
                        onPermissionSet: (ctrl, p) =>
                            _onPermissionSet(context, ctrl, p))))));
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cuenta con permisos de cámara')),
      );
    }
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller.controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      controller.scanQr(scanData.code);
    });
  }
}
