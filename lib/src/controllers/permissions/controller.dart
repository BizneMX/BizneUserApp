import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/routes.dart';
import '../../services/firebase_api.dart';
import '../../services/location.dart';

class PermissionController extends GetxController {
  Rx<Permission> actualPermission = Permission.location.obs;

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
        await func();
      }
    } while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('locationPermission', true);
    await Get.putAsync(() => LocationProvide().init());
    actualPermission.value = Permission.notification;
  }

  void acceptNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', true);
    await Firebase.initializeApp();
    await NotificationHandler().init();
    await PushNotifications().init();
    endWelcome();
  }

  void deniedNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', false);
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
