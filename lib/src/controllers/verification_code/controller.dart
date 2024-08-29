import 'dart:async';

import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class VerificationCodeController extends GetxController {
  final repo = VerificationCodeRepo();

  final codeKey = GlobalKey<BizneRequiredFieldLoginState>();

  final codeController = CountTextEditingController(count: 6);

  final VerificationCodeParams currentParams;
  VerificationCodeController({required this.currentParams});

  String? codeValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo requerido";

    return null;
  }

  var cantResendCode = false.obs;
  var seconds = 90.obs;
  late Timer timer;

  @override
  void onReady() {
    super.onReady();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    seconds.value = 90;
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (seconds.value == 0) {
          timer.cancel();
        } else {
          seconds--;
        }
      },
    );
  }

  String formatSecond(int time) {
    int minutes = time ~/ 60;
    int remainingSeconds = time % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  void checkCode(String phone) async {
    if (!codeKey.currentState!.validate()) return;

    EasyLoading.show();
    final response = await repo.checkCode(phone, codeController.text);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    Get.toNamed(register, arguments: phone);
  }

  Future<bool> resendCode(String phone) async {
    EasyLoading.show();
    final response = await repo.getCode(phone);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));

      return false;
    }

    startTimer();

    return true;
  }

  void changePhone(String phone) async {
    if (!codeKey.currentState!.validate()) return;

    EasyLoading.show();
    final response = await repo.updatePhone(phone, codeController.text);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }
    await Get.dialog(BizneUpdatedPhoneDialog(onOk: () {
      Get.back();
      Get.back();
      Get.find<ProfileHomeController>().user[0].phone = phone;
      Get.find<EditPhoneController>().popNavigate();
    }));
  }
}

class VerificationCodeParams {
  final String phone;
  final bool changePhone;

  const VerificationCodeParams({
    required this.phone,
    this.changePhone = false,
  });
}
