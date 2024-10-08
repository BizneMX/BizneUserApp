import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayFoodPage extends LayoutRouteWidget<PayFoodController> {
  const PayFoodPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as PayFoodParams;

    final selectAmountPayArea = Column(children: [
      SizedBox(
          width: 70.w,
          child: BizneTextFormField(
              autoFocus: true,
              key: controller.amountToPayKey,
              controller: controller.amountToPayController,
              validator: (value) {
                controller.error.value = "";
                if (value == null || value.isEmpty) {
                  controller.error.value =
                      AppLocalizations.of(context)!.requiredField;
                  return '';
                }
                // if (int.parse(value) > 300) {
                //   controller.error.value =
                //       AppLocalizations.of(context)!.consumptionsLimit;
                //   return '';
                // }

                // if (int.parse(value) < currentParams.menuPrice) {
                //   controller.error.value = AppLocalizations.of(context)!
                //       .theMinimumAmountToPay(currentParams.menuPrice);
                //   return '';
                // }

                if (int.parse(value) > currentParams.todayBzCoins) {
                  controller.info.value =
                      AppLocalizations.of(context)!.youWillHaveToPayDifference;
                }

                return null;
              },
              isNumber: true,
              textAlign: TextAlign.center,
              onSubmited: () => controller.continueButton(currentParams))),
      SizedBox(
        width: 70.w,
        child: Obx(() {
          if (controller.error.value.isNotEmpty) {
            return MyText(
                align: TextAlign.center,
                text: controller.error.value,
                color: AppThemes().negative,
                type: FontType.bold,
                fontSize: 10.sp);
          }
          if (controller.info.value.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: MyText(
                  align: TextAlign.center,
                  text: controller.info.value,
                  type: FontType.bold,
                  fontSize: 10.sp),
            );
          } else {
            return Container();
          }
        }),
      )
    ]);

    return SingleChildScrollView(
        child: SizedBox(
            height: 94.h,
            width: 100.w,
            child: Column(children: [
              SizedBox(height: 4.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration:
                          BoxDecoration(borderRadius: AppThemes().borderRadius),
                      child: currentParams.establishment.logoPic != null
                          ? Image.network(currentParams.establishment.logoPic!)
                          : const SizedBox(),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Card(
                        elevation: 5,
                        child: Container(
                            height: 8.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                                color: AppThemes().white,
                                borderRadius: AppThemes().borderRadius),
                            child: Column(children: [
                              SizedBox(
                                  height: 5.h,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyText(
                                            fontSize: 20.sp,
                                            color: AppThemes().primary,
                                            type: FontType.bold,
                                            fontFamily: FontFamily.rajdhani,
                                            text: LocalizationFormatters
                                                .numberFormat(
                                                    (currentParams.todayBzCoins)
                                                        .toDouble(),
                                                    decimalDigits: 0)),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                      ])),
                              Container(
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                      color: AppThemes().myBizne,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(19),
                                          bottomRight: Radius.circular(19))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: MyText(
                                                type: FontType.semibold,
                                                color: AppThemes().primary,
                                                fontSize: 10.sp,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .youCanUseToday))
                                      ]))
                            ])))
                  ]),
              SizedBox(height: 2.h),
              SizedBox(
                width: 80.w,
                child: MyRichText(
                  align: TextAlign.center,
                  text: MyTextSpan(children: [
                    MyTextSpan(
                        type: FontType.bold,
                        fontSize: 20.sp,
                        color: AppThemes().primary,
                        text:
                            "${Utils.extractWords(AppLocalizations.of(context)!.payFood(currentParams.establishment.name), 0, 4)} "),
                    MyTextSpan(
                        type: FontType.bold,
                        fontSize: 20.sp,
                        color: AppThemes().green,
                        text: Utils.extractWords(
                            AppLocalizations.of(context)!
                                .payFood(currentParams.establishment.name),
                            5,
                            -2)),
                    MyTextSpan(
                        type: FontType.bold,
                        fontSize: 20.sp,
                        color: AppThemes().primary,
                        text: Utils.extractWords(
                            AppLocalizations.of(context)!
                                .payFood(currentParams.establishment.name),
                            -1,
                            -1))
                  ]),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Obx(() => SelectedPayItem(
                  text: AppLocalizations.of(context)!.bizneMenu,
                  onPressed: () => controller.selectedBizneMenu.call(true),
                  selected: controller.selectedBizneMenu.value)),
              SizedBox(
                height: 1.h,
              ),
              MyRichText(
                  text: MyTextSpan(children: [
                MyTextSpan(
                    text: Utils.extractWords(
                        AppLocalizations.of(context)!
                            .discountBZCoins(currentParams.menuPrice),
                        0,
                        1)),
                MyTextSpan(
                    type: FontType.semibold,
                    text:
                        ' ${Utils.extractWords(AppLocalizations.of(context)!.discountBZCoins(currentParams.menuPrice), 2, 4)}'),
                MyTextSpan(
                    text:
                        ' ${Utils.extractWords(AppLocalizations.of(context)!.discountBZCoins(currentParams.menuPrice), 5, 7)}')
              ])),
              SizedBox(
                height: 2.h,
              ),
              Obx(() => SelectedPayItem(
                  text: AppLocalizations.of(context)!.otherAmount,
                  onPressed: () async {
                    controller.selectedBizneMenu.value = false;
                    await Get.dialog(
                      SelectAmountDialog(
                        selectArea: selectAmountPayArea,
                        continueButton: () => controller.continueButton(params),
                        cancelButton: () => Get.back(),
                      ),
                    );
                    controller.updateStateOnCloseDialog();
                  },
                  selected: !controller.selectedBizneMenu.value)),
              SizedBox(height: 1.h),
              Obx(() => SizedBox(
                  width: 80.w,
                  child: MyText(
                      text: AppLocalizations.of(context)!.choseTheAmount,
                      fontSize: 12.sp,
                      align: TextAlign.center,
                      type: controller.selectedBizneMenu.value
                          ? FontType.regular
                          : FontType.semibold))),
              const Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: BizneElevatedButton(
                  onPressed: () async {
                    await FirebaseAnalytics.instance
                        .logEvent(name: 'user_app_checkout_continue', parameters: {
                      'type': 'button',
                      'name': 'continue',
                      'store_id': currentParams.establishment.id.toString()
                    });
                    controller.continueButton(currentParams);
                  },
                  title: AppLocalizations.of(context)!.continueText,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: BizneElevatedButton(
                      onPressed: () async {
                        FirebaseAnalytics.instance
                            .logEvent(name: 'user_app_checkout_cancel', parameters: {
                          'type': 'button',
                          'name': 'cancel',
                          'store_id': currentParams.establishment.id.toString()
                        });
                        controller.popNavigate();
                      },
                      title: AppLocalizations.of(context)!.cancel,
                      secondary: true)),
              SizedBox(height: 2.h)
            ])));
  }
}

class SelectedPayItem extends StatelessWidget {
  final Function()? onPressed;
  final bool selected;
  final String text;
  const SelectedPayItem({
    super.key,
    required this.text,
    this.onPressed,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
          height: 5.h,
          width: 60.w,
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: AppThemes().white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                      side: selected
                          ? BorderSide(width: 2, color: AppThemes().secondary)
                          : BorderSide.none)),
              child: Center(
                  child: MyText(
                fontSize: 12.sp,
                type: selected ? FontType.semibold : FontType.regular,
                text: text,
                color:
                    selected ? AppThemes().secondary : AppThemes().notSelected,
              ))))
    ]);
  }
}
