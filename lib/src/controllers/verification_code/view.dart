import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerificationCodePage extends GetWidget<VerificationCodeController> {
  const VerificationCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topArea = controller.currentParams.changePhone
        ? [
            SizedBox(
              height: 2.h,
            ),
            MyText(
                text: AppLocalizations.of(context)!.verificationCode,
                color: AppThemes().primary,
                fontSize: 18.sp,
                type: FontType.bold),
            SizedBox(
              height: 5.h,
            )
          ]
        : [
            SizedBox(height: 3.h),
            SizedBox(
                height: 15.h,
                child:
                    const Image(image: AssetImage('assets/images/logo.png'))),
            SizedBox(height: 3.h),
            MyText(
                text: AppLocalizations.of(context)!.verificationCode,
                color: AppThemes().primary,
                fontSize: 20.sp,
                type: FontType.bold),
          ];

    posteriorDialog() async {
      final text = AppLocalizations.of(context)!.resendCode;
      await Get.dialog(BizneDialog(text: text, onOk: () => Get.back()),
          barrierDismissible: true);
    }

    final codeArea = Column(children: [
      MyText(
        fontSize: 14.sp,
        text: "${AppLocalizations.of(context)!.yourCodeExpires}:",
        color: AppThemes().black,
      ),
      Obx(() => MyText(
          text: controller.formatSecond(controller.seconds.value),
          color: AppThemes().primary,
          fontSize: 35.sp,
          type: FontType.bold)),
      SizedBox(
        height: 3.h,
      ),
      Obx(() => BizneElevatedButton(
            onPressed: controller.seconds.value == 0
                ? () async {
                    if (await controller
                        .resendCode(controller.currentParams.phone)) {
                      await posteriorDialog();
                    }
                  }
                : null,
            title: AppLocalizations.of(context)!.resendTheCode,
            secondary: true,
          ))
    ]);

    final buttonsArea =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneSupportButton(
        analyticsCallFunction: () async {
          await FirebaseAnalytics.instance.logEvent(
              name: 'code_verification',
              parameters: {'type': 'button', 'name': 'help'});
        },
      ),
      SizedBox(height: 3.h),
      BizneElevatedButton(
          onPressed: controller.currentParams.changePhone
              ? () => controller.changePhone(controller.currentParams.phone)
              : () => controller.checkCode(controller.currentParams.phone),
          title: AppLocalizations.of(context)!.checkPhone)
    ]);

    return Scaffold(
        body: Stack(
      children: [
        Center(
            child: SingleChildScrollView(
                child: SizedBox(
                    width: 80.w,
                    height: 100.h,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...topArea,
                          SizedBox(
                            width: 80.w,
                            child: Stack(children: [
                              MyText(
                                fontSize: 13.sp,
                                text:
                                    "${AppLocalizations.of(context)!.enterVerificationCode}: ${controller.currentParams.phone}",
                                align: TextAlign.center,
                                type: FontType.light,
                              ),
                              Positioned(
                                  bottom: 2.sp,
                                  right: 0,
                                  child: RichText(
                                      text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .edit,
                                            style: TextStyle(
                                                color: AppThemes().primary,
                                                fontWeight:
                                                    FontTypeWeight.getFontType(
                                                        FontType.bold),
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = controller
                                                      .currentParams.changePhone
                                                  ? () => Get.back()
                                                  : () => Get.back())
                                      ])))
                            ]),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          BizneRequiredFieldLogin(
                            countOnSubmited: 6,
                            isNumber: true,
                            onSubmited: controller.currentParams.changePhone
                                ? () => controller
                                    .changePhone(controller.currentParams.phone)
                                : () => controller
                                    .checkCode(controller.currentParams.phone),
                            key: controller.codeKey,
                            suffixError: true,
                            validator: controller.codeValidator,
                            controller: controller.codeController,
                            hint:
                                AppLocalizations.of(context)!.verificationCode,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6.h),
                          codeArea,
                          const Expanded(child: SizedBox()),
                          buttonsArea,
                          SizedBox(height: 4.h)
                        ])))),
        BizneBackButton(onPressed: () => Get.back())
      ],
    ));
  }
}
