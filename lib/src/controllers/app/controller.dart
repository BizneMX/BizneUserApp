// ignore_for_file: unnecessary_string_escapes

import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/app/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AppController extends LayoutRouteController {
  final repo = AppRepo();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  var onScan = false;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics.instance.logEvent(
      name: 'user_app_main_menu',
      parameters: {
        'type': 'button',
        'name': 'qr'
      }
    );
  }

  String cleanScanData(String data) {
    return data.replaceAll('\u00a0', ' ').replaceAll('\/', '/');
  }

  Future<void> scanQr(String? code) async {
    if (onScan || code == null) return;

    onScan = true;
    final response = await repo.scanTicket(cleanScanData(code));
    onScan = false;

    if (!response.success || response.data == null) {
      navigate(
        error,
        params: response.message ?? getLocalizations()!.unexpectedError,
      );
      return;
    }

    navigate(paymentWithCashback, params: response.data);
  }

  @override
  void clear() {
    controller?.dispose();
    onScan = false;
  }
}
