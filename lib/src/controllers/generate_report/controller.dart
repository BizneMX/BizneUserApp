import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:bizne_flutter_app/src/models/report_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class GenerateReportController extends LayoutRouteController {
  final repo = GenerateReportRepo();
  var categories = <List<ReportCategory>>[].obs;
  final reportController = TextEditingController();
  final reportKey = GlobalKey<BizneTextFormFieldState>();
  var reportSelected = 0.obs;

  Future<void> getCategories() async {
    EasyLoading.show();
    final response = await repo.getReportCategories();
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    categories.clear();
    reportSelected.value = response.data[0].id;
    for (var i = 0; i < response.data.length; i += 3) {
      categories.add([]);
      for (var j = 0; j < 3; j++) {
        if (i + j < response.data.length) {
          categories[i ~/ 3].add(response.data[i + j]);
        } else {
          categories[i ~/ 3].add(ReportCategory(id: -1, name: '', pic: ''));
        }
      }
    }
  }

  @override
  void clear() {
    reportController.clear();
  }

  void changeReportSelected(int index) {
    reportSelected.value = index;
  }

  String? reportValidator(String? value) {
    if (value == null || value.isEmpty) return getLocalizations()!.requiredField;

    return null;
  }

  void generateReport(GenerateReportParams params) async {
    if (!params.showTextField || reportKey.currentState!.validate()) {
      EasyLoading.show();
      final response = await repo.generateReport(
          params.historyFood.id, reportController.text, reportSelected.value);
      EasyLoading.dismiss(animation: true);

      if (!response.success) {
        await Get.dialog(BizneResponseErrorDialog(response: response));
        return;
      }

      await Get.dialog(ReportWasSentDialog(historyFood: params.historyFood));

      if (params.isTransaction) {
        navigate(home);
      } else {
        popNavigate();
      }
    }
  }
}

class GenerateReportParams {
  final HistoryFood historyFood;
  final bool isTransaction;
  final bool showTextField;
  const GenerateReportParams(
      {required this.historyFood,
      required this.isTransaction,
      this.showTextField = true});
}
