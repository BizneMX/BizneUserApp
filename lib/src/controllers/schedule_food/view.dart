import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/controller.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/text_filed.dart';
import '../../components/utils.dart';
import '../web_view/view.dart';

class ScheduleFoodRulesPage extends LayoutRouteWidget<ScheduleFoodController> {
  const ScheduleFoodRulesPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    controller.restartValues();
    final establishment = params as Establishment;

    return SingleChildScrollView(
      child: SizedBox(
          height: 90.h,
          width: 100.w,
          child: Column(children: [
            SizedBox(height: 6.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(top: 1.h, right: 5.w),
                              child: Image.asset('assets/icons/calendar.png'))),
                      Expanded(
                          flex: 3,
                          child: MyText(
                              text: AppLocalizations.of(context)!
                                  .reviewTheRulesToScheduleYourMeal,
                              type: FontType.bold,
                              color: AppThemes().primary,
                              fontSize: 16.sp))
                    ])),
            SizedBox(height: 8.h),
            const BookingRules(),
            const Expanded(child: SizedBox()),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: BizneElevatedButton(
                    secondary: true,
                    onPressed: () async {
                      if (await controller.initBooking(establishment.id)) {
                        controller.navigate(scheduleFoodStepOne,
                            params: establishment);
                      }
                    },
                    title: AppLocalizations.of(context)!.continueBooking)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                child: BizneElevatedButton(
                    onPressed: () => controller.popNavigate(),
                    title: AppLocalizations.of(context)!.close))
          ])),
    );
  }
}

class BookingRules extends StatelessWidget {
  final double? fontSize;
  final EdgeInsets? padding;
  const BookingRules({super.key, this.fontSize, this.padding});

  Widget getRule(String text) {
    return Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 5.sp, right: 5.sp),
              child:
                  Icon(Icons.circle, size: 5.sp, color: AppThemes().primary)),
          Expanded(
              child: MyText(
                  fontSize: fontSize ?? 14.sp,
                  type: FontType.semibold,
                  text: text,
                  color: AppThemes().primary))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      getRule(AppLocalizations.of(context)!.onlyNextDay),
      getRule(AppLocalizations.of(context)!.atLeastFive),
      getRule(AppLocalizations.of(context)!.youNeedPoints),
      getRule(AppLocalizations.of(context)!.onlyMenuBizne)
    ]);
  }
}

class ScheduleFoodStepOnePage
    extends LayoutRouteWidget<ScheduleFoodController> {
  const ScheduleFoodStepOnePage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final establishment = params as Establishment;

    return SingleChildScrollView(
        child: SizedBox(
            height: 90.h,
            width: 80.w,
            child: Column(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          establishment.logoPic == null
                              ? const SizedBox()
                              : ClipRRect(
                                  borderRadius: AppThemes().borderRadius,
                                  child: Image.network(
                                      height: 8.h,
                                      width: 8.h,
                                      fit: BoxFit.cover,
                                      establishment.logoPic!)),
                          Column(children: [
                            MyText(
                                text:
                                    AppLocalizations.of(context)!.youAreBooking,
                                color: AppThemes().primary,
                                fontSize: 16.sp,
                                type: FontType.bold),
                            MyText(
                                text: establishment.name,
                                color: AppThemes().green,
                                fontSize: 16.sp,
                                type: FontType.bold)
                          ])
                        ])),
                // MyText(
                //     text: AppLocalizations.of(context)!.whatMealBook,
                //     fontSize: 14.sp,
                //     type: FontType.regular),
                // Padding(
                //     padding: EdgeInsets.symmetric(vertical: 1.h),
                //     child: SelectMealWidget(
                //         initialState: controller.plateState,
                //         onChange: controller.changePlateState)),
                MyText(
                    text: AppLocalizations.of(context)!.selectDate,
                    fontSize: 14.sp,
                    type: FontType.regular),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Container(
                        height: 5.h,
                        decoration: BoxDecoration(
                            borderRadius: AppThemes().borderRadius,
                            color: AppThemes().whiteInputs),
                        child: Center(
                            child: MyText(
                                text: LocalizationFormatters.dateFormat4(
                                    DateTime.now()
                                        .add(const Duration(days: 1))))))),
                MyText(
                    text: AppLocalizations.of(context)!.selectTime,
                    fontSize: 14.sp,
                    type: FontType.regular),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: TimeIntervalSelector(
                        initialInterval: controller.timeInterval,
                        intervals: controller.intervals,
                        onChange: (value) => controller.timeInterval = value)),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: SizedBox(
                        width: 80.w,
                        child: ElevatedButton(
                            onPressed: () => controller.menuUrl.isEmpty
                                ? Get.dialog(BizneDialog(
                                    text: AppLocalizations.of(context)!
                                        .menuNotAvailable,
                                    onOk: () => Get.back()))
                                : Get.toNamed(webView,
                                    arguments: WebViewParams(
                                        title:
                                            AppLocalizations.of(context)!.menu,
                                        url: controller.menuUrl)),
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                side: BorderSide(
                                    color: AppThemes().primary, width: 1)),
                            child: Stack(children: [
                              Row(children: [
                                Image.asset('assets/icons/menu_dishes.png',
                                    scale: 3),
                                const Expanded(child: SizedBox())
                              ]),
                              Center(
                                  child: MyText(
                                      text: AppLocalizations.of(context)!
                                          .seeTomorrowMenu,
                                      type: FontType.bold))
                            ])))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Obx(() => Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: BizneElevatedButton(
                                  heightFactor: 0.04,
                                  secondary: controller.menuSelected.value == 2,
                                  textSize: 12.sp,
                                  color: AppThemes().secondary,
                                  onPressed: () => controller.menuSelected(1),
                                  title: AppLocalizations.of(context)!.menu1)),
                          Expanded(
                              flex: 1,
                              child: MyText(
                                fontSize: 14.sp,
                                type: FontType.bold,
                                align: TextAlign.center,
                                text: AppLocalizations.of(context)!.o,
                              )),
                          Expanded(
                              flex: 2,
                              child: BizneElevatedButton(
                                  heightFactor: 0.04,
                                  textSize: 12.sp,
                                  color: AppThemes().secondary,
                                  secondary: controller.menuSelected.value == 1,
                                  onPressed: () => controller.menuSelected(2),
                                  title: AppLocalizations.of(context)!.menu2))
                        ],
                      )),
                ),
                MyText(
                    text: AppLocalizations.of(context)!.deliveryDetails,
                    fontSize: 14.sp,
                    type: FontType.regular),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                            borderRadius: AppThemes().borderRadius,
                            color: AppThemes().whiteInputs),
                        child: BizneTextFormField(
                            validator: (_) => null,
                            hint:
                                AppLocalizations.of(context)!.doorExitReception,
                            controller: controller.deliveryDetailTextController,
                            onSubmited: () => controller.navigate(
                                scheduleFoodStepTwo,
                                params: establishment),
                            maxLines: 4)))
              ]),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    MyText(
                        text: AppLocalizations.of(context)!.payWithApp,
                        fontSize: 20.sp,
                        color: AppThemes().primary,
                        type: FontType.bold),
                    Column(children: [
                      MyText(
                          text:
                              '${LocalizationFormatters.numberFormat(double.parse(controller.menuPrice), decimalDigits: 0)} BzCoins',
                          fontSize: 30.sp,
                          type: FontType.bold,
                          color: AppThemes().green)
                    ])
                  ])),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: BizneElevatedButton(
                      onPressed: () => controller.navigate(scheduleFoodStepTwo,
                          params: establishment),
                      title: AppLocalizations.of(context)!.continueText))
            ])));
  }
}

class SelectMealWidget extends StatefulWidget {
  final int initialState;
  final void Function(int) onChange;
  const SelectMealWidget(
      {super.key, required this.initialState, required this.onChange});

  @override
  State<SelectMealWidget> createState() => _SelectMealWidgetState();
}

class _SelectMealWidgetState extends State<SelectMealWidget> {
  int state = -1;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      getMeal(AppLocalizations.of(context)!.breakfast, 0),
      getMeal(AppLocalizations.of(context)!.lunch, 1),
      getMeal(AppLocalizations.of(context)!.meal, 2)
    ]);
  }

  Widget getMeal(String text, int value) {
    bool isSelected = value == state;
    return GestureDetector(
        onTap: () => setState(() {
              state = value;
              widget.onChange(value);
            }),
        child: Container(
            height: 5.h,
            width: 25.w,
            decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(color: AppThemes().secondary, width: 2)
                    : null,
                borderRadius: AppThemes().borderRadius,
                color: AppThemes().whiteInputs),
            child: Center(
                child: MyText(
                    text: text,
                    type: isSelected ? FontType.bold : FontType.regular,
                    color: isSelected ? AppThemes().secondary : null))));
  }
}

class ScheduleFoodStepTwoPage
    extends LayoutRouteWidget<ScheduleFoodController> {
  const ScheduleFoodStepTwoPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final establishment = params as Establishment;

    return SingleChildScrollView(
      child: SizedBox(
          height: 90.h,
          width: 80.w,
          child: Column(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        establishment.logoPic == null
                            ? const SizedBox()
                            : ClipRRect(
                                borderRadius: AppThemes().borderRadius,
                                child: Image.network(
                                    height: 8.h,
                                    width: 8.h,
                                    fit: BoxFit.cover,
                                    establishment.logoPic!)),
                        Column(children: [
                          MyText(
                              text: AppLocalizations.of(context)!.youAreBooking,
                              color: AppThemes().primary,
                              fontSize: 16.sp,
                              type: FontType.bold),
                          MyText(
                              text: establishment.name,
                              color: AppThemes().green,
                              fontSize: 16.sp,
                              type: FontType.bold)
                        ])
                      ]))
            ]),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(children: [
                  infoAclaration(AppLocalizations.of(context)!.payWithApp,
                      '${LocalizationFormatters.numberFormat(double.parse(controller.menuPrice), decimalDigits: 0)} BzCoins'),
                  infoAclaration(
                      AppLocalizations.of(context)!.deliveryDate,
                      LocalizationFormatters.dateFormat3(
                          controller.selectedDate)),
                  infoAclaration(AppLocalizations.of(context)!.deliveryTime,
                      controller.timeInterval),
                  infoAclaration(
                      AppLocalizations.of(context)!.selectedMenu,
                      controller.menuSelected.value == 1
                          ? AppLocalizations.of(context)!.menu1
                          : AppLocalizations.of(context)!.menu2),
                  if (controller.deliveryDetailTextController.text.isNotEmpty)
                    infoAclaration('${AppLocalizations.of(context)!.details}:',
                        controller.deliveryDetailTextController.text)
                ])),
            const Expanded(child: SizedBox()),
            MyText(
                text:
                    '*${AppLocalizations.of(context)!.payForDisposable('\$10MXN')}',
                fontSize: 14.sp,
                align: TextAlign.center),
            Padding(
                padding: EdgeInsets.only(bottom: 7.h, top: 3.h),
                child: BizneElevatedButton(
                    onPressed: () => controller.confirmBooking(establishment),
                    title: AppLocalizations.of(context)!.confirmAndPay))
          ])),
    );
  }

  Widget infoAclaration(String text, String info) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(children: [
          Expanded(
              flex: 4,
              child: MyText(
                  text: text,
                  type: FontType.bold,
                  fontSize: 14.sp,
                  color: AppThemes().primary)),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 4,
              child: MyText(
                text: info,
                type: FontType.bold,
                fontSize: 14.sp,
                color: AppThemes().green,
              ))
        ]));
  }
}

class EstablishmentBooking {
  final Establishment establishment;
  final String date;
  final String time;
  final String bookingDetails;

  const EstablishmentBooking(
      {required this.date,
      required this.establishment,
      required this.time,
      required this.bookingDetails});
}

class ScheduleFoodCongratulationsPage
    extends LayoutRouteWidget<ScheduleFoodController> {
  const ScheduleFoodCongratulationsPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final establishment = params as Establishment;

    return SizedBox(
        height: 100.h,
        child: Column(children: [
          SizedBox(height: 4.h),
          Image.asset('assets/icons/check.png', width: 20.w),
          SizedBox(height: 3.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  text: AppLocalizations.of(context)!.bookingFinished,
                  fontSize: 20.sp,
                  type: FontType.bold,
                  color: AppThemes().green)),
          SizedBox(height: 3.h),
          SizedBox(
              width: 70.w,
              child: MyRichText(
                  text: MyTextSpan(
                      align: TextAlign.center,
                      fontSize: 16.sp,
                      type: FontType.semibold,
                      color: AppThemes().primary,
                      text: AppLocalizations.of(context)!.youPaidBzc(
                          '${controller.menuPrice} BzCoins',
                          controller.getName()),
                      children: [
                    MyTextSpan(
                        fontSize: 16.sp,
                        type: FontType.bold,
                        color: AppThemes().green,
                        text: ' ${establishment.name}')
                  ]))),
          SizedBox(height: 2.h),
          SizedBox(
              width: 70.w,
              child: MyText(
                  align: TextAlign.center,
                  fontSize: 18.sp,
                  type: FontType.semibold,
                  color: AppThemes().primary,
                  text: '*${AppLocalizations.of(context)!.minimumOrders}')),
          const Expanded(child: SizedBox()),
          MyText(
              text: LocalizationFormatters.dateFormat2(DateTime.now()),
              color: AppThemes().primary,
              fontSize: 16.sp,
              type: FontType.semibold),
          SizedBox(height: 3.h),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BizneElevatedChildButton(
                  secondary: true,
                  onPressed: () =>
                      controller.contactBusiness(establishment.phone),
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.all(0.8.h),
                            child:
                                Image.asset('assets/icons/support_chat.png'))),
                    Expanded(
                        flex: 3,
                        child: MyText(
                            type: FontType.semibold,
                            fontSize: 12.sp,
                            color: AppThemes().primary,
                            text:
                                AppLocalizations.of(context)!.contactBusiness))
                  ]))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
              child: BizneElevatedButton(
                  onPressed: () => controller.navigate(home),
                  title: AppLocalizations.of(context)!.close))
        ]));
  }
}
