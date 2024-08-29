import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/controller.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryFoodPage extends LayoutRouteWidget<HistoryFoodController> {
  const HistoryFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getHistoryFood();
    return Obx(() => controller.noConsumptions.value
        ? Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              MyText(
                text: AppLocalizations.of(context)!.noConsumptionsMade,
                color: AppThemes().secondary,
                type: FontType.semibold,
              )
            ],
          )
        : ListView.builder(
            itemBuilder: (buildContext, item) {
              return Column(children: [
                Divider(color: AppThemes().grey.withOpacity(0.5)),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                    child: SizedBox(
                        height: 12.h,
                        child: HistoryWidget(
                            historyFood: controller.data[item],
                            action: () => controller.navigate(generateReport,
                                params: GenerateReportParams(
                                    historyFood: controller.data[item],
                                    isTransaction: false)))))
              ]);
            },
            itemCount: controller.data.length));
  }
}

class HistoryWidget extends StatelessWidget {
  final HistoryFood historyFood;
  final bool report;
  final bool isTransaction;
  final Function()? action;
  const HistoryWidget(
      {super.key,
      required this.historyFood,
      this.action,
      this.report = true,
      this.isTransaction = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(5.sp),
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration:
                      BoxDecoration(borderRadius: AppThemes().borderRadius),
                  child: Image.network(historyFood.pic),
                ))
          ])),
      Expanded(
          flex: 3,
          child: Column(children: [
            HistoryText(
                title: historyFood.date,
                icon: Icons.timer_outlined,
                color: AppThemes().green),
            SizedBox(height: 3.sp),
            HistoryText(
                title: historyFood.estabName,
                icon: Icons.location_on_outlined,
                color: AppThemes().secondary),
            const Expanded(child: SizedBox()),
            isTransaction
                ? const SizedBox()
                : BizneElevatedButton(
                    onPressed: action,
                    secondary: !report,
                    title: report
                        ? AppLocalizations.of(context)!.report
                        : AppLocalizations.of(context)!
                            .selectAnotherConsumption,
                    textSize: 12.sp,
                    heightFactor: 0.04)
          ]))
    ]);
  }
}

class HistoryText extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const HistoryText(
      {super.key,
      required this.title,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: color, size: 15.sp),
      SizedBox(width: 5.sp),
      MyText(text: title, color: AppThemes().secondary, type: FontType.bold)
    ]);
  }
}
