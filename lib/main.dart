import 'package:firebase_core/firebase_core.dart';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'src/app.dart';
import 'src/services/api.dart';
import 'src/services/camera.dart';
import 'src/services/connectivity.dart';
import 'src/services/firebase_api.dart';
import 'src/services/location.dart';

Future<void> initServices() async {
  final prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  await Get.putAsync(() => NotificationHandler().init());

  final jumpWelcome = prefs.getBool('jumpWelcome') ?? false;
  if (jumpWelcome) {
    // Push Notifications
    bool notificationPermission =
        prefs.getBool('notificationPermission') ?? false;
    if (notificationPermission) {
      await Get.putAsync(() => PushNotifications().init());
    }
    // Location
    await Get.putAsync(() => LocationProvide().init());
  }

  final token = prefs.getString('token');
  // Api
  await Get.putAsync(() => Api().init(token));
  // Connectivity
  await Get.putAsync(() => ConnectivityService().init());
  // Camera
  await Get.putAsync(() => CameraService().init());

  Stripe.publishableKey = Environment.spriteApiKey;
  await Stripe.instance.applySettings();

  return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  configLoading();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(BizneApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = false;
}
