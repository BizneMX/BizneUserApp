import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/login/repository.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/controller.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final repo = LoginRepo();

  final preLogin = true.obs;

  final phoneController = CountTextEditingController(count: 10);
  final passwordController = TextEditingController();
  var prefixPhone = '+52';

  final phoneKey = GlobalKey<BizneRequiredFieldLoginState>();
  final passwordKey = GlobalKey<BizneTextFormFieldState>();

  @override
  void onInit() {
    super.onInit();
    getCountries();
  }

  void getCountries() => repo.getCountries();

  void goToRecoverPassword() {
    passwordController.clear();
    Get.toNamed(recoverPassword);
  }

  void continuePreLogin(bool isNew) async {
    var error = false;

    final phoneValidate = phoneKey.currentState!.validate();
    if (!phoneValidate) return;

    final phone = prefixPhone + phoneController.text;

    EasyLoading.show();
    final response = await repo.preLogin(phone);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    if (isNew) {
      if (response.data["exist"]) {
        error = true;
      } else {
        Get.toNamed(verificationCode,
            arguments: VerificationCodeParams(phone: phone));
      }
    } else {
      if (!response.data["exist"]) {
        error = true;
      } else {
        preLogin.value = false;
      }
    }

    if (error) {
      await Get.dialog(const BizneLoginErrorDialog());
    }
  }

  void continueLogin() async {
    final phoneValidate = phoneKey.currentState!.validate();
    final passwordValidate = passwordKey.currentState!.validate();

    if (!(phoneValidate && passwordValidate)) return;

    final phone = prefixPhone + phoneController.text;

    EasyLoading.show();
    final response = await repo.login(phone, passwordController.text);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    FirebaseAnalytics.instance.logEvent(
        name: 'start_registration',
        parameters: {'type': 'button', 'name': 'continue'});
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('jumpWelcome', true);
    final checkedPermissions = prefs.getBool('checkedPermissions');

    if (checkedPermissions != null && checkedPermissions) {
      User user = response.data;
      Get.offAllNamed(home, arguments: user);
    } else {
      Get.offAllNamed(permissions);
    }
  }
}
