import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/repository.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../components/dialog.dart';
import '../../constants/routes.dart';
import '../profile_home/controller.dart';

class ScheduleFoodController extends LayoutRouteController {
  ScheduleFoodRepo repo = ScheduleFoodRepo();

  final deliveryDetailTextController = TextEditingController();
  // int plateState = -1;
  String timeInterval = '10:00 am';
  List<String> intervals = <String>['10:00 am'];
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String menuPrice = '0';
  String menuUrl = '';

  var menuSelected = 1.obs;

  void restartValues() {
    timeInterval = '10:00 am';
    selectedDate = DateTime.now().add(const Duration(days: 1));
    menuPrice = '0';
    deliveryDetailTextController.clear();
  }

  Future<bool> initBooking(int establishmentId) async {
    EasyLoading.show();
    final response = await repo.initBooking(establishmentId);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return false;
    }

    menuPrice = response.data['menu_price'];
    menuUrl = response.data['menu_pic'] ?? '';
    intervals = response.data['hours'].map<String>((e) {
      return e as String;
    }).toList();

    return true;
  }

  Future confirmBooking(Establishment establishment) async {
    EasyLoading.show();
    final response = await repo.confirmBooking({
      "establishment": establishment.id.toString(),
      "date": LocalizationFormatters.dateFormat5(selectedDate),
      "hours": timeInterval,
      "total": menuPrice,
      "details": deliveryDetailTextController.text,
      "no_menu": menuSelected.value
    });
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    navigate(scheduleFoodCongratulations, params: establishment);
  }

  // void changePlateState(int state) => plateState = state;

  Future<void> contactBusiness(String phoneNumber) async {
    await Utils.contactWhatsApp(phoneNumber);
  }

  String getName() {
    final profileController = Get.find<ProfileHomeController>();

    return '${profileController.user[0].name} ${profileController.user[0].lastName}';
  }
}
