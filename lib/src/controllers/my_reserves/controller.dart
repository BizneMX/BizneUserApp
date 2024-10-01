import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/my_reserves/repository.dart';
import 'package:bizne_flutter_app/src/models/reserve.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MyReserveController extends LayoutRouteController {
  final repo = MyReservesRepo();

  var noData = false.obs;

  var reserves = <Reserve>[].obs;

  void getMyReserves() async {
    EasyLoading.show();
    final response = await repo.getMyReserves();
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    reserves.value = response.data!;
    noData.value = reserves.isEmpty;
  }

  void launchInfo() async {
    await Get.dialog(const MyReservesDialog());
  }

  void rate(int id) {}

  void cancel(int id) {}
}
