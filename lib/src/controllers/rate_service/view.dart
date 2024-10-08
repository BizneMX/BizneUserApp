import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RateServicePage extends LayoutRouteWidget<RateServiceController> {
  const RateServicePage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as RateServiceParams;

    final rateArea = Obx(() => SizedBox(
          width: 60.w,
          child: Row(
            children: [
              ...[1, 2, 3, 4, 5].map((e) => Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Image.asset(
                        'assets/icons/${controller.starRate.value >= e ? 'star_filled.png' : 'star_outline.png'}'),
                    onPressed: () => controller.starRate.call(e),
                  ))),
            ],
          ),
        ));

    return SingleChildScrollView(
        child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(children: [
              SizedBox(
                height: 4.h,
              ),
              MyText(
                text: AppLocalizations.of(context)!.rateService,
                fontSize: 20.sp,
                type: FontType.bold,
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration:
                    BoxDecoration(borderRadius: AppThemes().borderRadius),
                child: Image.network(currentParams.establishment.logoPic!),
              ),
              SizedBox(height: 5.h),
              rateArea,
              SizedBox(height: 3.h),
              SizedBox(
                  width: 70.w,
                  child: BizneTextField(
                      hint: AppLocalizations.of(context)!.writeComment,
                      controller: controller.commentController,
                      onSubmited: () => controller.rateService(currentParams),
                      maxLines: 6)),
              SizedBox(height: 6.h),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.5.h),
                  child: BizneElevatedButton(
                      onPressed: () => FirebaseAnalytics.instance
                              .logEvent(name: 'user_app_checkout_confirmation_feedback', parameters: {
                            'type': 'button',
                            'name': 'feedback',
                            'store_id':
                                currentParams.establishment.id.toString()
                          }).then((_) => controller.rateService(currentParams)),
                      title: AppLocalizations.of(context)!.rate)),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.5.h),
                  child: BizneElevatedButton(
                      secondary: true,
                      onPressed: () => FirebaseAnalytics.instance
                              .logEvent(name: 'user_app_checkout_confirmation_skip', parameters: {
                            'type': 'button',
                            'name': 'skip',
                            'store_id':
                                currentParams.establishment.id.toString()
                          }).then((_) => controller.navigate(home)),
                      title: AppLocalizations.of(context)!.skip))
            ])));
  }
}
