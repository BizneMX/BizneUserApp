import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/consume_history/controller.dart';
import 'package:bizne_flutter_app/src/models/consumption.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../components/selectors.dart';
import '../../components/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsumeHistoryPage extends LayoutRouteWidget<ConsumeHistoryController> {
  const ConsumeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getConsumesHistory();
    return Column(children: [
      SizedBox(
          height: 10.h,
          child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                DateSelector(
                    quantity: 12,
                    constructor: ((index) => Month(index: index)),
                    initial: controller.month,
                    onChange: controller.onChangeMonth),
                DateSelector(
                    quantity: 3,
                    constructor: ((index) => Year(index: index)),
                    initial: controller.year,
                    onChange: controller.onChangeYear)
              ]))),
      Expanded(
          child: Obx(() => controller.noConsumptions.value
              ? Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    MyText(
                      text:
                          AppLocalizations.of(context)!.thereAreNoConsumptions,
                      color: AppThemes().secondary,
                      type: FontType.semibold,
                    )
                  ],
                )
              : SingleChildScrollView(
                  child: Column(children: [
                    for (String k in controller.data.keys)
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          child: DayConsumption(
                              key: Key(k),
                              dayConsumptions: controller.data[k]!))
                  ]),
                )))
    ]);
  }
}

class DayConsumption extends GetWidget<ConsumeHistoryController> {
  final List<Consumption> dayConsumptions;
  const DayConsumption({super.key, required this.dayConsumptions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80.w,
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              color: AppThemes().whiteInputs,
              child: Row(children: [
                MyText(
                    text: formatDate(dayConsumptions[0].date),
                    fontSize: 14.sp,
                    type: FontType.bold)
              ])),
          for (int i = 0; i < dayConsumptions.length; i++)
            Column(children: [
              _buildConsumption(dayConsumptions[i]),
              if (i < dayConsumptions.length - 1)
                Divider(height: 0.5.h, color: AppThemes().grey, thickness: 1)
            ])
        ]));
  }

  String formatDate(String date) {
    final dateParts = date.split('/');
    return '${dateParts[0]} ${dateParts[1]} ${dateParts[2]}';
  }

  Widget _buildConsumption(Consumption consumption) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(children: [
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(text: consumption.concept, fontSize: 12.sp),
                    if (double.parse(consumption.cash) > 0)
                      MyRichText(
                          text: MyTextSpan(
                              text:
                                  '${controller.getLocalizations()!.cashPayment} ',
                              children: [
                                MyTextSpan(
                                    fontSize: 10.sp,
                                    color: AppThemes().secondary,
                                    type: FontType.semibold,
                                    text:
                                        '${LocalizationFormatters.currencyFormat(double.parse(consumption.cash))} MXN')
                              ],
                              fontSize: 10.sp,
                              color: AppThemes().black))
                  ])),
          Expanded(
              flex: 2,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                MyText(
                    text:
                        '${consumption.type == 'OUT' ? '-' : '+'} ${LocalizationFormatters.numberFormat(double.parse(consumption.points))} BZ',
                    fontSize: 12.sp,
                    color: consumption.type == 'OUT'
                        ? AppThemes().negative
                        : AppThemes().green,
                    type: FontType.semibold)
              ]))
        ]));
  }
}
