import 'dart:async';
import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/my_text.dart';
import '../../themes.dart';
import 'controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PermissionPage extends GetView<PermissionController> {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> deniedLocation() async {
      return await Get.dialog(Center(
          child: Container(
              decoration: BoxDecoration(
                  color: AppThemes().white,
                  borderRadius: AppThemes().borderRadius),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 20.h,
              width: 80.w,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyText(
                        text: AppLocalizations.of(context)!.locationPermission,
                        color: AppThemes().primary,
                        fontSize: 14.sp,
                        type: FontType.bold,
                        align: TextAlign.center),
                    BizneElevatedButton(
                        onPressed: () {
                          Get.back(result: true);
                        },
                        title: AppLocalizations.of(context)!.understood)
                  ]))));
    }

    final permissions = <Widget>[
      LocationPermission(
        accept: () => controller.acceptLocation(() => deniedLocation()),
        fail: () => deniedLocation(),
      ),
      NotificationPermission(
        accept: () => controller.acceptNotification(),
        fail: () => controller.deniedNotification(),
      )
    ];

    return Container(
        color: AppThemes().primary,
        child: SafeArea(
            child: Obx(() => permissions[controller.permissionToInt()])));
  }
}

class PermissionView extends StatelessWidget {
  final String image;
  final String text;
  final String subText;
  final void Function() accept;
  final void Function() fail;

  const PermissionView(
      {super.key,
      required this.image,
      required this.text,
      required this.subText,
      required this.accept,
      required this.fail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: AppThemes().background,
            child: SizedBox(
                width: 100.w,
                child: Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: 3.h),
                      height: 25.h,
                      width: 90.w,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(
                                text: text,
                                align: TextAlign.center,
                                type: FontType.bold,
                                fontSize: 20.sp,
                                color: AppThemes().primary),
                            MyText(
                                text: subText,
                                align: TextAlign.center,
                                type: FontType.light,
                                fontSize: 14.sp,
                                color: AppThemes().primary)
                          ])),
                  Expanded(
                      child: SizedBox(width: 80.w, child: Image.asset(image))),
                  Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      width: 70.w,
                      height: 20.h,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BizneElevatedButton(
                                onPressed: accept,
                                title: AppLocalizations.of(context)!.allow),
                            BizneTextButton(
                                onPressed: fail,
                                title: AppLocalizations.of(context)!.notAllowed)
                          ]))
                ]))));
  }
}

class LocationPermission extends StatelessWidget {
  final void Function() accept;
  final void Function() fail;
  const LocationPermission(
      {super.key, required this.accept, required this.fail});

  @override
  Widget build(BuildContext context) {
    return PermissionView(
      image: 'assets/images/location_permission.png',
      text: AppLocalizations.of(context)!.locationPermission1,
      subText: AppLocalizations.of(context)!.establishmentsAvailableNearYou,
      accept: accept,
      fail: fail,
    );
  }
}

class NotificationPermission extends StatelessWidget {
  final void Function() accept;
  final void Function() fail;
  const NotificationPermission(
      {super.key, required this.accept, required this.fail});

  @override
  Widget build(BuildContext context) {
    return PermissionView(
      image: 'assets/images/notification_permission.png',
      text: AppLocalizations.of(context)!.canWeSendYouNotifications,
      subText: AppLocalizations.of(context)!.withNotificationsWeCan,
      accept: accept,
      fail: fail,
    );
  }
}
