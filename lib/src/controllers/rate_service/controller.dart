import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/repository.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/controller.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RateServiceController extends LayoutRouteController {
  final repo = RateServiceRepo();
  var starRate = 0.obs;
  final commentController = TextEditingController();

  @override
  void clear() {
    starRate.value = 0;
    commentController.clear();
  }

  void rateService(RateServiceParams params) async {
    EasyLoading.show();
    final response = await repo.rateService(starRate.value,
        commentController.text, params.establishment.id, params.visit);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    if (starRate < 3) {
      navigate(generateReport,
          params: GenerateReportParams(
              showTextField: false,
              isTransaction: true,
              historyFood: HistoryFood(
                  date: LocalizationFormatters.dateFormat2(DateTime.now()),
                  id: params.visit,
                  estabName: params.establishment.name,
                  pic: params.establishment.logoPic!)));
    } else {
      await Get.dialog(RateServiceDialog(
        name: params.establishment.name,
        pic: params.establishment.logoPic!,
      ));

      navigate(home);
    }
  }
}

class RateServiceParams {
  final Establishment establishment;
  final int visit;
  const RateServiceParams({required this.establishment, required this.visit});
}
