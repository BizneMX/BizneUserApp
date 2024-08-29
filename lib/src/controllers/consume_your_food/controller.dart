import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/congratulations_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ConsumeYourFoodController extends LayoutRouteController {
  final repo = ConsumeYourFoodRepo();
  Future<void> transactionConfirm(
      ConsumeYourFoodParams params, bool delivery) async {
    EasyLoading.show();
    // final deviceInfoPlugin = DeviceInfoPlugin();
    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
    // final allInfo = deviceInfo.data;
    // String? imei = allInfo.;
    //TODO:
    String? imei = '1234';
    final response = await repo.transactionConfirm(
        params.establishment.id, params.amount, imei, delivery ? 1 : 0);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    navigate(congratulationsFood,
        params: CongratulationsFoodParams(
            establishment: params.establishment,
            data: response.data,
            amount: params.amount,
            diff: params.diff));
  }
}

class ConsumeYourFoodParams {
  final Establishment establishment;
  final int amount;
  final int diff;

  const ConsumeYourFoodParams(
      {required this.establishment, required this.amount, required this.diff});
}
