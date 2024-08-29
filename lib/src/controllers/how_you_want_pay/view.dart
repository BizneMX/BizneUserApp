import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowYouWantPayPage extends LayoutRouteWidget<HowYouWantPayController> {
  const HowYouWantPayPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as HowYouWantPayParams;

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
          height: 5.h,
        ),
        MyText(
          text: AppLocalizations.of(context)!.howDoYouWantPay,
          fontSize: 16.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          height: 3.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Obx(() =>
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SelectedPayItem(
                    image: Image.asset('assets/icons/cash_bank_terminal.png',
                        height: 15.w),
                    onPressed: () =>
                        controller.cashBankTerminalSelected.call(true),
                    selected: controller.cashBankTerminalSelected.value,
                    text: AppLocalizations.of(context)!.cashBankTerminal),
                SelectedPayItem(
                    image: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      child: Image.asset(
                        'assets/icons/my_app.png',
                        height: 11.w,
                      ),
                    ),
                    onPressed: currentParams.scanTicket.bizneApp
                        ? () => controller.cashBankTerminalSelected.call(false)
                        : null,
                    selected: !controller.cashBankTerminalSelected.value,
                    text: AppLocalizations.of(context)!.payWithMyApp)
              ])),
        ),
        ...currentParams.scanTicket.bizneApp
            ? [
                SizedBox(
                  height: 8.h,
                )
              ]
            : [
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: 70.w,
                  child: MyText(
                    align: TextAlign.center,
                    text: AppLocalizations.of(context)!
                        .onlyAcceptPaymentsInCashBankTerminal,
                    color: AppThemes().green,
                    type: FontType.semibold,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
        MyText(
          color: AppThemes().primary,
          align: TextAlign.center,
          text: AppLocalizations.of(context)!.totalToPay,
          fontSize: 16.sp,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          color: AppThemes().green,
          align: TextAlign.center,
          text: LocalizationFormatters.currencyFormat(
              currentParams.totalToPay.toDouble()),
          fontSize: 24.sp,
          type: FontType.bold,
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.continueButton(currentParams),
            title: AppLocalizations.of(context)!.continueText,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.popNavigate(),
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
  final Widget image;
  final String text;
  const SelectedPayItem(
      {super.key,
      required this.image,
      this.onPressed,
      required this.selected,
      required this.text});

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
                height: 5.w,
              ),
              image,
              MyText(
                align: TextAlign.center,
                fontSize: 10.sp,
                text: text,
                color: selected ? AppThemes().primary : AppThemes().notSelected,
                type: selected ? FontType.bold : FontType.regular,
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
