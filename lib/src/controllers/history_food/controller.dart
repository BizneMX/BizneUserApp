import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HistoryFoodController extends LayoutRouteController {
  final repo = HistoryFoodRepo();
  var noConsumptions = false.obs;
  var data = <HistoryFood>[].obs;

  Future<void> getHistoryFood() async {
    EasyLoading.show();
    final response = await repo.getHistoryFood();
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    data.value = response.data;
    noConsumptions.value = response.data.length == 0;
  }
}
