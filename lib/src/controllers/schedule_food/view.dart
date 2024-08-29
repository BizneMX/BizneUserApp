import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/controller.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScheduleFoodPage extends LayoutRouteWidget<ScheduleFoodController> {
  const ScheduleFoodPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final establishment = params as Establishment;

    Widget getRule(String text) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.sp, right: 5.sp),
              child: Icon(
                Icons.circle,
                size: 5.sp,
                color: AppThemes().primary,
              ),
            ),
            Expanded(
                child: MyText(
              fontSize: 14.sp,
              type: FontType.semibold,
              text: text,
              color: AppThemes().primary,
            ))
          ],
        ),
      );
    }

    return SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(children: [
          SizedBox(height: 6.h),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.h, right: 5.w),
                        child: Image.asset('assets/icons/calendar.png'),
                      )),
                  Expanded(
                    flex: 3,
                    child: MyText(
                      text: AppLocalizations.of(context)!
                          .reviewTheRulesToScheduleYourMeal,
                      type: FontType.bold,
                      color: AppThemes().primary,
                      fontSize: 16.sp,
                    ),
                  )
                ],
              )),
          SizedBox(height: 8.h),
          getRule(AppLocalizations.of(context)!.placeYourOrder),
          getRule(AppLocalizations.of(context)!.reserveAtLeast3Hours),
          getRule(AppLocalizations.of(context)!.chooseNearbyBusinesses),
          getRule(AppLocalizations.of(context)!.theOrderIsPlaced),
          const Expanded(child: SizedBox()),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BizneElevatedChildButton(
                  secondary: true,
                  onPressed: () =>
                      controller.contactBusiness(establishment.phone),
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(0.8.h),
                          child: Image.asset('assets/icons/support_chat.png'),
                        )),
                    Expanded(
                        flex: 3,
                        child: MyText(
                          type: FontType.semibold,
                          fontSize: 12.sp,
                          color: AppThemes().primary,
                          text: AppLocalizations.of(context)!.contactBusiness,
                        ))
                  ]))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
            child: BizneElevatedButton(
              onPressed: () => controller.popNavigate(),
              title: AppLocalizations.of(context)!.close,
            ),
          )
        ]));
  }
}
