import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'repository.dart';

class RecoverPasswordController extends GetxController {
  final emailKey = GlobalKey<BizneRequiredFieldState>();
  final phoneKey = GlobalKey<BizneRequiredFieldLoginState>();
  final repo = RecoverPasswordRepo();
  var prefixPhone = '+52';

  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final selectedEmail = true.obs;

  void changeSelected(bool value) {
    selectedEmail.value = value;
  }

  Future<bool> recoverPassword() async {
    if (!selectedEmail.value) {
      if (!phoneKey.currentState!.validate()) return false;

      EasyLoading.show();
      final phone = prefixPhone + phoneNumberController.text;
      final response = await repo.recoverByPhone(phone);
      EasyLoading.dismiss(animation: true);

      if (!response.success) {
        await Get.dialog(BizneResponseErrorDialog(response: response));
      }

      return response.success;
    } else {
      if (!emailKey.currentState!.validate()) return false;

      EasyLoading.show();
      final response = await repo.recoverByEmail(emailController.text);
      EasyLoading.dismiss(animation: true);

      if (!response.success) {
        await Get.dialog(BizneResponseErrorDialog(response: response));
      }

      return response.success;
    }
  }

  void goVerificationCode() {
    phoneNumberController.clear();
    emailController.clear();
    Get.toNamed(verificationCode);
  }
}
