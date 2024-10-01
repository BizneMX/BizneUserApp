import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/repository.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHomeController extends LayoutRouteController {
  final user = <User>[].obs;

  final repo = ProfileHomeRepo();

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics.instance.logEvent(
        name: 'main_menu', parameters: {'type': 'button', 'name': 'perfil'});

    if (!connection()) return;

    getProfile();
  }

  Future<void> getProfile() async {
    EasyLoading.show();
    final response = await ProfileHomeRepo().getProfile();
    EasyLoading.dismiss();

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    user.value = [response.data];
  }

  void consumptionHistoryButton() => navigate(consumeHistory);

  void legalButton() {}

  Future<void> logoutButton() async {
    EasyLoading.show();
    final response = await repo.logout();
    EasyLoading.dismiss();

    await Get.dialog(BizneResponseErrorDialog(response: response));

    if (response.success) {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.remove('token');

      Get.offNamed(welcome, arguments: false);
    }
  }
}
