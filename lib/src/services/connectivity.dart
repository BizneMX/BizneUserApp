import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ConnectivityStatus { wiFi, cellular, offline }

class ConnectivityService extends GetxService {
  static ConnectivityService get service => Get.find();
  ValueNotifier<ConnectivityStatus> connectivityStatus =
      ValueNotifier(ConnectivityStatus.offline);

  Future<ConnectivityService> init() async {
    super.onInit();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      updateConnectivityStatus(result);
    });
    // Check the initial status
    checkConnectivity();
    return this;
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    updateConnectivityStatus(connectivityResult);
  }

  void updateConnectivityStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      connectivityStatus.value = ConnectivityStatus.wiFi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      connectivityStatus.value = ConnectivityStatus.cellular;
    } else {
      connectivityStatus.value = ConnectivityStatus.offline;
    }
  }

  bool get isOnline => connectivityStatus.value != ConnectivityStatus.offline;
}
