import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/chage_password/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends LayoutRouteWidget<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 92.h,
            width: 90.w,
            child: Column(children: [
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.currentPassword,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  key: controller
                      .changePasswordFormController.formKeys['currentPassword'],
                  controller: controller.changePasswordFormController
                      .controllers['currentPassword']!,
                  isPassword: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.passwordRequired;
                    }
                    return null;
                  },
                  onSubmited: () {}),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.newPassword,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  key: controller
                      .changePasswordFormController.formKeys['newPassword'],
                  controller: controller
                      .changePasswordFormController.controllers['newPassword']!,
                  isPassword: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.newPasswordRequired;
                    } else if (value.length < 8) {
                      return AppLocalizations.of(context)!.passwordLength;
                    }
                    return null;
                  },
                  onSubmited: () {}),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.confirmPassword,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  key: controller
                      .changePasswordFormController.formKeys['confirmPassword'],
                  controller: controller.changePasswordFormController
                      .controllers['confirmPassword']!,
                  isPassword: true,
                  suffixError: true,
                  validator: (value) {
                    if (!controller
                        .changePasswordFormController.isPasswordValid) {
                      return AppLocalizations.of(context)!.passwordsDontMatch;
                    }
                    return null;
                  },
                  onSubmited: () => controller.changePassword()),
              const Expanded(child: SizedBox()),
              BizneElevatedButton(
                  onPressed: controller.changePassword,
                  title: AppLocalizations.of(context)!.continueText),
              SizedBox(height: 4.h)
            ])));
  }
}
