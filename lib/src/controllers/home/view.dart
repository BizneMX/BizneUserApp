import 'dart:math';

import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/home/card_service_item.dart';
import 'package:bizne_flutter_app/src/controllers/home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/map/view.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class TabItem extends StatelessWidget {
  final Function() onTab;
  final bool selected;
  final String text;
  const TabItem(
      {super.key,
      required this.onTab,
      required this.selected,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 5.0,
        child: InkWell(
            onTap: () => onTab(),
            child: Container(
                height: 4.h,
                color:
                    selected ? AppThemes().secondary : AppThemes().whiteInputs,
                width: 50.w,
                child: Center(
                    child: MyText(
                        fontSize: 14.sp,
                        text: text,
                        color: selected
                            ? AppThemes().white
                            : AppThemes().black)))));
  }
}

class HomePage extends LayoutRouteWidget<HomeController> {
  final GlobalKey homeScreen;
  final GlobalKey map;
  final GlobalKey firstCard;

  const HomePage(
      {super.key,
      required this.homeScreen,
      required this.map,
      required this.firstCard});

  @override
  Widget build(BuildContext context) {
    Widget getFilter(String text, IconData icon, int index) {
      return Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Obx(() => Container(
              decoration: BoxDecoration(
                  color: index == controller.activeFilter.value
                      ? AppThemes().green
                      : AppThemes().white,
                  borderRadius: const BorderRadius.all(Radius.circular(19))),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 2.sp, bottom: 2.sp, left: 4.sp, right: 10.sp),
                  child: InkWell(
                      onTap: () => controller.changeFilter(index),
                      child: Row(children: [
                        Icon(
                          size: 12.sp,
                          icon,
                          color: index == controller.activeFilter.value
                              ? AppThemes().white
                              : AppThemes().grey,
                        ),
                        MyText(
                          text: text,
                          color: index == controller.activeFilter.value
                              ? AppThemes().white
                              : AppThemes().grey,
                        )
                      ]))))));
    }

    final searchArea = SizedBox(
        width: 100.w,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: BizneTextField(
                  onSubmited: () => controller.getEstablishments(clear: true),
                  textAlign: TextAlign.center,
                  hint: AppLocalizations.of(context)!
                      .searchKitchenServiceRestaurant,
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: InkWell(
                          onTap: () =>
                              controller.getEstablishments(clear: true),
                          child:
                              Icon(Icons.search, color: AppThemes().primary))),
                  controller: controller.searchController)),
          Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ...[
                      (
                        AppLocalizations.of(context)!.moreClosest,
                        Icons.location_on,
                        1
                      ),
                      (AppLocalizations.of(context)!.favorites, Icons.star, 2),
                      (AppLocalizations.of(context)!.open, Icons.lock_open, 3),
                      // (AppLocalizations.of(context)!.closed, Icons.lock, 4)
                    ].map((e) => getFilter(e.$1, e.$2, e.$3))
                  ]))),
        ]));

    Widget mapArea(double height) => Obx(() => SizedBox(
        height: height,
        width: 100.w,
        child: Stack(children: [
          MapPage(
            btnPos: max(
                    0,
                    (1 - controller.scrollDraggerController.scroll.value) * 80 -
                        10)
                .h,
          ),
          Positioned(
              top: 38.3.h,
              left: 47.2.w,
              child: SizedBox(key: homeScreen, height: 20, width: 20)),
          Positioned(
              top: 38.3.h,
              left: 47.2.w,
              child: SizedBox(key: map, height: 20, width: 20))
        ])));

    final addressArea = Container(
        width: 90.w,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Stack(children: [
          Obx(() => controller.scrollDraggerController.scroll > 0.75
              ? Positioned(
                  left: 0,
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 2.sp),
                      child: Image.asset(
                        'assets/icons/support_chat.png',
                        color: AppThemes().green,
                        height: 12.sp,
                      ),
                    ),
                    MyRichText(
                        text: MyTextSpan(
                            text: AppLocalizations.of(context)!.support,
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                            type: FontType.bold,
                            color: AppThemes().green,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await FirebaseAnalytics.instance.logEvent(
                                    name: 'map',
                                    parameters: {
                                      'type': 'button',
                                      'name': 'whatsapp'
                                    });
                                await Utils.contactSupport();
                              }))
                  ]))
              : const SizedBox()),
          Center(
              child: MyText(
                  fontSize: 14.sp,
                  type: FontType.semibold,
                  text: '${AppLocalizations.of(context)!.yourLocation}:')),
          Positioned(
              right: 0,
              child: MyRichText(
                  text: MyTextSpan(
                      text: AppLocalizations.of(context)!.edit,
                      fontSize: 12.sp,
                      decoration: TextDecoration.underline,
                      type: FontType.bold,
                      color: AppThemes().primary,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => controller.navigate(changeLocation))))
        ]));

    final selectArea = SizedBox(
        height: 4.h,
        width: 100.w,
        child: Obx(() => Row(children: [
              TabItem(
                  onTab: () {
                    FirebaseAnalytics.instance.logEvent(
                        name: 'main_navbar',
                        parameters: {'type': 'button', 'name': 'fonda'});
                    controller.selectedService.call(true);
                    controller.filterPins();
                    controller.getEstablishments(clear: true);
                  },
                  selected: controller.selectedService.value,
                  text: AppLocalizations.of(context)!.services),
              TabItem(
                  onTab: () {
                    FirebaseAnalytics.instance.logEvent(
                        name: 'main_navbar',
                        parameters: {'type': 'button', 'name': 'restaurantes'});
                    controller.selectedService.call(false);
                    controller.filterPins();
                    controller.getEstablishments(clear: true);
                  },
                  selected: !controller.selectedService.value,
                  text: AppLocalizations.of(context)!.restaurants)
            ])));

    return SingleChildScrollView(
        child: SizedBox(
            height: 90.h,
            child: Column(children: [
              addressArea,
              Expanded(
                  child: Stack(children: [
                Obx(() => controller.scrollDraggerController.scroll.value !=
                        controller.scrollDraggerController.top
                    ? mapArea(90.h)
                    : mapArea(0.h)),
                Column(
                  children: [
                    searchArea,
                    Expanded(
                        child: DraggableHome(
                            firstCard: firstCard,
                            navigate: controller.navigate,
                            transactionData: controller.transactionData,
                            selected: selectArea))
                  ],
                )
              ]))
            ])));
  }
}

class DraggableHome extends GetWidget<ScrollDraggerController> {
  final Function(Establishment establishment) transactionData;
  final Function(String, {dynamic params}) navigate;
  final GlobalKey firstCard;
  final Widget selected;
  const DraggableHome(
      {super.key,
      required this.firstCard,
      required this.selected,
      required this.navigate,
      required this.transactionData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          controller.dragUpdate(details.delta.dy);
        },
        child: DraggableScrollableSheet(
            controller: controller.scrollDraggableController,
            initialChildSize: controller.middle,
            minChildSize: controller.bottom,
            maxChildSize: controller.top,
            builder: (BuildContext context, ScrollController scrollController) {
              return Obx(() => Container(
                  decoration: BoxDecoration(
                      color: controller.scroll.value == controller.bottom
                          ? Colors.transparent
                          : AppThemes().white,
                      borderRadius: controller.scroll.value == controller.top
                          ? null
                          : const BorderRadius.only(
                              topLeft: Radius.circular(19),
                              topRight: Radius.circular(19))),
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.8.h),
                        child: controller.scroll.value == controller.top
                            ? Divider(
                                color: AppThemes().grey,
                                thickness: 3,
                                indent: 40.w,
                                endIndent: 40.w)
                            : Image.asset(
                                color: AppThemes().grey,
                                width: 20.w,
                                'assets/icons/swipe_middle_bottom.png')),
                    if (controller.scroll > controller.bottomMiddle)
                      Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: selected),
                    Expanded(
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: controller.establishments.length,
                            itemBuilder: (buildContext, index) {
                              controller
                                  .scrollControllerSubscribe(scrollController);
                              final establishment =
                                  controller.establishments[index];
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  child: CardItemService(
                                      item: establishment,
                                      navigate: navigate,
                                      eatHere: transactionData,
                                      tutorialKey:
                                          index == 0 ? firstCard : null));
                            }))
                  ])));
            }));
  }
}
