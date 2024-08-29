import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/recover_password/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoverPasswordPage extends GetWidget<RecoverPasswordController> {
  const RecoverPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    posteriorDialog() async {
      final text = controller.selectedEmail.value
          ? AppLocalizations.of(context)!.emailSent
          : AppLocalizations.of(context)!.smsSent;
      await Get.dialog(BizneDialog(text: text, onOk: () => Get.back()),
          barrierDismissible: true);
    }

    final methodArea = Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => _SelectedMethod(
                  selected: controller.selectedEmail.value,
                  onPressed: () {
                    controller.changeSelected(true);
                  },
                  icon: Icons.mail_outline_rounded,
                  text: AppLocalizations.of(context)!.byEmail)),
              Obx(() => _SelectedMethod(
                  selected: !controller.selectedEmail.value,
                  onPressed: () {
                    controller.changeSelected(false);
                  },
                  icon: Icons.phone_outlined,
                  text: AppLocalizations.of(context)!.byPhone))
            ]));

    final messageMethod = Obx(() => MyText(
        fontSize: 14.sp,
        align: TextAlign.center,
        text: controller.selectedEmail.value
            ? AppLocalizations.of(context)!.recoverPasswordByEmail
            : AppLocalizations.of(context)!.recoverPasswordByPhone));

    final phoneNumberArea =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MyText(text: AppLocalizations.of(context)!.phone, fontSize: 14.sp),
      SizedBox(height: 5.sp),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                key: controller.phoneKey,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }

                  return null;
                },
                textAlign: TextAlign.center,
                controller: controller.phoneNumberController,
                hint: AppLocalizations.of(context)!.phone,
                onSubmited: () async {
                  if (await controller.recoverPassword()) {
                    await posteriorDialog();
                  }
                },
                isNumber: true))
      ])
    ]);

    final emailArea =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MyText(text: AppLocalizations.of(context)!.email, fontSize: 14.sp),
      SizedBox(height: 5.sp),
      SizedBox(
          height: 8.h,
          child: BizneRequiredField(
              onSubmited: () async {
                if (await controller.recoverPassword()) {
                  await posteriorDialog();
                }
              },
              key: controller.emailKey,
              controller: controller.emailController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.requiredField;
                }
                if (!value.isEmail) {
                  return AppLocalizations.of(context)!.invalidEmail;
                }

                return null;
              },
              hint: AppLocalizations.of(context)!.email,
              isNumber: false))
    ]);

    final inputArea =
        Obx(() => controller.selectedEmail.value ? emailArea : phoneNumberArea);

    final buttonsArea =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneElevatedButton(
          onPressed: () async {
            if (await controller.recoverPassword()) {
              await posteriorDialog();
            }
          },
          title: AppLocalizations.of(context)!.send),
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
                            text: AppLocalizations.of(context)!.recoverPassword,
                            color: AppThemes().primary,
                            fontSize: 20.sp,
                            type: FontType.bold),
                        MyText(
                          align: TextAlign.center,
                          text: AppLocalizations.of(context)!
                              .recoverPasswordMethod,
                          fontSize: 14.sp,
                          type: FontType.light,
                        ),
                        SizedBox(height: 2.h),
                        methodArea,
                        SizedBox(
                          height: 2.h,
                        ),
                        messageMethod,
                        SizedBox(height: 3.h),
                        inputArea,
                        const Expanded(child: SizedBox()),
                        buttonsArea,
                        SizedBox(height: 3.h)
                      ])))),
      BizneBackButton(onPressed: () => Get.back()),
    ]));
  }
}

class _SelectedMethod extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;
  final bool selected;
  const _SelectedMethod(
      {required this.selected,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 12.h,
        height: 12.h,
        child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                backgroundColor: MaterialStateProperty.all(AppThemes().white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                    side: selected
                        ? BorderSide(width: 2, color: AppThemes().secondary)
                        : BorderSide.none))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon,
                      size: 30.sp,
                      color: selected
                          ? AppThemes().secondary
                          : AppThemes().notSelected),
                  SizedBox(height: 5.sp),
                  MyText(
                      text: text,
                      color: selected
                          ? AppThemes().secondary
                          : AppThemes().notSelected,
                      fontSize: 10.sp)
                ])));
  }
}
