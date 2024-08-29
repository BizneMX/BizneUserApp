import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsumeYourFoodPage extends LayoutRouteWidget<ConsumeYourFoodController> {
  const ConsumeYourFoodPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as ConsumeYourFoodParams;
  
    return Column(
      children: [
        SizedBox(height: 4.h),
        currentParams.diff <= 0
            ? MyText(
                text: AppLocalizations.of(context)!.youWillPay,
                type: FontType.semibold,
                fontSize: 14.sp,
                color: AppThemes().primary,
              )
            : MyRichText(
                text: MyTextSpan(
                    fontSize: 14.sp,
                    text: '${AppLocalizations.of(context)!.youHavePay} ',
                    color: AppThemes().primary,
                    children: [
                    MyTextSpan(text: AppLocalizations.of(context)!.inCash, type: FontType.bold)
                  ])),
        SizedBox(
          height: 2.h,
        ),
        ...currentParams.diff <= 0
            ? [
                MyText(
                  text: currentParams.amount.toString(),
                  fontSize: 24.sp,
                  color: AppThemes().green,
                  type: FontType.bold,
                ),
                MyText(
                    text: 'BZ Coins',
                    color: AppThemes().green,
                    type: FontType.bold,
                    fontSize: 24.sp),
              ]
            : [
                MyText(
                    fontSize: 24.sp,
                    color: AppThemes().green,
                    type: FontType.bold,
                    text:
                        '${LocalizationFormatters.currencyFormat(currentParams.diff.toDouble().abs())} MXN')
              ],
        SizedBox(
          height: 6.h,
        ),
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(borderRadius: AppThemes().borderRadius),
          child: Image.network(currentParams.establishment.logoPic!),
        ),
        SizedBox(
          height: 6.h,
        ),
        SizedBox(
          width: 60.w,
          child: MyRichText(
              align: TextAlign.center,
              text: MyTextSpan(children: [
                MyTextSpan(
                    fontSize: 18.sp,
                    color: AppThemes().primary,
                    type: FontType.bold,
                    text:
                        '${Utils.extractWords(AppLocalizations.of(context)!.howYouWillConsumeYourFood(currentParams.establishment.name), 0, 4)} '),
                MyTextSpan(
                    fontSize: 18.sp,
                    color: AppThemes().green,
                    type: FontType.bold,
                    text: Utils.extractWords(
                        AppLocalizations.of(context)!.howYouWillConsumeYourFood(
                            currentParams.establishment.name),
                        5,
                        -2)),
                MyTextSpan(
                    fontSize: 18.sp,
                    color: AppThemes().primary,
                    type: FontType.bold,
                    text: Utils.extractWords(
                        AppLocalizations.of(context)!.howYouWillConsumeYourFood(
                            currentParams.establishment.name),
                        -1,
                        -1))
              ])),
        ),
        SizedBox(
          height: 4.h,
        ),
        SizedBox(
          width: 60.w,
          child: MyText(
              align: TextAlign.center,
              text: AppLocalizations.of(context)!.payForDisposable(
                  LocalizationFormatters.currencyFormat(10, decimalDigits: 0))),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: BizneElevatedButton(
            onPressed: () =>
                controller.transactionConfirm(currentParams, false),
            title: AppLocalizations.of(context)!.inTheService,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: BizneElevatedButton(
            onPressed: () => controller.transactionConfirm(currentParams, true),
            title: AppLocalizations.of(context)!.toPickUp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.popNavigate(),
            title: AppLocalizations.of(context)!.returnText,
            secondary: true,
          ),
        ),
        SizedBox(
          height: 3.h,
        )
      ],
    );
  }
}
