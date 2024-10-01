import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/congratulations_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CongratulationsFoodPage
    extends LayoutRouteWidget<CongratulationsFoodController> {
  const CongratulationsFoodPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as CongratulationsFoodParams;
    return SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(children: [
          SizedBox(height: 4.h),
          Image.asset('assets/icons/check.png', width: 20.w),
          SizedBox(height: 3.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  text: currentParams.diff <= 0
                      ? AppLocalizations.of(context)!.youHavePaidForYourMenu
                      : AppLocalizations.of(context)!
                          .youHavePaidForAPartOfYourMenu,
                  fontSize: 20.sp,
                  type: FontType.bold,
                  color: AppThemes().green)),
          SizedBox(height: 3.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  fontSize: 16.sp,
                  type: FontType.semibold,
                  color: AppThemes().primary,
                  text: currentParams.diff <= 0
                      ? AppLocalizations.of(context)!.youPaidBzc(
                          '${currentParams.amount} BzCoins',
                          controller.getName())
                      : AppLocalizations.of(context)!.youPaidCash(
                          LocalizationFormatters.currencyFormat(
                              currentParams.diff.toDouble().abs()),
                          controller.getName()))),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  fontSize: 16.sp,
                  type: FontType.bold,
                  color: AppThemes().green,
                  text: currentParams.establishment.name)),
          SizedBox(height: 2.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  fontSize: 18.sp,
                  type: FontType.semibold,
                  color: AppThemes().primary,
                  text: AppLocalizations.of(context)!.showThisScreen)),
          SizedBox(height: 1.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  fontSize: 18.sp,
                  type: FontType.semibold,
                  color: AppThemes().primary,
                  text: AppLocalizations.of(context)!.byTipping)),
          SizedBox(height: 3.h),
          MyText(
              text: LocalizationFormatters.dateFormat2(DateTime.now()),
              color: AppThemes().primary,
              fontSize: 16.sp,
              type: FontType.semibold),
          SizedBox(height: 1.h),
          const Expanded(child: SizedBox()),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BizneElevatedChildButton(
                  secondary: true,
                  onPressed: () => FirebaseAnalytics.instance
                          .logEvent(name: 'compra', parameters: {
                        'type': 'button',
                        'name': 'contacta_negocio',
                        'store_id': currentParams.establishment.id.toString()
                      }).then((_) => controller.contactBusiness(
                              currentParams.establishment.phone)),
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.all(0.8.h),
                            child:
                                Image.asset('assets/icons/support_chat.png'))),
                    Expanded(
                        flex: 3,
                        child: MyText(
                            type: FontType.semibold,
                            fontSize: 12.sp,
                            color: AppThemes().primary,
                            text:
                                AppLocalizations.of(context)!.contactBusiness))
                  ]))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
              child: BizneElevatedButton(
                  onPressed: () => FirebaseAnalytics.instance
                          .logEvent(name: 'confirmacion', parameters: {
                        'type': 'button',
                        'name': 'contacta_negocio',
                        'store_id': currentParams.establishment.id.toString()
                      }).then((_) => controller.close(currentParams)),
                  title: AppLocalizations.of(context)!.continueText))
        ]));
  }
}
