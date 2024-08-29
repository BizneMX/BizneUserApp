import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/error/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorPage extends LayoutRouteWidget<ErrorController> {
  const ErrorPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final error = params as String;
    return Column(
      children: [
        SizedBox(
          height: 15.h,
          width: 100.w,
        ),
        MyText(
          color: AppThemes().green,
          text: AppLocalizations.of(context)!.ups,
          type: FontType.bold,
          fontSize: 30.sp,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: 60.w,
          child: MyText(
            align: TextAlign.center,
            fontSize: 20.sp,
            text: error,
            color: AppThemes().primary,
            type: FontType.semibold,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
            width: 70.w,
            child: MyText(
                fontSize: 16.sp,
                align: TextAlign.center,
                color: AppThemes().primary,
                text: AppLocalizations.of(context)!.forMoreInformation)),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () {
              controller.navigate(home);
            },
            title: AppLocalizations.of(context)!.understood,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () async {
              await Utils.contactSupport();
            },
            title: AppLocalizations.of(context)!.contactSupport,
            secondary: true,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }
}
