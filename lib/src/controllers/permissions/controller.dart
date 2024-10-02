import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/routes.dart';
import '../../services/firebase_api.dart';
import '../../services/location.dart';

class PermissionController extends GetxController {
  Rx<Permission> actualPermission = Permission.location.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics.instance.logEvent(
      name: 'user_app_system_location'
    );
  }

  int permissionToInt() {
    switch (actualPermission.value) {
      case Permission.location:
        return 0;
      case Permission.notification:
        return 1;
    }
  }

  Future<void> acceptLocation(Future<void> Function() func) async {
    LocationPermission permission;

    // permission = await Geolocator.checkPermission();
    do {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await FirebaseAnalytics.instance.logEvent(
          name: 'user_app_system_location',
          parameters: {
            'type': 'button',
            'name': 'deny'
          }
        );
        await func();
      }
    } while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('locationPermission', true);
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_app_system_location',
      parameters: {
        'type': 'button',
        'name': 'allow'
      }
    );
    await Get.putAsync(() => LocationProvide().init());
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_app_system_notifications'
    );
    actualPermission.value = Permission.notification;
  }

  void acceptNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', true);
    await Firebase.initializeApp();
    await NotificationHandler().init();
    await PushNotifications().init();
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_app_system_notifications',
      parameters: {
        'type': 'button',
        'name': 'allow'
      }
    );
    endWelcome();
  }

  void deniedNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', false);
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_app_system_notifications',
      parameters: {
        'type': 'button',
        'name': 'deny'
      }
    );
    endWelcome();
  }

  void endWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('jumpWelcome', true);
    prefs.setBool('checkedPermissions', true);
    Get.offAllNamed(home);
  }
}

enum Permission { location, notification }
