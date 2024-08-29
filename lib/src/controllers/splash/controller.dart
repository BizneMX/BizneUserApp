import 'dart:io';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/routes.dart';
import '../../services/api.dart';
import '../../services/connectivity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/firebase_api.dart';
import '../../services/location.dart';

class SplashController extends GetxController {
  final repo = ProfileHomeRepo();
  @override
  void onReady() {
    super.onReady();
    checkConnectivity();
  }

  Future<bool> checkActivityOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString('myBizne');

    return json != null;
  }

  void checkConnectivity() async {
    if (!ConnectivityService.service.isOnline) {
      if (await checkActivityOffline()) {
        delaySplashView(() {
          Get.offNamed(home);
        });
        return;
      }

      final connectionNotifier = ConnectivityService.service.connectivityStatus;
      connectionNotifier.addListener(() {
        if (ConnectivityService.service.isOnline) {
          connectionNotifier.removeListener(() {});
          checkApp();
        }
      });
      Get.dialog(const NoConnectionDialog());
    } else {
      checkApp();
    }
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? jumpWelcome = prefs.getBool('jumpWelcome');
    if (jumpWelcome != null && jumpWelcome) {
      checkToken();
    } else {
      delaySplashView(() {
        Get.offAllNamed(welcome);
      });
    }
  }

  Future<void> _openStore() async {
    String appStoreUrl = 'https://apps.apple.com/us/app/bizne/id1492187161';
    String playStoreUrl =
        'https://play.google.com/store/apps/details?id=mx.devbizne.bizne';

    if (Platform.isAndroid) {
      await launchUrl(Uri.parse(playStoreUrl));
    } else if (Platform.isAndroid) {
      await launchUrl(Uri.parse(appStoreUrl));
    }
  }

  void checkApp() async {
    final response = await repo.checkApp();

    if (!response.success) {
      await Get.dialog(BizneDialog(
        text: AppLocalizations.of(Get.context!)!.invalidApp,
        okText: Platform.isAndroid ? 'Play Store' : 'App Store',
        onOk: () => _openStore(),
        onCancel: () => Get.back(),
      ));

      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else {
      // loadData();
      checkToken();
    }
  }

  Future<bool> checkSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final checkSaved = prefs.getBool('checkSaved') ?? true;

    if (!checkSaved) {
      return false;
    }

    const platformSharedPrefs =
        MethodChannel('mx.devbizne.bizne/shared_preferences');

    String token = '';
    try {
      token = await platformSharedPrefs
          .invokeMethod('getSharedPreferencesValue', {"key": "TOKEN"});
      Api.service.setToken(token);
      await prefs.setString('token', token);
      await prefs.setBool('checkSaved', false);
      return true;
    } catch (e) {
      return false;
    }
  }

  void checkToken() async {
    if (await checkSavedToken()) {
      delaySplashView(() async {
        // Get.offNamed(permissions);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('locationPermission', true);
        await Get.putAsync(() => LocationProvide().init());
        await prefs.setBool('notificationPermission', true);
        await Firebase.initializeApp();
        await NotificationHandler().init();
        await PushNotifications().init();
        prefs.setBool('jumpWelcome', true);
        prefs.setBool('checkedPermissions', true);
        Get.offAllNamed(home);
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token != null) {
        Api.service.setToken(token);
        if (!(await loadUserData())) {
          await prefs.remove('token');
          Api.service.forgetToken();
          delaySplashView(() {
            Get.offNamed(welcome);
          });
        } else {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('jumpWelcome', true);
          delaySplashView(() {
            Get.offNamed(home);
          });
        }
      } else {
        delaySplashView(() {
          Get.offNamed(welcome);
        });
      }
    }
  }

  Future<bool> loadUserData() async {
    final response = await repo.getProfile();
    if (!response.success) {
      return false;
    }
    return true;
  }

  void delaySplashView(Function action) =>
      Future.delayed(const Duration(seconds: 2), () => action());
}
