import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/service_details/repository.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ServiceDetailsController extends LayoutRouteController {
  final repo = ServiceDetailsRepo();
  var pic = ''.obs;
  var menu = ''.obs;
  var isFavorite = false.obs;

  Future<void> getMenu(Establishment establishment) async {
    if (establishment.menu != null && establishment.menuPic != null) {
      pic.value = establishment.menuPic!;
      menu.value = establishment.menu!;
      if (pic.value.isEmpty) pic.value = establishment.pic!;

      return;
    }

    EasyLoading.show();
    final response = await repo.getMenu(establishment.id);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    pic.value = response.data['menu_pic'] ?? response.data['pic'];
    menu.value = response.data['menu'] ?? '';
    establishment.menu = menu.value;
    establishment.menuPic = pic.value;
  }

  Future<void> contactBusiness(String phoneNumber) async {
    await Utils.contactWhatsApp(phoneNumber);
  }

  Future<void> transactionData(Establishment establishment) async {
    await Get.find<HomeController>().transactionData(establishment);
  }

  Future<void> setFavorite(Establishment establishment) async {
    await Get.find<HomeController>().setFavorite(establishment);
    isFavorite.value = !isFavorite.value;
  }
}
