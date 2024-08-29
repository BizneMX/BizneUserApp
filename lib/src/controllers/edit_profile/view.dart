import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/edit_profile/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/register/view.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/utils.dart';

class EditProfilePage extends LayoutRouteWidget<EditProfileController> {
  const EditProfilePage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final user = params as User;
    controller.setValues(user);
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
                  text: AppLocalizations.of(context)!.nameS,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  onSubmited: () {},
                  suffixError: true,
                  textAlign: TextAlign.center,
                  key: controller.editProfileFormController.formKeys['name'],
                  controller:
                      controller.editProfileFormController.controllers['name']!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  }),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.lastName,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  onSubmited: () {},
                  suffixError: true,
                  textAlign: TextAlign.center,
                  key:
                      controller.editProfileFormController.formKeys['lastName'],
                  controller: controller
                      .editProfileFormController.controllers['lastName']!,
                  validator: (value) {
                    final splitted = value!.split(' ');
                    if (splitted.length < 2 || splitted[1].isEmpty) {
                      return AppLocalizations.of(context)!.fillLastName;
                    }
                    return null;
                  }),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.email,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  onSubmited: () {},
                  suffixError: true,
                  textAlign: TextAlign.center,
                  key: controller.editProfileFormController.formKeys['email'],
                  controller: controller
                      .editProfileFormController.controllers['email']!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredEmail;
                    } else if (!GetUtils.isEmail(value)) {
                      return AppLocalizations.of(context)!.invalidEmail;
                    }
                    return null;
                  }),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.dateOfBirth,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BizneTextFormField(
                  onSubmited: () {},
                  hint: '__/__/____',
                  suffixError: true,
                  textAlign: TextAlign.center,
                  isNumber: true,
                  key: controller
                      .editProfileFormController.formKeys['birthdate'],
                  controller: controller
                      .editProfileFormController.controllers['birthdate']!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    } else if (!Utils.validDate(value)) {
                      return AppLocalizations.of(context)!.invalidDate;
                    }
                    return null;
                  }),
              SizedBox(height: 2.h),
              SizedBox(
                width: 75.w,
                child: MyText(
                  fontSize: 14.sp,
                  text: AppLocalizations.of(context)!.genre,
                  color: AppThemes().primary,
                  type: FontType.bold,
                ),
              ),
              SizedBox(height: 1.h),
              SizedBox(height: 10.h, child: const GenreSelector()),
              const Expanded(child: SizedBox()),
              BizneElevatedButton(
                  onPressed: () => controller.save(user),
                  title: AppLocalizations.of(context)!.continueText),
              SizedBox(height: 4.h)
            ])));
  }
}
