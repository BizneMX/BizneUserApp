import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/repository.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PayFoodController extends LayoutRouteController {
  final repo = PayFoodRepo();
  final amountToPayKey = GlobalKey<BizneTextFormFieldState>();

  var error = "".obs;
  var info = "".obs;

  var selectedBizneMenu = true.obs;
  final amountToPayController = TextEditingController();

  void updateStateOnCloseDialog() {
    selectedBizneMenu.value = true;
    error.value = "";
    info.value = "";
    amountToPayController.clear();
  }

  Future<void> continueButton(PayFoodParams params) async {
    int amount = 0;
    if (selectedBizneMenu.value) {
      amount = params.menuPrice;
    } else {
      amount = int.tryParse(amountToPayController.text) ?? -1;

      if (!amountToPayKey.currentState!.validate() || amount == -1) {
        return;
      }

      Get.back();
    }

    final (ok, diff) = await transactionInit(amount);

    if (ok) {
      navigate(consumeYourFood,
          params: ConsumeYourFoodParams(
              establishment: params.establishment, amount: amount, diff: diff));
    }
  }

  Future<(bool, int)> transactionInit(int amount) async {
    EasyLoading.show();
    final response = await repo.transactionInit(amount);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return (false, 0);
    }
    int diff = response.data['diff'];
    return (true, diff);
  }

  @override
  void clear() {
    amountToPayController.clear();
    selectedBizneMenu.value = true;
  }
}

class PayFoodParams {
  final Establishment establishment;
  final int todayBzCoins;
  final int menuPrice;
  final bool walletLimited;
  const PayFoodParams(
      {required this.walletLimited,
      required this.establishment,
      required this.todayBzCoins,
      required this.menuPrice});
}
