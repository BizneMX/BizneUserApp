import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/login/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/selectors.dart';

class LoginPage extends GetWidget<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isNew = Get.arguments;

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
                    onSubmited: () => controller.preLogin.value
                        ? controller.continuePreLogin(isNew)
                        : controller.continueLogin(),
                    key: controller.phoneKey,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }

                      return null;
                    },
                    textAlign: TextAlign.center,
                    controller: controller.phoneController,
                    hint: AppLocalizations.of(context)!.phone,
                    isNumber: true))
          ])
    ]);

    final passwordArea =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MyText(text: AppLocalizations.of(context)!.password, fontSize: 14.sp),
      SizedBox(height: 5.sp),
      SizedBox(
        child: BizneTextFormField(
            onSubmited: () => controller.continueLogin(),
            isPassword: true,
            key: controller.passwordKey,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.requiredField;
              }
              if (value.length < 8) {
                return AppLocalizations.of(context)!.passwordLength;
              }

              return null;
            },
            controller: controller.passwordController),
      ),
      SizedBox(
        height: 1.h,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        MyRichText(
            text: MyTextSpan(
                color: AppThemes().primary,
                text: AppLocalizations.of(context)!.forgotPassword,
                decoration: TextDecoration.underline,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.goToRecoverPassword()))
      ])
    ]);

    final buttonsArea =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneElevatedButton(
          onPressed: () {
            controller.preLogin.value
                ? controller.continuePreLogin(isNew)
                : controller.continueLogin();
          },
          title: AppLocalizations.of(context)!.continueText),
      SizedBox(height: 3.h),
      const BizneSupportButton(),
    ]);

    return Scaffold(
        body: Stack(children: [
      Center(
          child: SingleChildScrollView(
              child: SizedBox(
                  width: 80.w,
                  height: 100.h,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 3.h),
                        SizedBox(
                            height: 15.h,
                            child: const Image(
                                image: AssetImage('assets/images/logo.png'))),
                        SizedBox(height: 3.h),
                        MyText(
                            text: AppLocalizations.of(context)!.loginOrRegister,
                            color: AppThemes().primary,
                            fontSize: 20.sp,
                            type: FontType.bold),
                        MyText(
                            text: AppLocalizations.of(context)!.phoneDigits,
                            fontSize: 14.sp,
                            type: FontType.light),
                        SizedBox(height: 2.h),
                        phoneNumberArea,
                        SizedBox(height: 3.h),
                        SizedBox(
                            height: 18.h,
                            child: Obx(() => controller.preLogin.value
                                ? Container()
                                : passwordArea)),
                        SizedBox(height: 6.h),
                        MyText(
                            text: AppLocalizations.of(context)!
                                .contactSupportAccount,
                            fontSize: 14.sp,
                            align: TextAlign.center),
                        const Expanded(child: SizedBox()),
                        buttonsArea,
                        SizedBox(height: 4.h)
                      ])))),
      BizneBackButton(onPressed: () => Get.back())
    ]));
  }
}
