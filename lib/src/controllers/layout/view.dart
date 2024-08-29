import 'dart:ui';
import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ignore: must_be_immutable
class LayoutBizne extends GetWidget<LayoutController> {
  final Map<String, GlobalKey> keys = {};
  late TutorialCoachMark tutorialCoachMark;

  LayoutBizne({super.key});

  @override
  Widget build(BuildContext context) {
    keys['home'] = GlobalKey();
    keys['my_bizne'] = controller.myBizneKey;
    keys['app'] = GlobalKey();
    keys['notifications'] = GlobalKey();
    keys['profile'] = controller.profileKey;

    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      textSkip: AppLocalizations.of(context)!.skip,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        controller.setTutorialFinish();
      },
      onSkip: () {
        return true;
      },
    );

    return PopScope(
        canPop: false,
        onPopInvoked: (a) => controller.popNavigate(),
        child: Obx(() {
          if (controller.showTutorial.value) {
            tutorialCoachMark.show(context: context);
          }
          return Scaffold(
              body: Stack(children: [
                Column(children: [
                  if (controller.getRoute().route.title != null)
                    BizneAppTittle(
                      title: controller.getRoute().route.title!,
                      titleElevation:
                          controller.getRoute().route.titleElevation,
                    ),
                  Expanded(child: controller.getRoute().widget)
                ]),
                if (controller.getRoute().route.buttonBack)
                  BizneBackButton(onPressed: controller.popNavigate)
              ]),
              bottomNavigationBar: controller.getRoute().route.navigationBar
                  ? BizneBottomNavigationBar(
                      currentIndex: controller.currentIndex.value,
                      onChange: controller.changeTab,
                      keys: keys)
                  : null);
        }));
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(TargetFocus(
        identify: "homeScreen",
        keyTarget: controller.homeScreenKey,
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 15.h),
              builder: (context, controller) {
                return MyText(
                    text: AppLocalizations.of(context)!.startUsingBizne,
                    fontSize: 26.sp,
                    type: FontType.semibold,
                    align: TextAlign.center,
                    color: AppThemes().white);
              }),
          TargetContent(
              align: ContentAlign.right,
              builder: (context, controller) {
                return Column(children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppThemes().background,
                        borderRadius: AppThemes().borderRadius,
                      ),
                      child: MyText(
                          text: AppLocalizations.of(context)!
                              .clickOnTheScreenToContinue
                              .toUpperCase(),
                          fontSize: 14.sp,
                          type: FontType.semibold,
                          align: TextAlign.center))
                ]);
              }),
          TargetContent(
              align: ContentAlign.left,
              builder: (context, controller) {
                return Column(
                    children: [Image.asset('assets/images/hand_gesture.png')]);
              })
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5));

    targets.add(TargetFocus(
        identify: "map",
        keyTarget: controller.mapKey,
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.right,
              builder: (context, controller) {
                return Column(children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppThemes().background,
                        borderRadius: AppThemes().borderRadius,
                      ),
                      child: MyText(
                          text: AppLocalizations.of(context)!.findInnsNearYou,
                          fontSize: 14.sp,
                          type: FontType.semibold,
                          align: TextAlign.center))
                ]);
              }),
          TargetContent(
              align: ContentAlign.left,
              builder: (context, controller) {
                return Column(
                    children: [Image.asset('assets/images/hand_gesture.png')]);
              })
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5));

    targets.add(TargetFocus(
        identify: "firstCard",
        keyTarget: controller.firstCardKey,
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 15.h),
              builder: (context, controller) {
                return MyText(
                    text: AppLocalizations.of(context)!.redeemYourBenefit,
                    fontSize: 26.sp,
                    type: FontType.semibold,
                    align: TextAlign.center,
                    color: AppThemes().white);
              }),
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return SizedBox(
                    width: 100.w,
                    child: Row(children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(5.sp),
                              decoration: BoxDecoration(
                                  color: AppThemes().background,
                                  borderRadius: AppThemes().borderRadius),
                              child: MyText(
                                  text: AppLocalizations.of(context)!
                                      .selectYourRestaurantAndClickPay,
                                  fontSize: 14.sp,
                                  type: FontType.semibold,
                                  align: TextAlign.center)))
                    ]));
              }),
          TargetContent(
              align: ContentAlign.left,
              builder: (context, controller) {
                return Column(
                    children: [Image.asset('assets/images/hand_gesture.png')]);
              })
        ],
        shape: ShapeLightFocus.RRect,
        radius: 0));

    targets.add(TargetFocus(
        identify: "myBizne",
        targetPosition: TargetPosition(Size(4.w, 4.h), Offset(28.w, 93.h)),
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Column(children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppThemes().background,
                        borderRadius: AppThemes().borderRadius,
                      ),
                      child: MyText(
                          text: AppLocalizations.of(context)!.enterMyByzne,
                          fontSize: 14.sp,
                          type: FontType.semibold,
                          align: TextAlign.center))
                ]);
              }),
          TargetContent(
              align: ContentAlign.custom,
              customPosition:
                  CustomTargetContentPosition(top: 80.h, left: -40.w),
              builder: (context, controller) {
                return Column(children: [
                  Image.asset('assets/images/hand_gesture_right.png', scale: 4)
                ]);
              })
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5));

    targets.add(TargetFocus(
        identify: "profile",
        targetPosition: TargetPosition(Size(4.w, 4.h), Offset(88.w, 93.h)),
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Column(children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: AppThemes().background,
                          borderRadius: AppThemes().borderRadius),
                      child: MyText(
                          text: AppLocalizations.of(context)!.enterYourProfile,
                          fontSize: 14.sp,
                          type: FontType.semibold,
                          align: TextAlign.center))
                ]);
              }),
          TargetContent(
              align: ContentAlign.custom,
              customPosition:
                  CustomTargetContentPosition(top: 80.h, left: 16.w),
              builder: (context, controller) {
                return Column(children: [
                  Image.asset('assets/images/hand_gesture_right.png', scale: 4)
                ]);
              })
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5));

    targets.add(TargetFocus(
        identify: "final",
        targetPosition: TargetPosition(Size(0.w, 0.h), Offset(50.w, 50.h)),
        enableOverlayTab: true,
        color: Colors.transparent,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 15.h),
              builder: (context, controller) {
                return MyText(
                    text: AppLocalizations.of(context)!.ready,
                    fontSize: 26.sp,
                    type: FontType.semibold,
                    align: TextAlign.center,
                    color: AppThemes().white);
              }),
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 42.h),
              builder: (context, controller) {
                return Column(children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: AppThemes().background,
                          borderRadius: AppThemes().borderRadius),
                      child: MyText(
                          text: AppLocalizations.of(context)!.enjoyYourMeals,
                          fontSize: 14.sp,
                          type: FontType.semibold,
                          align: TextAlign.center))
                ]);
              })
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5));

    return targets;
  }
}

class BizneAppTittle extends StatelessWidget {
  final String title;
  final bool titleElevation;
  const BizneAppTittle(
      {super.key, required this.title, this.titleElevation = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: titleElevation
            ? BoxDecoration(
                color: AppThemes().white,
                boxShadow: [
                  BoxShadow(
                      color: AppThemes().grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0.0, 1.0))
                ],
              )
            : null,
        height: 6.h,
        child: Center(
            child: MyText(
                text: title,
                fontSize: 18.sp,
                color: AppThemes().primary,
                type: FontType.bold)));
  }
}

class BizneBottomNavigationBarItem extends StatelessWidget {
  final void Function() onChange;
  final String label;
  final String asset;
  final bool selected;
  const BizneBottomNavigationBarItem(
      {super.key,
      required this.onChange,
      required this.label,
      required this.asset,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onChange(),
        child: SizedBox(
            width: 20.w,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(height: 20.sp, image: AssetImage(asset)),
              MyText(
                  text: label,
                  type: FontType.bold,
                  color:
                      selected ? AppThemes().primary : AppThemes().notSelected)
            ])));
  }
}

class BizneBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onChange;
  final Map<String, GlobalKey> keys;

  const BizneBottomNavigationBar(
      {super.key,
      required this.currentIndex,
      required this.onChange,
      required this.keys});

  @override
  Widget build(BuildContext context) {
    Map<String, String> routes = {
      'home': AppLocalizations.of(context)!.home,
      'my_bizne': AppLocalizations.of(context)!.myBizne,
      'app': '',
      'notifications': AppLocalizations.of(context)!.notifications,
      'profile': AppLocalizations.of(context)!.profile
    };

    Widget getWidget(int index, String route) {
      if (route == 'app') {
        return InkWell(
            key: keys[route],
            onTap: () => onChange(2),
            child: SizedBox(
                width: 20.w,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: 50.sp,
                          image: const AssetImage('assets/icons/app.png'))
                    ])));
      }
      final label = routes[route]!;
      final asset =
          'assets/icons/${currentIndex == index ? 'selected_$route' : route}.png';
      return BizneBottomNavigationBarItem(
          onChange: () => onChange(index),
          label: label,
          asset: asset,
          selected: currentIndex == index);
    }

    return Container(
      decoration: BoxDecoration(
          color: AppThemes().white,
          boxShadow: [
            BoxShadow(
                color: AppThemes().grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0.0, 1.0))
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(19), topRight: Radius.circular(19))),
      child: SizedBox(
          height: 10.h,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: routes.keys
                  .toList()
                  .asMap()
                  .entries
                  .map((e) => getWidget(e.key, e.value))
                  .toList()
                  .cast<Widget>())),
    );
  }
}
