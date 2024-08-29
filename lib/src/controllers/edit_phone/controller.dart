import 'dart:async';

import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditPhoneController extends LayoutRouteController {
  final repo = EditPhoneRepo();
  final phoneController = TextEditingController();
  var prefixPhone = '+52';

  final phoneKey = GlobalKey<BizneRequiredFieldLoginState>();

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) return getLocalizations()!.requiredField;

    return null;
  }

  @override
  void clear() {
    phoneController.clear();
  }

  Future<void> save() async {
    if (phoneKey.currentState!.validate()) {
      final phone = '$prefixPhone${phoneController.text}';

      EasyLoading.show();
      final response = await repo.updatePhone(phone);
      EasyLoading.dismiss(animation: true);

      if (!response.success) {
        await Get.dialog(BizneResponseErrorDialog(response: response));
        return;
      }

      Get.toNamed(verificationCode,
          arguments: VerificationCodeParams(phone: phone, changePhone: true));
    }
  }
}
