import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/profiler_avatar.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileHomePage extends LayoutRouteWidget<ProfileHomeController> {
  const ProfileHomePage({super.key});

  Widget getButton(String title, Function() onPressed) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
        child: BizneElevatedButton(
          onPressed: onPressed,
          textSize: 14.sp,
          title: title,
          secondary: true,
          heightFactor: 0.04,
        ));
  }

  @override
  Widget build(BuildContext context) {
    controller.getProfile();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Obx(() => ProfileAvatar(
            imageUrl: controller.user[0].pic,
            placeholderImage: 'assets/images/default_profile.png',
            size: 8.h)),
        SizedBox(
          height: 2.h,
        ),
        Obx(() => NameAndUserState(
              name: '${controller.user[0].name} ${controller.user[0].lastName}',
              verified: controller.user[0].employeeValidated,
            )),
        SizedBox(
          height: 3.h,
        ),
        ...[
          (
            AppLocalizations.of(context)!.profile,
            () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'app_user_profile_profile',
                parameters: {
                  'type': 'button',
                  'name': 'profile'
                }
              );
              controller.navigate(profile, params: controller.user[0]);
            }
          ),
          (
            AppLocalizations.of(context)!.consumptionHistory,
            () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'user_app_profile_consumption_history',
                parameters: {
                  'type': 'button',
                  'name': 'consumption_history'
                }
              );
              controller.consumptionHistoryButton();
            }
          ),
          (
            AppLocalizations.of(context)!.foodHistory,
            () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'user_app_profile_food_history',
                parameters: {
                  'type': 'button',
                  'name': 'food_history'
                }
              );
              controller.navigate(historyFood);
            }
          ),
          (
            AppLocalizations.of(context)!.myReserves,
            () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'user_app_profile_my_reservations',
                parameters: {
                  'type': 'button',
                  'name': 'my_reservations'
                }
              );
              controller.navigate(myReserves);
            }
          ),
          (
            AppLocalizations.of(context)!.legal,
            () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'user_app_profile_legal',
                parameters: {
                  'type': 'button',
                  'name': 'legal'
                }
              );
              controller.navigate(termsAndConditions,
                  params: controller.user[0]);
            }
          ),
          (
            AppLocalizations.of(context)!.logout,
            () async {
              await Get.dialog(BizneDialog(
                  onCancel: () => Get.back(),
                  text: AppLocalizations.of(context)!.areYouSureLogout,
                  onOk: () async {
                    Get.back();
                    await controller.logoutButton();
                  }));
            }
          )
        ].map((e) => getButton(e.$1, e.$2)),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: BizneSupportMyBizneButton(
            firebaseCall: () => FirebaseAnalytics.instance.logEvent(
              name: 'user_app_profile_help',
              parameters: {
                'type': 'button',
                'name': 'help'
              }
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        )
      ],
    );
  }
}
