import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_cashback/controller.dart';
import 'package:bizne_flutter_app/src/models/scan_ticket.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentWithCashbackPage
    extends LayoutRouteWidget<PaymentWithCashBackController> {
  const PaymentWithCashbackPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final qrParams = params as ScanTicket;
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 30.w,
        ),
        SizedBox(
          height: 3.h,
        ),
        MyText(
          text: AppLocalizations.of(context)!.accountTotal,
          fontSize: 16.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          color: AppThemes().green,
          align: TextAlign.center,
          text:
              LocalizationFormatters.currencyFormat(qrParams.total.toDouble()),
          fontSize: 24.sp,
          type: FontType.bold,
        ),
        SizedBox(
          height: 6.h,
        ),
        MyText(
          color: AppThemes().primary,
          align: TextAlign.center,
          text: AppLocalizations.of(context)!.selectOneOption,
          fontSize: 16.sp,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Obx(() =>
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SelectedPayItem(
                  onPressed: () => controller.selectPay.call(false),
                  selected: !controller.selectPay.value,
                  text1: AppLocalizations.of(context)!.accumulate,
                  text2: LocalizationFormatters.numberFormat(
                      qrParams.cashback.toDouble(),
                      decimalDigits: 1),
                  text3: 'BZCoins',
                ),
                SelectedPayItem(
                  text1: AppLocalizations.of(context)!.payUpTo,
                  text2: LocalizationFormatters.currencyFormat(
                      qrParams.payWithPoints.toDouble(),
                      decimalDigits: 1),
                  text3: AppLocalizations.of(context)!.availableBZCoins,
                  onPressed: () => controller.selectPay.call(true),
                  selected: controller.selectPay.value,
                )
              ])),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.navigate(howYouWantPay,
                params: HowYouWantPayParams(
                    totalToPay: controller.selectPay.value
                        ? qrParams.total - qrParams.payWithPoints
                        : qrParams.total,
                    option: controller.selectPay.value ? 3 : 2,
                    scanTicket: qrParams)),
            title: AppLocalizations.of(context)!.continueText,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () {
              controller.navigate(home);
            },
            title: AppLocalizations.of(context)!.cancel,
            secondary: true,
          ),
        ),
        SizedBox(
          height: 5.h,
        )
      ],
    );
  }
}

class SelectedPayItem extends StatelessWidget {
  final Function()? onPressed;
  final bool selected;
  final String text1;
  final String text2;
  final String text3;
  const SelectedPayItem({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.onPressed,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 30.w,
          width: 30.w,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: AppThemes().white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                    side: selected
                        ? BorderSide(width: 2, color: AppThemes().secondary)
                        : BorderSide.none)),
            child: Column(children: [
              SizedBox(
                height: 3.w,
              ),
              MyText(
                align: TextAlign.center,
                fontSize: 10.sp,
                text: text1,
                color:
                    selected ? AppThemes().secondary : AppThemes().notSelected,
                type: selected ? FontType.bold : FontType.regular,
              ),
              SizedBox(
                height: 4.w,
              ),
              MyText(
                align: TextAlign.center,
                fontSize: 14.sp,
                text: text2,
                color: AppThemes().primary,
                type: FontType.bold,
              ),
              SizedBox(
                height: 2.w,
              ),
              SizedBox(
                width: 20.w,
                child: MyText(
                  align: TextAlign.center,
                  fontSize: 10.sp,
                  text: text3,
                  color: AppThemes().notSelected,
                ),
              ),
            ]),
          ),
        ),
        SizedBox(
          height: 5.sp,
        ),
      ],
    );
  }
}
