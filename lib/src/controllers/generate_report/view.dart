import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/controller.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/report_category.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class GenerateReportPage extends LayoutRouteWidget<GenerateReportController> {
  const GenerateReportPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as GenerateReportParams;
    controller.getCategories();

    final selectReportArea = Obx(() => SizedBox(
          width: 70.w,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyText(
              text: AppLocalizations.of(context)!.whatWrongYourConsumption,
              color: AppThemes().primary,
              type: FontType.bold,
              fontSize: 14.sp,
            ),
            SizedBox(
              height: 2.h,
            ),
            ...controller.categories.map(
              (element) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...element.map((e) => Expanded(
                          flex: 1,
                          child: e.id != -1
                              ? SelectedReportItem(
                                  onPressed: () =>
                                      controller.changeReportSelected(e.id),
                                  selected:
                                      e.id == controller.reportSelected.value,
                                  category: e,
                                )
                              : const SizedBox(),
                        ))
                  ],
                ),
              ),
            ),
          ]),
        ));

    return SingleChildScrollView(
      child: SizedBox(
        height: 92.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: 75.w,
              height: 11.h,
              child: HistoryWidget(
                report: false,
                isTransaction: currentParams.isTransaction,
                historyFood: currentParams.historyFood,
                action: () => controller.popNavigate(),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [selectReportArea],
            )),
            SizedBox(
              width: 80.w,
              child: currentParams.showTextField
                  ? BizneTextFormField(
                      key: controller.reportKey,
                      onSubmited: () =>
                          controller.generateReport(currentParams),
                      maxLines: 5,
                      hint: AppLocalizations.of(context)!.detailYourReport,
                      controller: controller.reportController,
                      validator: controller.reportValidator)
                  : const SizedBox(),
            ),
            SizedBox(
              height: 5.h,
            ),
            BizneElevatedButton(
                widthFactor: 0.8,
                onPressed: () => controller.generateReport(currentParams),
                title: AppLocalizations.of(context)!.sendReport),
            SizedBox(height: 4.h)
          ],
        ),
      ),
    );
  }
}

class SelectedReportItem extends StatelessWidget {
  final Function() onPressed;
  final bool selected;
  final ReportCategory category;
  const SelectedReportItem(
      {super.key,
      required this.onPressed,
      required this.selected,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 18.w,
          width: 18.w,
          child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                backgroundColor: MaterialStateProperty.all(AppThemes().white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                    side: selected
                        ? BorderSide(width: 2, color: AppThemes().secondary)
                        : BorderSide.none))),
            child: Image.network(category.pic),
          ),
        ),
        SizedBox(
          height: 5.sp,
        ),
        MyText(
          align: TextAlign.center,
          fontSize: 10.sp,
          text: category.name,
          color: AppThemes().primary,
          type: selected ? FontType.bold : FontType.regular,
        )
      ],
    );
  }
}
