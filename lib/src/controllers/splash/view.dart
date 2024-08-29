import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/buttons.dart';
import 'controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return SizedBox(
        height: 100.h,
        width: 100.w,
        child: Image.asset('assets/images/splash.png', fit: BoxFit.cover));
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget entranceOption(String image, String text, Function() onTap,
        Color color, bool isSelected) {
      return SizedBox(
          height: 17.h,
          width: 17.h,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes().white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: isSelected ? color : AppThemes().whiteInputs,
                          width: 2),
                      borderRadius: AppThemes().borderRadius)),
              onPressed: onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        height: 7.h,
                        child: Image.asset('assets/images/$image.png',
                            fit: BoxFit.cover)),
                    SizedBox(
                        height: 6.h,
                        child: Center(
                            child: MyText(
                                text: text,
                                align: TextAlign.center,
                                fontSize: 10.sp,
                                color: color,
                                type: FontType.bold)))
                  ])));
    }

    final chooseEntrance = Column(children: [
      MyText(
          text: AppLocalizations.of(context)!.welcome,
          fontSize: 16.sp,
          color: AppThemes().primary,
          type: FontType.bold),
      MyText(
          text: AppLocalizations.of(context)!.chooseEntrance,
          fontSize: 14.sp,
          color: AppThemes().primary,
          type: FontType.light),
      SizedBox(height: 6.h),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        entranceOption('old_user', AppLocalizations.of(context)!.iHaveAccount,
            () {
          Get.toNamed(login, arguments: false);
        }, AppThemes().secondary, false),
        entranceOption('new_user', AppLocalizations.of(context)!.iAmNew, () {
          Get.toNamed(login, arguments: true);
        }, AppThemes().tertiary, false)
      ])
    ]);

    const buttonArea =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneSupportButton(
        secondary: false,
      ),
    ]);

    return Scaffold(
        body: Center(
            child: SizedBox(
                width: 80.w,
                child: Column(children: [
                  SizedBox(height: 3.h),
                  SizedBox(
                      height: 15.h,
                      child: const Image(
                          image: AssetImage('assets/images/logo.png'))),
                  SizedBox(height: 3.h),
                  chooseEntrance,
                  Expanded(
                      child: SizedBox(
                          child: Center(
                              child: MyText(
                                  align: TextAlign.center,
                                  fontSize: 14.sp,
                                  type: FontType.regular,
                                  text: AppLocalizations.of(context)!
                                      .yourAccountIsOld)))),
                  buttonArea,
                  SizedBox(height: 4.h)
                ]))));
  }
}
