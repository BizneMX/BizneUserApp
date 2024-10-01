import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class EditPhonePage extends LayoutRouteWidget<EditPhoneController> {
  const EditPhonePage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final user = params as User;

    final phoneNumberArea =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MyText(text: AppLocalizations.of(context)!.phone, fontSize: 14.sp),
      SizedBox(height: 1.h),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 30.w,
              child: Container(
                  decoration: BoxDecoration(
                      color: AppThemes().whiteInputs,
                      borderRadius: AppThemes().borderRadius),
                  child: CountrySelector(
                    onSelected: (value) => controller.prefixPhone = value,
                  )),
            ),
            SizedBox(
                width: 45.w,
                child: BizneRequiredFieldLogin(
                    countOnSubmited: 10,
                    onSubmited: () => controller.save(),
                    key: controller.phoneKey,
                    validator: controller.phoneValidator,
                    textAlign: TextAlign.center,
                    controller: controller.phoneController,
                    hint: AppLocalizations.of(context)!.phone,
                    isNumber: true))
          ])
    ]);

    final buttonsArea =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneSupportButton(analyticsCallFunction: () async {}),
      SizedBox(height: 3.h),
      BizneElevatedButton(
          onPressed: () {
            controller.save();
          },
          title: AppLocalizations.of(context)!.save)
    ]);

    return SingleChildScrollView(
        child: SizedBox(
            height: 92.h,
            width: 80.w,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 3.h),
                  MyRichText(
                      align: TextAlign.center,
                      text: MyTextSpan(children: [
                        MyTextSpan(
                            text: AppLocalizations.of(context)!
                                .isNoLongerYourPhone1,
                            fontSize: 13.sp),
                        MyTextSpan(
                            text: user.phone,
                            fontSize: 13.sp,
                            type: FontType.bold),
                        MyTextSpan(
                            text: AppLocalizations.of(context)!
                                .isNoLongerYourPhone2,
                            fontSize: 13.sp)
                      ])),
                  SizedBox(height: 2.h),
                  phoneNumberArea,
                  const Expanded(child: SizedBox()),
                  buttonsArea,
                  SizedBox(height: 4.h)
                ])));
  }
}
