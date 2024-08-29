import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/support/repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../models/support_item.dart';

class SupportController extends GetxController {
  RxList<SupportItemModel> data = RxList.empty();
  final repo = SupportRepo();

  void getData(String screen) async {
    EasyLoading.show();
    final response = await repo.getData(screen);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    data.value = response.data as List<SupportItemModel>;
  }
}
