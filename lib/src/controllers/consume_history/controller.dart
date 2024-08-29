import 'package:bizne_flutter_app/src/controllers/consume_history/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/consumption.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../components/dialog.dart';

class ConsumeHistoryController extends LayoutRouteController {
  ConsumeHistoryRepo repo = ConsumeHistoryRepo();

  int month = (DateTime.now().month - 1);
  int year = DateTime.now().year;
  var noConsumptions = false.obs;
  RxMap<String, List<Consumption>> data = <String, List<Consumption>>{}.obs;

  void onChangeMonth(String value) {
    Map<String, int> mapMonth = {
      "Enero": 1,
      "Febrero": 2,
      "Marzo": 3,
      "Abril": 4,
      "Mayo": 5,
      "Junio": 6,
      "Julio": 7,
      "Agosto": 8,
      "Septiembre": 9,
      "Octubre": 10,
      "Noviembre": 11,
      "Diciembre": 12
    };

    month = mapMonth[value]! - 1;
    getConsumesHistory();
  }

  void onChangeYear(String value) {
    year = int.parse(value);
    getConsumesHistory();
  }

  Future<void> getConsumesHistory() async {
    EasyLoading.show();
    final response = await repo.getConsumeHistory(month + 1, year);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    data.clear();
    for (Consumption e in response.data) {
      if (data[e.date] == null) {
        data[e.date] = [];
      }
      data[e.date]!.add(e);
    }

    noConsumptions.value = response.data.length == 0;
  }
}
