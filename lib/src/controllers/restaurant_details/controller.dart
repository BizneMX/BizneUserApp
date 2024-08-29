import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/restaurant_details/repository.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RestaurantDetailsController extends LayoutRouteController {
  var schedule = ''.obs;
  final repo = RestaurantDetailsRepo();
  var isFavorite = false.obs;

  Future<void> contactBusiness(String phoneNumber) async {
    await Utils.contactWhatsApp(phoneNumber);
  }

  Future<void> getSchedule(Establishment establishment) async {
    if (establishment.schedule != null) {
      schedule.value = establishment.schedule!;
      return;
    }

    EasyLoading.show();
    final response = await repo.getSchedule(establishment.id);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    schedule.value = response.data ?? '';
    establishment.schedule = schedule.value;
  }

  Future<void> setFavorite(Establishment establishment) async {
    await Get.find<HomeController>().setFavorite(establishment);
    isFavorite.value = !isFavorite.value;
  }
}
